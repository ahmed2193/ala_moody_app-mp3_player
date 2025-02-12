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
  MainController() {
    _initPlayer();
  }
  bool isLooping = false; // Track loop state

  // late ConcatenatingAudioSource playlist;
  List<AudioSource> audios = [
    AudioSource.uri(
      Uri.parse(
        'https://cdn.pixabay.com/download/audio/2022/01/20/audio_f1b4f4c8b1.mp3?filename=welcome-to-the-games-15238.mp3',
      ),
      tag: MediaItem(
        id: '-1',
        title: 'Welcome Here',
        artist: 'Ansh Rathod',
        album: 'OnlineAlbum',
        artUri: Uri.parse(
          'https://images.unsplash.com/photo-1611339555312-e607c8352fd7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
        ),
        extras: {
          "favorite": false,
          "listened": 1,
          'lyrics': '',
          // 'audio': const Songs(
          //   streamUrl:
          //       'https://cdn.pixabay.com/download/audio/2022/01/20/audio_f1b4f4c8b1.mp3?filename=welcome-to-the-games-15238.mp3',
          //   id: -1,
          //   listened: 1,
          //   favorite: false,
          //   title: 'Welcome Here',
          //   artworkUrl:
          //       'https://images.unsplash.com/photo-1611339555312-e607c8352fd7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
          // ),
        },
      ),
    ),
  ];
  AudioPlayer? player;
  final List<StreamSubscription> _subscriptions = [];
  int? get currentIndex => player!.currentIndex;
