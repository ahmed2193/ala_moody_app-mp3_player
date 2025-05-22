import 'dart:developer';
import 'dart:io';

import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/hex_color.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/play_list.dart';
import '../../../auth/presentation/widgets/gradient_auth_button.dart';
import '../../../drawer/presentation/screens/drawer_screen.dart';
import '../../../main_layout/cubit/tab_cubit.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import 'items/control_player_section.dart';
import 'items/favourite_in_player_section.dart';
import 'items/first_section.dart';
import 'items/slider_player_reuse.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    Key? key,
    required this.con,
    // required this.audioPlayer,
    // required this.playlist,
  }) : super(key: key);
  final MainController con;
  // final AudioPlayer audioPlayer;
  // final ConcatenatingAudioSource playlist;
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Set width and height as a percentage of screen size
    final double logicalWidthSize = screenWidth * 0.9; // 90% of screen width
    final double logicalHeightSize =
        screenHeight * 0.15; // 50% of screen height
    bool isLyrics = false;
    final bool isPremium = context
                .read<ProfileCubit>()
                .userProfileData!
                .user!
                .subscription!
                .serviceId ==
            '1'
        ? false
        : true;

    return Container(
      child: StreamBuilder<SequenceState?>(
        stream: widget.con.player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return const SizedBox();
          }
          final metadata = state!.currentSource!.tag as MediaItem;
          final playerState = snapshot;

          final currentSource = state.currentSource;

          final isFile = currentSource is UriAudioSource &&
              currentSource.uri.toString().startsWith('file://');
          String? streamUrl;
          if (currentSource != null && currentSource is UriAudioSource) {
            streamUrl = currentSource.uri.toString();
            // printColored('Current audio URL: $streamUrl');
          } else {
            debugPrint('No audio source or unsupported source type');
          }
          printColored('Current audio URL: $streamUrl');

          // Determine if the current source is an MP3 or a radio stream

          // Extract the current media item metadata
          final currentMediaItem = currentSource?.tag as MediaItem?;
          final artUri = currentMediaItem?.artUri?.toString() ?? '';
          final title = currentMediaItem?.title ?? 'Unknown Title';
          final artist = currentMediaItem?.artist ?? 'Unknown Artist';
          final lyrics = currentMediaItem?.extras!['lyrics'] ?? '';

          // Log the extras if available for debugging
          printColored(currentMediaItem?.extras ?? 'null');
          printColored(streamUrl ?? 'null');
          printColored(artUri ?? 'null');
          final String imageUrl = isFile
              ? artUri.replaceAll("file:///storage", "/storage")
              : artUri;
          printColored(imageUrl ?? 'null');

          String getCurrentStreamUrl() {
            // Check if the current audio source is available
            if (widget.con.player.audioSource != null) {
              // Get the current source

              if (currentSource is UriAudioSource) {
                // Return the URL as a string
                return currentSource.uri.toString();
              }
            }
            return ''; // Return null if no URL is available
          }

          return Scaffold(
            drawer: const DrawerScreen(),
            backgroundColor: AppColors.cScaffoldBackgroundColorDark,
            body: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(ImagesPath.playerBG),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    SafeArea(
                      bottom: false,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              FirstSectionPlayerScreen(
                                isPremium: true,
                                myAudio: currentMediaItem,
                                streamUrl: getCurrentStreamUrl(),
                              ),
                              if (isLyrics && lyrics.isNotEmpty)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        0,
                                        16,
                                        12,
                                        10,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              imageUrl: imageUrl,
                                              width: context.width * 0.111,
                                              height: context.height * 0.058,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: context.height * 0.012,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  title,
                                                  style: styleW700(
                                                    context,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      context.height * 0.0060,
                                                ),
                                                Text(
                                                  artist,
                                                  style: styleW400(
                                                    context,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.7,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Text(
                                              lyrics!,
                                              textAlign: TextAlign.center,
                                              style: styleW700(
                                                context,
                                                fontSize: 18,
                                                height: 2,
                                                color: Colors.white,
                                              ),
                                              maxLines: isPremium ? null : 3,
                                            ),
                                            if (!isPremium)
                                              Center(
                                                child: GradientCenterTextButton(
                                                  onTap: () {
                                                    context
                                                        .read<TabCubit>()
                                                        .changeTab(4);
                                                    Navigator.pop(context);
                                                  },
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.3,
                                                  buttonText:
                                                      AppLocalizations.of(
                                                    context,
                                                  )!
                                                          .translate(
                                                    'unlock_full_lyrics',
                                                  ),
                                                  listOfGradient: [
                                                    HexColor("#DA00FF"),
                                                    HexColor("#FFB000"),
                                                  ],
                                                ),
                                              )
                                            else
                                              const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else

                              SizedBox(height: logicalHeightSize,),
                                // Center(
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       // SizedBox(width: context.height * 0.01),
                                //       ClipRRect(
                                //         borderRadius: BorderRadius.circular(10),
                                //         child: isFile
                                //             ? Image.file(
                                //                 File(imageUrl),
                                //                 width: logicalWidthSize,
                                //                 height: logicalHeightSize,
                                //                 fit: BoxFit.fill,
                                //               )
                                //             : CachedNetworkImage(
                                //                 errorWidget:
                                //                     (context, url, error) =>
                                //                         const Icon(Icons.error),
                                //                 imageUrl: imageUrl,
                                //                 width: logicalWidthSize,
                                //                 height: logicalHeightSize,
                                //                 fit: BoxFit.fill,
                                //               ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              // const Spacer(),
                              if (isLyrics || isFile)
                                const SizedBox()
                              else
                                FavoriteInPlayerSection(
                                  streamUrl: streamUrl!,
                                  myAudio: currentMediaItem!,
                                  con: widget.con,
                                ),
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: context.height * 0.03,
                                    ),
                                    child: StreamBuilder<Duration?>(
                                      stream: widget.con.player.positionStream,
                                      builder: (context, snapshot) {
                                        final currentPosition =
                                            snapshot.data ?? Duration.zero;
                                        final duration =
                                            widget.con.player.duration ??
                                                Duration.zero;

                                        return SliderPlayerReuse(
                                          currentPosition: currentPosition,
                                          duration: duration,
                                          seekTo: (to) {
                                            widget.con.player.seek(to);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: context.height * 0.21,
                                    ),
                                    child: StreamBuilder<LoopMode>(
                                      stream: widget.con.player.loopModeStream,
                                      builder: (context, loopModeSnapshot) {
                                        return StreamBuilder<bool>(
                                          stream:
                                              widget.con.player.playingStream,
                                          builder: (context, playingSnapshot) {
                                            final isPlaying =
                                                playingSnapshot.data ?? false;

                                            return ControlPlayerSection(
                                              isPlaying: isPlaying,
                                              con: widget.con,
                                              audioPlayer: widget.con.player,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical:20,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        lyrics.isEmpty
                                            ? null
                                            : setState(() {
                                                isLyrics = !isLyrics;
                                              });
                                        log(isLyrics.toString());
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: isLyrics && lyrics.isNotEmpty
                                              ? AppColors.cPrimary
                                              : Colors.transparent,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              CupertinoIcons.layers_alt,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: context.height * 0.0060,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                      .translate('lyrics') ??
                                                  '',
                                              style: styleW700(
                                                context,
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: !isPremium
                                          ? () {
                                              context
                                                  .read<TabCubit>()
                                                  .changeTab(4);
                                              Navigator.pop(context);
                                            }
                                          : () => Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      AudioQueueWidget(
                                                    controller: widget.con,
                                                  ),
                                                ),
                                              ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.music_note_list,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: context.height * 0.0060,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                    .translate('queue') ??
                                                '',
                                            style: styleW700(
                                              context,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
