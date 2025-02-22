import 'dart:async';

import 'dart:developer';

import 'package:alamoody/core/helper/print.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:just_audio/just_audio.dart';

import 'package:just_audio_background/just_audio_background.dart';

import '../../../features/download_songs/data/models/downloaded_song_model.dart';

import '../../../features/radio/domain/entities/radio_category.dart';

import '../../entities/songs.dart';

import '../../models/song_share_model.dart';

class MainController extends ChangeNotifier {
  static final MainController _instance = MainController._internal();

  factory MainController() {
    return _instance;
  }

  MainController._internal() {
    _initPlayer();
  }

  final AudioPlayer player = AudioService().player; // Use singleton instance

  bool isLooping = false; // Track loop state

  // late ConcatenatingAudioSource playlist;

  late List<AudioSource> audios = [
    _createAudioSource(
      id: '-1',
      title: 'Welcome Here',
      artist: 'Ansh Rathod',
      album: 'OnlineAlbum',
      streamUrl:
          'https://cdn.pixabay.com/download/audio/2022/01/20/audio_f1b4f4c8b1.mp3?filename=welcome-to-the-games-15238.mp3',
      artworkUrl:
          'https://images.unsplash.com/photo-1611339555312-e607c8352fd7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
      favorite: false,
      listened: 1,
      lyrics: '',
    )
  ];

  final List<StreamSubscription> _subscriptions = [];

  int? get currentIndex => player.currentIndex;

  void _initPlayer() {
    printColored('Using Singleton AudioPlayer', colorCode: 32);
  }

  // Getter for checking if the player is currently playing

  bool get isPlaying => player.playing;

  List<dynamic> getRecentlyPlayed() {
    final box = Hive.box('RecentlyPlayed');

    return List.generate(box.length, (i) => box.getAt(i));
  }

  Future<void> clearRecentlyPlayed() async {
    printColored('clean cache /n \n' * 200);

    final box = Hive.box('RecentlyPlayed');

    await box.clear();

    notifyListeners();
  }

  // void updatePlaybackState() {
  //   // Check the current state of the player

  //   printColored(player.processingState);

  //   if (isPlaying) {
  //     printColored("Audio is playing");
  //   } else if (player.processingState == ProcessingState.completed) {
  //     printColored("Audio has completed");
  //   } else if (player.processingState == ProcessingState.buffering) {
  //     printColored("Audio is buffering");
  //   } else if (player.processingState == ProcessingState.idle) {
  //     printColored("Audio player is idle");
  //   } else if (player.processingState == ProcessingState.loading ||
  //       player.processingState == ProcessingState.buffering) {
  //     printColored("Audio is loading");
  //   } else if (player.processingState == ProcessingState.ready) {
  //     printColored("Audio is ready to play");
  //   }

  //   // Notifying listeners for UI updates (for example, changing the play/pause button)

  //   notifyListeners();
  // }

  List<AudioSource> convertLocalSongToAudio(List songs) {
    return songs.map((audio) {
      return _createAudioSource(
        id: audio['id'].toString(),
        title: audio['songname'],
        artist: audio['fullname'],
        album: audio['username'].toString(),
        streamUrl: audio['track'],
        artworkUrl: audio['cover'],
        favorite: audio['favorite'] ?? false,
        listened: audio['listened'] ?? 0,
        lyrics: audio['lyrics'] ?? '',
      );

      // return AudioSource.uri(

      //   Uri.parse(audio['track']),

      //   tag: MediaItem(

      //     id: audio['id'],

      //     title: audio['songname'],

      //     artist: audio['fullname'],

      //     album: audio['username'],

      //     artUri: Uri.parse(audio['cover']),

      //     extras: {

      //       "favorite": audio['favorite'],

      //       "listened": audio['listened'],

      //       'lyrics': audio['lyrics'],

      //     },

      //   ),

      // );
    }).toList();
  }

  void init() async {
    // playlist = ConcatenatingAudioSource(children: audios);

    _subscriptions.add(
      player.currentIndexStream.listen((index) async {
        if (index != null && index != -1) {
          if (player.audioSource != null &&
              player.audioSource!.sequence.isNotEmpty) {
            final myAudio =
                player.audioSource!.sequence[index] as UriAudioSource;

            final box = Hive.box('RecentlyPlayed');

            if (myAudio.tag.id != '-1' &&
                !myAudio.uri.toString().contains('liveStream') &&
                !myAudio.uri.toString().contains('file')) {
              await box.put(myAudio.tag.title, {
                "songname": myAudio.tag.title,
                "fullname": myAudio.tag.artist,
                "username": myAudio.tag.album,
                "cover": myAudio.tag.artUri.toString(),
                "track": myAudio.uri.toString(),
                "id": myAudio.tag.id,
                'extras': {
                  'favorite': myAudio.tag.extras['favorite'],

                  'listened': myAudio.tag.extras['listened'],

                  // 'audio': json.encode(myAudio.tag.extras['audio']),
                },
                "created": DateTime.now().toString(),
              });
            }
          } else {
            _initPlayer();

            log('Player audio source is null or empty');
          }
        }
      }),
    );

    final recentSongs = getRecentlyPlayed();

    recentSongs.sort((a, b) => b["created"].compareTo(a["created"]));

    if (recentSongs.isNotEmpty) {
      print("recentSongs $recentSongs");

      audios.removeAt(0);
    }

    audios.addAll(convertLocalSongToAudio(recentSongs));

    await openPlayer(newlist: audios);
  }

