import 'package:alamoody/core/models/artists_model.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/models/song_model.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/custom_progrees_widget.dart';
import '../../../../download_songs/presentation/cubit/download_cubit.dart';
import '../../../../main_layout/cubit/tab_cubit.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadCubit, DownloadState>(
      builder: (context, state) {
        final cubit = context.read<DownloadCubit>();

        if (cubit.isDownloading(int.parse(widget.myAudio.id))) {
          final double progress =
              cubit.getProgress(int.parse(widget.myAudio.id));
          return Stack(
            alignment: Alignment.center,
            children: [
              DownloadProgressWidget(progress: progress), // ✅ Show progress
            ],
          );
        } else if (cubit.isDownloaded(int.parse(widget.myAudio.id))) {
          // ✅ Show check icon when download is complete
          return IconButton(
            icon: const Icon(
              Icons.download_done,
              color: Colors.white,
            ),
            onPressed: () {
              Constants.showToast(
                message: AppLocalizations.of(context)!.translate("downloaded")!,
              );
            },
          );
        } else {
          // ✅ Show Download Button (Clickable only if not downloaded)
          return IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: context
                        .read<ProfileCubit>()
                        .userProfileData!
                        .user!
                        .subscription!
                        .serviceId ==
                    '1'
                ? () {
                    context.read<TabCubit>().changeTab(4);
                    Navigator.pop(context);
                  }
                : () {
                    if (widget.streamUrl.isEmpty) {
                      // ✅ Show message if audio is not ready
                      Constants.showToast(
                        message: "The audio is not ready to download",
                      );

                      // ✅ Debug print full audio details
                      debugPrint("🔴 AUDIO NOT READY TO DOWNLOAD");
                      debugPrint("myAudio: ${widget.myAudio}");
                      debugPrint("streamUrl: ${widget.streamUrl}");

                      return;
                    }

                    // ✅ Print all audio details for debugging
                    debugPrint("streamUrl: ${widget.streamUrl}");

                    debugPrint("🎵 AUDIO DETAILS:");
                    debugPrint("ID: ${widget.myAudio.id}");
                    debugPrint("Title: ${widget.myAudio.title}");
                    debugPrint("Artist: ${widget.myAudio.artist}");
                    debugPrint("Artwork URL: ${widget.myAudio.artUri}");
                    debugPrint("Extras: ${widget.myAudio.extras}");

                    // ✅ Ensure the URL uses HTTPS
                    String ensureHttps(String url) {
                      if (url.startsWith('http://')) {
                        return url.replaceFirst('http://', 'https://');
                      }
                      return url;
                    }

                    // ✅ Proceed with download
                    cubit.download(
                      song: SongModel(
                        audio: ensureHttps(widget.streamUrl),
                        id: int.parse(widget.myAudio.id),
                        title: widget.myAudio.title,
                        artists: [
                          ArtistsModel(name: widget.myAudio.artist),
                        ],
                        artworkUrl:
                            ensureHttps(widget.myAudio.artUri.toString()),
                        favorite: widget.myAudio.extras?['favorite'],
                        listened: widget.myAudio.extras?['listened'],
                        lyrics: widget.myAudio.extras?['lyrics'],
                      ),
                      context: context,
                    );
                  },
          );
        }
      },
    );
  }
}
