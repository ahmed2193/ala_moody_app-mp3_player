import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/models/artists_model.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/custom_progrees_widget.dart';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/models/song_model.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../download_songs/presentation/cubit/download_cubit.dart';
import '../../../../main_layout/cubit/tab_cubit.dart';
import '../../../../main_layout/presentation/pages/main_layout_screen.dart';
import '../../../../profile/presentation/cubits/profile/profile_cubit.dart';

class DownloadSection extends StatefulWidget {
  const DownloadSection({
    super.key,
    required this.con,
    required this.myAudio,
    required this.streamUrl,
  });
  final MediaItem myAudio;
  final String streamUrl;

  final MainController con;
  @override
  State<DownloadSection> createState() => _DownloadSectionState();
}

class _DownloadSectionState extends State<DownloadSection> {
  bool isDownLoad = false;
  Future<void> _getDownloadsData() async {
    await BlocProvider.of<DownloadCubit>(context)
        .getSavedDownloads()
        .then((value) {});
  }

  @override
  void initState() {
    // print(widget.id!.toString);
    // _getDownloadsData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<DownloadCubit>(context).downloadId !=
        int.parse(widget.myAudio.id)) {
      BlocProvider.of<DownloadCubit>(context)
          .isDownload(int.parse(widget.myAudio.id));
    }

    return BlocConsumer<DownloadCubit, DownloadState>(
      buildWhen: (previousState, state) {
        if (state is Downloading ||
            state is Downloaded ||
            state is DownloadListError ||
            state is IsDownloadedLoaded) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is Downloaded) {
          _getDownloadsData();
        }
      },
      builder: (context, state) {
        return BlocProvider.of<DownloadCubit>(context).isDownloaded
            ? IconButton(
                onPressed: () {
                  Constants.showToast(
                    message:
                        AppLocalizations.of(context)!.translate("downloaded")!,
                  );
                },
                icon: Icon(
                  size: 25,
                  Icons.download_done,
                  color: Theme.of(context).iconTheme.color,
                ),
              )
            : IconButton(
                onPressed: context
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
                            // Ensure the URL uses HTTPS
                            String ensureHttps(String url) {
                              if (url.startsWith('http://')) {
                                return url.replaceFirst('http://', 'https://');
                              }
                              return url; // Return the original URL if it's already HTTPS or doesn't contain HTTP
                            }

                            state is Downloading
                                ? null
                                : BlocProvider.of<DownloadCubit>(context)
                                    .download(
                                    song: SongModel(
                                      audio: ensureHttps(
                                        widget.streamUrl,
                                      ), // Ensure HTTPS for streamUrl
                                      id: int.parse(widget.myAudio.id),
                                      title: widget.myAudio.title,
                                      artists: [
                                        ArtistsModel(
                                            name: widget.myAudio.artist),
                                      ],
                                      artworkUrl: ensureHttps(
                                        widget.myAudio.artUri.toString(),
                                      ), // Ensure HTTPS for artworkUrl
                                      favorite:
                                          widget.myAudio.extras!['favorite'],
                                      listened:
                                          widget.myAudio.extras!['listened'],
                                      lyrics: widget.myAudio.extras!['lyrics'],
                                    ),
                                    context: context,
                                  );
                            // launch(song.trackid!);
                          },
                icon: BlocBuilder<DownloadCubit, DownloadState>(
                        builder: (context, state) {
                          printColored(widget.myAudio.id);
                          printColored(BlocProvider.of<DownloadCubit>(context).downloadId);

                          if (state is Downloading ||
                              state is DownloadingProgress ) {
                            double progress = state is DownloadingProgress
                                ? (state as DownloadingProgress).progress
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
                      )
                    );
      },
    );
  }
}