  UriAudioSource? audio;

  Future<void> openPlayer({
    required List<AudioSource> newlist,
    int initial = 0,
  }) async {
    if (player.processingState == ProcessingState.ready) {
      log('Player is already initialized.');

      return; // ✅ Prevents re-initialization
    }

    final currentAudioSource = player.audioSource;

    // ✅ Check if the current playlist is the same as the new one
    if (currentAudioSource is ConcatenatingAudioSource) {
      bool isSamePlaylist = currentAudioSource.length == newlist.length &&
          currentAudioSource.sequence.every((existingAudio) => newlist.any(
              (newAudio) =>
                  (existingAudio as UriAudioSource).uri.toString() ==
                  (newAudio as UriAudioSource).uri.toString()));

      if (isSamePlaylist) {
        // ✅ Check if the selected track is already in the playlist
        for (int i = 0; i < currentAudioSource.length; i++) {
          final UriAudioSource existingAudio =
              currentAudioSource.sequence[i] as UriAudioSource;
          final UriAudioSource newAudio = newlist[initial] as UriAudioSource;

          if (existingAudio.uri.toString() == newAudio.uri.toString()) {
            log('Track already in the playlist. Skipping to index: $i');
            await player.seek(Duration.zero, index: i); // ✅ Skip to track
            await player.play();
            return; // ✅ Prevent reinitialization
          }
        }
      }
    }
    try {
      if (player.playing) {
        await player.pause();

        await player.stop();

        await Future.delayed(const Duration(milliseconds: 300));
      }

      log('Setting new audio source');

     await player.setAudioSource(
      ConcatenatingAudioSource(children: newlist),
      initialIndex: initial,
    ).catchError((error, stackTrace) {
      AudioErrorHandler.handleError(error, stackTrace, player);
      throw error;
    });

    // Add validation for audio source
    if (player.audioSource?.sequence.isEmpty ?? true) {
      log('Invalid audio source list');
      await player.stop();
      return;
    }

      log('Audio is ready to play' * 10);
    } on PlatformException catch (e) {
       AudioErrorHandler.handleError(e, StackTrace.current, player);
    await _handlePlaybackFailure();
    } on Exception catch (e) {
      AudioErrorHandler.handleError(e, StackTrace.current , player);
    await _handlePlaybackFailure();
      log('Unexpected error: $e' * 10);
    }
  }
Future<void> _handlePlaybackFailure() async {
  try {
    // Wait for player to settle
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (player.hasNext && player.sequence!.length > 1) {
      log('Attempting to skip to next track');
      await player.seekToNext();
      await player.play();
    } else {
      log('Resetting audio player');
      await player.stop();
      audios.clear();
      notifyListeners();
    }
  } catch (e) {
    log('Recovery failure: $e');
    await player.stop();
  }
}
  Future<void> openRadioPlayer({
    required List<AudioSource> newlist,
    int initial = 0,
  }) async {
    try {
      await player.setAudioSource(
        ConcatenatingAudioSource(children: newlist),
        initialIndex: initial,
      );

      if (player.duration == null) {
        log('The audio file has errors');
      } else {
        print('The audio file is ready to play');
      }
    } catch (e) {
      log('Error opening the radio player: $e');
    }
  }

Future<void> playSong(List<AudioSource> newPlaylist, int initial) async {
  if (newPlaylist.isEmpty || initial < 0 || initial >= newPlaylist.length) {
    log('Invalid playlist or initial index');
    await player.stop();
    return;
  }

  try {
    final audioSource = newPlaylist[initial];
    if (audioSource is! UriAudioSource) {
      throw ArgumentError('Invalid audio source type');
    }

    await _performSafeAudioOperation(() async {
      await player.stop();
      audios = newPlaylist;
      await openPlayer(newlist: newPlaylist, initial: initial);
      await player.play().catchError((e, s) {
        AudioErrorHandler.handleError(e, s, player);
        _handlePlaybackFailure();
      });
    });
  } catch (e, s) {
    AudioErrorHandler.handleError(e, s, player);
    await _handlePlaybackFailure();
  }
}
Future<void> _performSafeAudioOperation(Future<void> Function() operation) async {
  try {
    // Ensure player is in valid state
    if (player.processingState == ProcessingState.loading) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    
    await operation();
    
    // Verify successful operation
    if (player.processingState == ProcessingState.idle) {
      throw Exception('Operation resulted in idle state');
    }
  } on PlatformException catch (e) {
    AudioErrorHandler.handleError(e, StackTrace.current, player);
    await _handlePlaybackFailure();
  } catch (e, s) {
    AudioErrorHandler.handleError(e, s, player);
    await _handlePlaybackFailure();
  }
}
  void playRadio(List<AudioSource> newPlaylist, int initial) async {
    log('Initializing radio stream');

    // Stop any existing playback.

    await player.pause();

    await player.stop();

    // Get the initial stream URL and open the player.

    final UriAudioSource audio = newPlaylist[initial] as UriAudioSource;

    await openRadioPlayer(newlist: newPlaylist);

    // Start playing the radio.

    await player.play();

    log('Radio stream started');
  }

