import 'dart:developer';

import 'package:alamoody/core/models/artists_model.dart';
import 'package:alamoody/core/models/song_model.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/custom_progrees_widget.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/features/download_songs/presentation/cubit/download_cubit.dart';
import 'package:alamoody/features/main/presentation/cubit/main_cubit.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../config/locale/app_localizations.dart';
import '../../features/Playlists/presentation/screen/add_to_playlist.dart';
import '../../features/main_layout/cubit/tab_cubit.dart';
import '../../features/profile/presentation/cubits/profile/profile_cubit.dart';
import '../entities/songs.dart';
import '../helper/font_style.dart';
import 'constants.dart';

class BottomSheetWidget extends StatefulWidget {
  final bool? isNext;
  final Songs song;
  const BottomSheetWidget({
    Key? key,
    this.isNext,
    required this.song,
  }) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final bool isDarkMode = MainCubit.isDark;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration:
              Constants.customBackgroundDecoration(isDarkMode: isDarkMode),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.song.artworkUrl!,
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  fit: BoxFit.scaleDown,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 4),

              Text(
                widget.song.title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // **🌍 Listen Row (Fixed Overflow)**
              Container(
                height: 40,
                width: screenWidth * 0.6,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note,
                        color: Theme.of(context).iconTheme.color,),
                    const SizedBox(width: 6),

                    // **🌍 Fixed Text Overflow Issue**
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("listen_on_alaMoody")!,
                        style: styleW700(context, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // Avoid overflow
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.isNext == null)
                ListTile(
                  onTap: context
                              .read<ProfileCubit>()
                              .userProfileData!
                              .user!
                              .subscription!
                              .serviceId ==
                          '1'
                      ? () {
                          context.read<TabCubit>().changeTab(4);
                        }
                      : () {
                          Provider.of<MainController>(context, listen: false)
                              .addOrMoveSongToQueue(widget.song);
                          Constants.showToast(
                            message: AppLocalizations.of(context)!
                                .translate("play_next")!,
                          );
                          Navigator.pop(context);
                        },
                  minLeadingWidth: 30,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  leading: Icon(
                    CupertinoIcons.play_arrow,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.translate("play_next")!,
                    style: styleW700(context, fontSize: 18),
                  ),
                ),
              ListTile(
                onTap: context
                            .read<ProfileCubit>()
                            .userProfileData!
                            .user!
                            .subscription!
                            .serviceId ==
                        '1'
                    ? () {
                        context.read<TabCubit>().changeTab(4);
                      }
                    : () {
                        Provider.of<MainController>(context, listen: false)
                            .addAudioToQueue(widget.song);
                        Constants.showToast(
                          message: AppLocalizations.of(context)!
                              .translate("add_to_queue")!,
                        );

                        log("Added to playlist");
                        Navigator.pop(context);
                      },
                minLeadingWidth: 30,
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                leading: Icon(
                  Icons.playlist_add,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  AppLocalizations.of(context)!.translate("add_to_queue")!,
                  style: styleW700(context, fontSize: 18),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) {
                        return AddToPlaylist(
                          song: widget.song,
                        );
                      },
                    ),
                  );
                },
                minLeadingWidth: 30,
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                leading: Icon(
                  CupertinoIcons.music_albums,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  AppLocalizations.of(context)!.translate("add_to_Playlist")!,
                  style: styleW700(context, fontSize: 18),
                ),
              ),
              BlocConsumer<DownloadCubit, DownloadState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final cubit = context.read<DownloadCubit>();
                  final isDownloading = cubit.isDownloading(widget.song.id);
                  final isDownloaded = cubit.isDownloaded(widget.song.id);

                  return ListTile(
                    onTap: isDownloaded
                        ? () {
                            Constants.showToast(
                              message: AppLocalizations.of(context)!
                                  .translate("downloaded")!,
                            );
                          }
                        : context
                                    .read<ProfileCubit>()
                                    .userProfileData!
                                    .user!
                                    .subscription!
                                    .serviceId ==
                                '1'
                            ? () {
                                context.read<TabCubit>().changeTab(4);
                              }
                            : isDownloading
                                ? () {
                                    Constants.showToast(
                                      message: AppLocalizations.of(context)!
                                          .translate("downloadInProgress")!,
                                    );
                                  }
                                : () {
                                    if (widget.song.streamUrl == null ||
                                        widget.song.streamUrl!.isEmpty) {
                                      Constants.showToast(
                                        message:
                                            "The audio is not ready to download",
                                      );
                                      return;
                                    }

                                    String ensureHttps(String url) {
                                      if (url.startsWith('http://')) {
                                        return url.replaceFirst(
                                          'http://',
                                          'https://',
                                        );
                                      }
                                      return url;
                                    }

                                    cubit.download(
                                      song: SongModel(
                                        audio: ensureHttps(
                                          widget.song.streamUrl!,
                                        ),
                                        id: widget.song.id,
                                        title: widget.song.title,
                                        artists: [
                                          ArtistsModel(
                                            name: widget.song.artists!.isEmpty
                                                ? 'Unknown'
                                                : widget.song.artists![0].name,
                                          ),
                                        ],
                                        artworkUrl: ensureHttps(
                                          widget.song.artworkUrl.toString(),
                                        ),
                                        favorite: widget.song.favorite,
                                        listened: widget.song.listened,
                                        lyrics: widget.song.lyrics,
                                      ),
                                      context: context,
                                    );
                                  },
                    minLeadingWidth: 30,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    leading: Icon(
                      isDownloaded ? Icons.download_done : Icons.download,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                        isDownloaded ? "downloaded" : "download",
                      )!,
                      style: styleW700(context, fontSize: 18),
                    ),
                    trailing: isDownloading
                        ? BlocBuilder<DownloadCubit, DownloadState>(
                            builder: (context, state) {
                              final double progress =
                                  cubit.getProgress(widget.song.id);
                              return DownloadProgressWidget(progress: progress);
                            },
                          )
                        : const SizedBox(),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
