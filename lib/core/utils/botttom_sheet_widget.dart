import 'dart:developer';

import 'package:alamoody/config/themes/colors.dart';
import 'package:alamoody/core/models/artists_model.dart';
import 'package:alamoody/core/models/song_model.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/custom_progrees_widget.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/features/download_songs/presentation/cubit/download_cubit.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../config/locale/app_localizations.dart';
import '../../features/Playlists/presentation/screen/add_to_playlist.dart';
import '../../features/audio_playlists/presentation/screen/loading.dart';
import '../../features/main_layout/cubit/tab_cubit.dart';
import '../../features/profile/presentation/cubits/profile/profile_cubit.dart';
import '../components/reused_background.dart';
import '../entities/songs.dart';
import '../helper/font_style.dart';
import '../helper/images.dart';
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
  Future<void> _getDownloadsData() async {
    await BlocProvider.of<DownloadCubit>(context).getSavedDownloads().then(
          (value) => BlocProvider.of<DownloadCubit>(context)
              .isDownload(widget.song.id!),
        );
  }

  @override
  void initState() {
    _getDownloadsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

    return ReusedBackground(
      lightBG: ImagesPath.homeBGLightBG,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: context.height * 0.017,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: widget.song.artworkUrl!,
                      memCacheHeight: (300 * devicePexelRatio).round(),
                      memCacheWidth: (300 * devicePexelRatio).round(),
                      maxHeightDiskCache: (300 * devicePexelRatio).round(),
                      maxWidthDiskCache: (300 * devicePexelRatio).round(),
                      progressIndicatorBuilder: (context, url, l) =>
                          const LoadingImage(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.cPrimary,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 4,
                        ),
                        // styleW500(context,fontSize: 18)
                        Icon(
                          Icons.music_note,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate("listen_on_alaMoody")!,
                          style: styleW700(context, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.song.title!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 5),
            Text(
              widget.song.title!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).iconTheme.color,
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
                       context
                                                .read<TabCubit>()
                                                .changeTab(4);
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
                  context
                                                .read<TabCubit>()
                                                .changeTab(4);
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
                return BlocProvider.of<DownloadCubit>(context).isDownloaded
                    ? ListTile(
                        onTap: () {
                          Constants.showToast(
                            message: AppLocalizations.of(context)!
                                .translate("downloaded")!,
                          );
                        },
                        minLeadingWidth: 30,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        leading: Icon(
                          Icons.download_done,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!
                              .translate("downloaded")!,
                          style: styleW700(context, fontSize: 18),
                        ),
                      )
                    : ListTile(
                        onTap: context
                                    .read<ProfileCubit>()
                                    .userProfileData!
                                    .user!
                                    .subscription!
                                    .serviceId ==
                                '1'
                            ? () {
                              context
                                                .read<TabCubit>()
                                                .changeTab(4);
                              }
                            : state is Downloading
                                ? () => Constants.showToast(
                                      message: AppLocalizations.of(context)!
                                          .translate("downloadInProgress")!,
                                    )
                                : () {
                                    String ensureHttps(String url) {
                                      if (url.startsWith('http://')) {
                                        return url.replaceFirst(
                                            'http://', 'https://',);
                                      }
                                      return url; // Return the original URL if it's already HTTPS or doesn't contain HTTP
                                    }

                                    BlocProvider.of<DownloadCubit>(context)
                                        .download(
                                      song: SongModel(
                                        audio: ensureHttps(
                                          widget.song.streamUrl!,
                                        ), // Ensure HTTPS for streamUrl
                                        id: widget.song.id,
                                        title: widget.song.title,
                                        artists: [
                                          ArtistsModel(
                                              name: widget.song.artists!.isEmpty
                                                  ? 'unkown'
                                                  : widget
                                                      .song.artists![0].name,),
                                        ],
                                        artworkUrl: ensureHttps(
                                          widget.song.artworkUrl.toString(),
                                        ), // Ensure HTTPS for artworkUrl
                                        favorite: widget.song.favorite,
                                        listened: widget.song.listened,
                                        lyrics: widget.song.lyrics,
                                      ),
                                      context: context,
                                    );
                                    // launch(song.trackid!);
                                  },
                        trailing: BlocBuilder<DownloadCubit, DownloadState>(
                          builder: (context, state) {
                            if (state is Downloading ||
                                state is DownloadingProgress) {
                              final double progress = state is DownloadingProgress
                                  ? state.progress
                                  : 0.0;

                              return DownloadProgressWidget(
                                progress: progress,
                              );
                            } else {
                              return const Icon(
                                size: 25,
                                Icons.download,
                                color: Colors.white,
                              );
                            }
                          },
                        ),
                        minLeadingWidth: 30,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        leading: Icon(
                          Icons.download,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.translate("download")!,
                          style: styleW700(context, fontSize: 18),
                        ),
                      );
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