  void addToPlaylist(song) {
    final currentAudioSource = player.audioSource! as ConcatenatingAudioSource;

    currentAudioSource.add(convertToAudio([song])[0]);

    notifyListeners();
  }

  List<AudioSource> convertToAudio<T>(List<T> items) {
    return items.map((item) {
      if (item is Songs) {
        return _createAudioSource(
          id: item.id.toString(),
          title: item.title ?? "Unknown Title",
          artist: (item.artists?.isNotEmpty ?? false)
              ? item.artists![0].name!
              : "Unknown",
          album: item.id.toString(),
          streamUrl: item.streamUrl ?? "",
          artworkUrl: item.artworkUrl,
          favorite: item.favorite ?? false,
          listened: item.listened ?? 0,
          lyrics: item.lyrics ?? "",
        );
      } else if (item is DownloadedMusicModel) {
        return _createAudioSource(
          isFile: true,
          id: item.id.toString(),
          title: item.title ?? "Unknown Title",
          artist: item.artists!.isEmpty ? 'unkown' : item.artists!,
          album: item.id.toString(),
          streamUrl: item.path ??
              "http://islamicaudio.net/assets/media/yom-alfrkan866.mp3",
          artworkUrl: item.image!,
        );
      } else if (item is RadioCategory) {
        return _createAudioSource(
          id: item.id.toString(),
          title: item.title ?? "Unknown Title",
          artist: item.description?.isNotEmpty == true
              ? item.description!
              : "Unknown Artist",
          album: item.id.toString(),
          streamUrl: item.streamUrl ?? "",
          artworkUrl: item.artworkUrl,
        );
      } else if (item is SongsShareData) {
        return _createAudioSource(
          id: item.id.toString(),
          title: item.title ?? "Unknown Title",
          artist: item.artist ?? "Unknown Artist",
          album: item.id.toString(),
          streamUrl: item.streamUrl ?? "",
          artworkUrl: item.artworkUrl,
        );
      } else {
        throw ArgumentError("Unsupported type: ${item.runtimeType}");
      }
    }).toList();
  }

  Future<void> playOrPause() async {
    try {
      if (isPlaying) {
        await player.pause();

        log("Playback paused");
      } else {
        await player.play();

        log("Playback started");
      }
    } catch (e) {
      log("Error while trying to play or pause: $e");
    }
  }

  /// Plays the next track in the playlist
 Future<void> onNext() async {
    if (player.hasNext) {
      await player.seekToNext();
    } else {
      log("No more tracks in playlist");
    }
    notifyListeners();
  }
  Future<void> onPrevious() async {
    try {
      final hasPrevious = player.hasPrevious;

      if (hasPrevious) {
        await player.seekToPrevious();

        log("Moved to previous track");
      } else {
        log("No previous track available");
      }
    } catch (e) {
      log("Error moving to previous track: $e");
    }

    notifyListeners();
  }

  Future<void> toggleLoop() async {
    if (player.loopMode == LoopMode.off) {
      player.setLoopMode(LoopMode.one); // Loop current track

      isLooping = true;

      log("Looping current track");
    } else if (player.loopMode == LoopMode.one) {
      player.setLoopMode(LoopMode.all); // Loop playlist

      log("Looping entire playlist");
    } else {
      player.setLoopMode(LoopMode.off); // Turn off looping

      isLooping = false;

      log("Looping off");
    }

    notifyListeners(); // Update UI
  }

