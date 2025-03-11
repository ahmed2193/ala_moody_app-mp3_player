import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../config/locale/app_localizations.dart';
import '../../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../../features/home/presentation/cubits/save_song_on_track_play/save_song_on_track_play_cubit.dart';
import '../../helper/font_style.dart';
import '../app_strings.dart';
import '../controllers/main_controller.dart';
import '../hex_color.dart';

class PlayWidget extends StatefulWidget {
  final MainController con;
  final void Function()? onTap;

  const PlayWidget({
    Key? key,
    required this.con,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PlayWidget> createState() => _PlayWidgetState();
}

class _PlayWidgetState extends State<PlayWidget> {
  String durationToString(Duration duration) {
    String twoDigits(int n) {
      return n >= 10 ? '$n' : '0$n';
    }

    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  double _offsetX = 0.0;

  void _resetPosition() {
    setState(() {
      _offsetX = 0.0;
    });
  }

  void _onSwipeLeft() {
    widget.con.player.stop(); // Stop player on left swipe
    debugPrint("Swiped left, player stopped");
  }

  void _onSwipeRight() {
    widget.con.player.stop(); // Stop player on right swipe
    debugPrint("Swiped right, player stopped");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: widget.con.player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        final currentSource = state.currentSource;

        final isRadioStream = currentSource is UriAudioSource &&
            currentSource.uri.toString().contains('stream');
        final isFile = currentSource is UriAudioSource &&
            currentSource.uri.toString().startsWith('file://');

        final artUri = metadata.artUri?.toString() ?? '';
        final title = metadata.title ?? 'Unknown Title';
        // printColored(metadata.extras!['listened']*100);
        // printColored('listened'*100);
        // printColored(metadata.extras!['listened']);
        isFile || isRadioStream
            ? null
            : metadata.extras!['listened'] == 0
                ? {
                    BlocProvider.of<SaveSongOnTrackPlayCubit>(
                      context,
                    ).saveSongOnTrackPlay(
                      id: metadata.id ?? '0',
                      type: AppStrings.song,
                      accessToken: context
                          .read<LoginCubit>()
                          .authenticatedUser!
                          .accessToken!,
                    ),
                    metadata.extras!['listened'] = 1,
                  }
                : null;

        final String imageUrl =
            isFile ? artUri.replaceAll("file:///storage", "/storage") : artUri;

        return StreamBuilder<PlayerState>(
          stream: widget.con.player.playerStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state?.processingState == ProcessingState.idle) {
              return const SizedBox();
            }

            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _offsetX += details.primaryDelta ?? 0;
                });
              },
              onHorizontalDragEnd: (details) {
                if (_offsetX < -100) {
                  _onSwipeLeft(); // Swipe left action
                } else if (_offsetX > 100) {
                  _onSwipeRight(); // Swipe right action
                }
                _resetPosition(); // Reset position after swipe
              },
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.translationValues(_offsetX, 0, 0),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: HexColor('#1B0E3E'),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: artUri.isNotEmpty
                          ? isFile
                              ? Image.file(
                                  File(imageUrl),
                                  width: 45,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 45,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StreamBuilder<Duration>(
                        stream: widget.con.player.positionStream,
                        builder: (context, positionSnapshot) {
                          final currentPosition =
                              positionSnapshot.data ?? Duration.zero;
                          final totalDuration =
                              widget.con.player.duration ?? Duration.zero;

                          final formattedCurrentPosition =
                              durationToString(currentPosition);
                          final formattedTotalDuration =
                              durationToString(totalDuration);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: styleW400(
                                  context,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isRadioStream)
                                Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 5,
                                          width: 5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: HexColor('#4BDA73'),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate("live")!,
                                          style:
                                              styleW400(context, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  '$formattedCurrentPosition / $formattedTotalDuration',
                                  style: styleW400(
                                    context,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    StreamBuilder<PlayerState>(
                      stream: widget.con.player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            child: const CircularProgressIndicator(),
                          );
                        } else if (playing != true) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            color: Colors.white,
                            onPressed: widget.con.player.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return IconButton(
                            icon: const Icon(Icons.pause),
                            color: Colors.white,
                            onPressed: widget.con.player.pause,
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.replay),
                            color: Colors.white,
                            onPressed: () => widget.con.player.seek(
                              Duration.zero,
                              index: widget.con.player.effectiveIndices!.first,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