void _initPlayer() {
  if (player != null) {
    // If the player already exists, just return
    if (player!.playing) {
      printColored('AudioPlayer is currently playing. Player will not be reinitialized.', colorCode: 31);
      return;
    } else {
      printColored('AudioPlayer exists but is not playing. Reinitializing...', colorCode: 31);
    }
  }

  // Initialize the player only if it's null or disposed
  player = AudioPlayer();
  printColored('AudioPlayer initialized successfully', colorCode: 32);
}

  // Getter for checking if the player is currently playing
  bool get isPlaying => player!.playing;
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

  void updatePlaybackState() {
    // Check the current state of the player
    printColored(player!.processingState);
    if (player!.playing) {
      printColored("Audio is playing");
    } else if (player!.processingState == ProcessingState.completed) {
      printColored("Audio has completed");
    } else if (player!.processingState == ProcessingState.buffering) {
      printColored("Audio is buffering");
    } else if (player!.processingState == ProcessingState.idle) {
      printColored("Audio player is idle");
    } else if (player!.processingState == ProcessingState.loading||player!.processingState == ProcessingState.buffering) {
      printColored("Audio is loading");
    } else if (player!.processingState == ProcessingState.ready) {
      printColored("Audio is ready to play");
    }

    // Notifying listeners for UI updates (for example, changing the play/pause button)
    notifyListeners();
  }

  List<AudioSource> convertLocalSongToAudio(List songs) {
    return songs.map((audio) {
      return AudioSource.uri(
        Uri.parse(audio['track']),
        tag: MediaItem(
          id: audio['id'],
          title: audio['songname'],
          artist: audio['fullname'],
          album: audio['username'],
          artUri: Uri.parse(audio['cover']),
          extras: {
            "favorite": audio['favorite'],
            "listened": audio['listened'],
            'lyrics': audio['lyrics'],
          },
        ),
      );
    }).toList();
  }

  void init() async {
    // playlist = ConcatenatingAudioSource(children: audios);
    _subscriptions.add(
      player!.currentIndexStream.listen((index) async {
        if (index != null && index != -1) {
          if (player!.audioSource != null &&
              player!.audioSource!.sequence.isNotEmpty) {
            final myAudio =
                player!.audioSource!.sequence[index] as UriAudioSource;
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
    updatePlaybackState();
    if (player == null) {
      log('Audio player is null, cannot proceed');
      return; // Return early if the player is not initialized
    }

    log(player!.toString());
    if (newlist.isEmpty || initial < 0 || initial >= newlist.length) {
      log('Invalid audio source list or initial index');
      return;
    }

    try {
      // Stop the player if it is already playing to avoid conflicts
      if (player!.playing) {
        await player!.pause();
        await player!.stop();
        log('Player stopped before setting new audio source');
      }

      log('Setting audio source: $newlist');
      // Set the new audio source
      await player!.setAudioSource(
        ConcatenatingAudioSource(children: newlist),
        initialIndex: initial,
      );

      log('The audio file is ready to play');
    } on PlatformException catch (e) {
      log('Error opening the audio file: ${e.message}');
    } on Exception catch (e) {
      log('Unexpected error: $e');
    }
  }

  Future<void> openRadioPlayer({
    required List<AudioSource> newlist,
    int initial = 0,
  }) async {
    try {
      await player!.setAudioSource(
        ConcatenatingAudioSource(children: newlist),
        initialIndex: initial,
      );
      if (player!.duration == null) {
        log('The audio file has errors');
      } else {
        print('The audio file is ready to play');
      }
    } catch (e) {
      log('Error opening the radio player: $e');
    }
  }

  Future<void> openSelected({
    required UriAudioSource audio,
  }) async {
    try {
      await player!.setAudioSource(audio);
    } catch (e) {
      log('Error opening the selected audio: $e');
    }
  }

  Future<void> playSong(List<AudioSource> newPlaylist, int initial) async {
    if (newPlaylist.isEmpty || initial < 0 || initial >= newPlaylist.length) {
      log('Invalid playlist or initial index');
      return;
    }
    final audioSource = newPlaylist[initial];
    if (audioSource is UriAudioSource) {
      await player!.pause();
      await player!.stop();
      audios = newPlaylist;
      await openPlayer(newlist: newPlaylist, initial: initial);
      await player!.play();
    } else {
      log('Error: The provided audio source is not of type UriAudioSource');
    }
  }

  void playRadio(List<AudioSource> newPlaylist, int initial) async {
    log('Initializing radio stream');

    // Stop any existing playback.
    await player!.pause();
    await player!.stop();

    // Get the initial stream URL and open the player!.
    final UriAudioSource audio = newPlaylist[initial] as UriAudioSource;
    await openRadioPlayer(newlist: newPlaylist);

    // Start playing the radio.
    await player!.play();
    log('Radio stream started');
  }

  void changeIndex(int newIndex, int oldIndex) {
    final currentAudioSource = player!.audioSource! as ConcatenatingAudioSource;
    final removedAudio = currentAudioSource.sequence[oldIndex];
    currentAudioSource.removeAt(oldIndex);
    currentAudioSource.insert(newIndex, removedAudio);
    notifyListeners();
  }

  

  void addToPlaylist(song) {
    final currentAudioSource = player!.audioSource! as ConcatenatingAudioSource;
    currentAudioSource.add(convertToAudio([song])[0]);
    notifyListeners();
  }

  UriAudioSource find(List<AudioSource> source, String fromPath) {
    return source.firstWhere(
      (element) => (element as UriAudioSource).uri.toString() == fromPath,
    ) as UriAudioSource;
  }

  UriAudioSource findByname(List<AudioSource> source, String fromPath) {
    return source.firstWhere(
      (element) => (element as UriAudioSource).tag.title == fromPath,
    ) as UriAudioSource;
  }

  List<AudioSource> convertToAudio(List<Songs> songs) {
    return songs.map((audio) {
      printColored(audio.artworkUrl );
              printColored(audio.listened*100);

      return AudioSource.uri(
        Uri.parse(
          audio.audio ??
              "http://islamicaudio.net/assets/media/yom-alfrkan866.mp3",
        ),
        tag: MediaItem(
          id: audio.id.toString(),
          title: audio.title!,
          artist: audio.artists!.isEmpty ? 'unkown' : audio.artists![0].name,
          album: audio.id.toString(),
          artUri: Uri.parse(audio.artworkUrl!),
          extras: {
            "favorite": audio.favorite ?? false, // Default to false if null
            "listened":
                audio.listened ?? 0, // Default listen count to 0 if null
            'lyrics': audio.lyrics ??
                "", // Default to empty string if no lyrics provided
            // 'audio': audio??null,
          },
        ),
      );
    }).toList();
  }

  List<AudioSource> convertToAudioLocal(List<DownloadedMusicModel> songs) {
    return songs.map((audio) {
      printColored(audio);
      printColored(audio.path);
      printColored(audio.image);
      return AudioSource.uri(
        Uri.file(
          audio.path ??
              "http://islamicaudio.net/assets/media/yom-alfrkan866.mp3",
        ),
        tag: MediaItem(
          id: audio.id.toString(),
          title: audio.title!,
          artist: audio.artists!.isEmpty ? 'unkown' : audio.artists!,
          album: audio.id.toString(),
          artUri: Uri.file(audio.image!),
          extras: {'lyrics': ''},
        ),
      );
    }).toList();
  }

  List<AudioSource> convertToAudioForRadio(List<RadioCategory> radio) {
    return radio.map((audio) {
      return AudioSource.uri(
        Uri.parse(
          audio.streamUrl ??
              "http://islamicaudio.net/assets/media/yom-alfrkan866.mp3",
        ),
        tag: MediaItem(
          id: audio.id.toString(),
          title: audio.title ?? 'Unknown Title',
          artist: audio.description?.isEmpty == true
              ? 'Unknown Artist'
              : audio.description,
          album: audio.id.toString(),
          artUri: Uri.parse(
            audio.artworkUrl ?? 'https://example.com/default_artwork.jpg',
          ),
          extras: {},
        ),
      );
    }).toList();
  }

  List<AudioSource> convertShareDataToAudio(List<SongsShareData> songs) {
    return songs.map((songData) {
      printColored(songData);

      return AudioSource.uri(
        Uri.parse(
          songData.streamUrl ??
              "http://islamicaudio.net/assets/media/yom-alfrkan866.mp3",
        ) // Fallback stream URL if none is provided
        ,
        tag: MediaItem(
          id: songData.id,
          title: songData.title ?? "Unknown Title", // Default title if null
          artist: songData.artist ?? "Unknown Artist", // Default artist if null
          album:
              songData.id, // Using ID as album name (can be adjusted as needed)

          artUri: songData.artworkUrl != null
              ? Uri.parse(
                  songData.artworkUrl,
                )
              : null,

          extras: {
            "favorite": songData.favorite ?? false, // Default to false if null
            "listened":
                songData.listened ?? 0, // Default listen count to 0 if null
            'lyrics': songData.lyrics ??
                "", // Default to empty string if no lyrics provided
            // 'audio': songData,
          },
        ),
      );
    }).toList();
  }

  Future<void> playOrPause() async {
    try {
      if (player!.playing) {
        await player!.pause();
        log("Playback paused");
      } else {
        await player!.play();
        log("Playback started");
      }
    } catch (e) {
      log("Error while trying to play or pause: $e");
    }
  }

  /// Plays the next track in the playlist
  Future<void> onNext() async {
    printColored('player!.audioSource!.sequence.length');
    // printColored(player!.audioSource!.sequence.length);
    // printColored(player!.audioSource!.sequence.first.tag);

    try {
      final hasNext = player!.hasNext;
      if (hasNext) {
        await player!.seekToNext();
        log("Moved to next track");
      } else {
        log("No more tracks in playlist");
      }
    } catch (e) {
      log("Error moving to next track: $e");
    }
    notifyListeners();
  }

  Future<void> onPrevious() async {
    try {
      final hasPrevious = player!.hasPrevious;
      if (hasPrevious) {
        await player!.seekToPrevious();
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
    if (player!.loopMode == LoopMode.off) {
      player!.setLoopMode(LoopMode.one); // Loop current track
      isLooping = true;
      log("Looping current track");
    } else if (player!.loopMode == LoopMode.one) {
      player!.setLoopMode(LoopMode.all); // Loop playlist
      log("Looping entire playlist");
    } else {
      player!.setLoopMode(LoopMode.off); // Turn off looping
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
      await player!.setAudioSource(
        ConcatenatingAudioSource(children: audios),
        initialIndex: index,
      );
      await player!.play();
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
    final currentAudioSource = player!.audioSource! as ConcatenatingAudioSource;

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
      final int currentIndex = player!.currentIndex!;
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
    player!.stop();

    for (final sub in _subscriptions) {
      sub.cancel();
    }
    // Other state cleanup as needed
    notifyListeners();
  }
  @override
void dispose() {
  for (final sub in _subscriptions) {
    sub.cancel();
  }

  player?.dispose();  // Properly dispose of the player to avoid memory leaks
  super.dispose();
}
}