  Future<void> playAudio(int index) async {
    if (index < 0 || index >= audios.length) {
      log('Invalid index');

      return;
    }

    try {
      await player.setAudioSource(
        ConcatenatingAudioSource(children: audios),
        initialIndex: index,
      );

      await player.play();

      log('Playing audio at index $index');
    } catch (e) {
      log('Error playing audio: $e');
    }
  }

  void addAudioToQueue(Songs song) {
    audios.add(convertToAudio([song])[0]);

    log('Audio added to queue');

    notifyListeners();
  }

  void removeAudioFromQueue(int index) {
    if (index < 0 || index >= audios.length) {
      log('Invalid index');

      return;
    }

    audios.removeAt(index);

    log('Audio removed from queue');

    notifyListeners();
  }

  void addOrMoveSongToQueue(Songs song) {
    final currentAudioSource = player.audioSource! as ConcatenatingAudioSource;

    // Check if the song is already in the queue

    final bool songExistsInQueue = currentAudioSource.sequence.any(
      (audio) => (audio as UriAudioSource).tag.id == song.id.toString(),
    );

    printColored('currentIndex' * 10);

    printColored(currentIndex.toString());

    printColored('songExistsInQueue' * 10);

    printColored(songExistsInQueue.toString());

    // If song exists in queue, move it to the index after current

    if (songExistsInQueue) {
      final int currentIndex = player.currentIndex!;

      final UriAudioSource songToMove =
          findById(currentAudioSource.sequence, song.id.toString());

      // Remove the song from its current position

      currentAudioSource.removeAt(currentIndex);

      // Insert the song after the current index

      currentAudioSource.insert(currentIndex + 1, songToMove);
    }

    // If the song doesn't exist in the queue, add it

    else {
      currentAudioSource.insert(currentIndex! + 1, convertToAudio([song])[0]);
    }

    // Notify listeners after modifying the queue

    notifyListeners();
  }

  UriAudioSource findById(List<AudioSource> sequence, String songId) {
    return sequence
        .whereType<
            UriAudioSource>() // Ensure only UriAudioSource objects are considered

        .firstWhere(
          (element) => element.tag.id == songId,
          orElse: () => throw Exception('Song not found in queue'),
        );
  }

  void loginPlayer() async {
    // Initialize any data that needs to be refreshed on login

    init(); // Call the init method to load data from scratch

    notifyListeners();
  }

  void closePlayer() {
    // Stop audio and clear the playlist

    clearRecentlyPlayed();

    player.stop();

    for (final sub in _subscriptions) {
      sub.cancel();
    }

    // Other state cleanup as needed

    notifyListeners();
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      if (!sub.isPaused) {
        // ✅ Check before canceling

        sub.cancel();
      }
    }

    _subscriptions.clear();

    if (player.playing || player.processingState != ProcessingState.idle) {
      try {
        player.stop();
      } catch (e) {
        log('Error stopping player: $e');
      }
    }

    try {
      player.dispose();
    } catch (e) {
      log('Error disposing player: $e');
    }

    super.dispose();
  }

  AudioSource _createAudioSource({
    required String id,
    required String title,
    required String artist,
    required String album,
    required String streamUrl,
    String? artworkUrl,
    bool favorite = false,
    int listened = 0,
    String lyrics = "",
    bool isFile = false,
  }) {
    final String validUrl = streamUrl.isNotEmpty
        ? streamUrl
        : "http://islamicaudio.net/assets/media/yom-alfrkan866.mp3"; // Fallback URL

    return AudioSource.uri(
      isFile ? Uri.file(validUrl) : Uri.parse(validUrl),
      tag: MediaItem(
        id: id,
        title: title.isNotEmpty ? title : "Unknown Title",
        artist: artist.isNotEmpty ? artist : "Unknown Artist",
        album: album,
        artUri: (artworkUrl?.isNotEmpty == true)
            ? isFile
                ? Uri.file(artworkUrl!)
                : Uri.parse(artworkUrl!)
            : null,
        extras: {
          "favorite": favorite,
          "listened": listened,
          'lyrics': lyrics,
        },
      ),
    );
  }
}

class AudioService {
  static final AudioService _instance = AudioService._internal();

  static bool _isInitialized = false; // Prevents re-initialization

  late final AudioPlayer player;

  factory AudioService() {
    return _instance;
  }

  AudioService._internal() {
    if (!_isInitialized) {
      player = AudioPlayer();

      _isInitialized = true;
    }
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await player.dispose();

      _isInitialized = false;
    }
  }
}
class AudioErrorHandler {
  static void handleError(Object error, StackTrace stackTrace, AudioPlayer player) {
    log('Audio Error: $error', stackTrace: stackTrace);
    player.stop().catchError((e) => log('Stop error: $e'));
    // Add any additional error reporting here
  }
}