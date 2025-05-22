import 'package:alamoody/config/themes/colors.dart';
import 'package:alamoody/features/Playlists/presentation/cubits/remove_playlist/remove_playlist_cubit.dart';
import 'package:alamoody/features/Playlists/presentation/widget/show_edit_create_playlist_model_bottom_sheet.dart';
import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alamoody/features/main/presentation/cubit/main_cubit.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/locale/app_localizations.dart';
import '../../features/audio_playlists/presentation/cubit/audio_playlists_cubit.dart';
import '../../features/audio_playlists/presentation/screen/loading.dart';
import '../../features/home/domain/entities/Songs_PlayLists.dart';
import '../entities/songs.dart';
import '../helper/font_style.dart';
import 'constants.dart';

class PrivatePlaylistSheetWidget extends StatefulWidget {
  final bool? isNext;
  final SongsPlayLists playListsDetails;
  final List<Songs> songs;

  const PrivatePlaylistSheetWidget({
    Key? key,
    this.isNext,
    required this.playListsDetails,
    required this.songs,
  }) : super(key: key);

  @override
  State<PrivatePlaylistSheetWidget> createState() =>
      _PrivatePlaylistSheetWidgetState();
}

class _PrivatePlaylistSheetWidgetState
    extends State<PrivatePlaylistSheetWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final bool isDarkMode = MainCubit.isDark;
        return Container(
          decoration:
              Constants.customBackgroundDecoration(isDarkMode: isDarkMode),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.cTextSubtitleLight..withOpacity(0.1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CachedNetworkImage(
                            height: 90,
                            width: 90,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl: widget.playListsDetails.artworkUrl!,
                            memCacheHeight: (200 * devicePexelRatio).round(),
                            memCacheWidth: (200 * devicePexelRatio).round(),
                            maxHeightDiskCache:
                                (200 * devicePexelRatio).round(),
                            maxWidthDiskCache: (200 * devicePexelRatio).round(),
                            progressIndicatorBuilder: (context, url, l) =>
                                const LoadingImage(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.playListsDetails.title!,
                              style: styleW500(context, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              ' ${BlocProvider.of<AudioPlayListsCubit>(
                                context,
                              ).playListsDetails!.description!}',
                              style: styleW400(context)!.copyWith(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${Constants.formatNumber(int.tryParse(widget.songs.length.toString())! ?? 0)} ${AppLocalizations.of(context)!.translate("songs")}',
                                  textAlign: TextAlign.left,
                                  style: styleW600(
                                    context,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();

                  showEditCreatePlaylistBottomSheet(
                    context,
                    existingDescription: widget.playListsDetails.description,
                    existingImage: widget.playListsDetails.artworkUrl,
                    existingName: widget.playListsDetails.title,
                    id: widget.playListsDetails.id.toString(),
                    isEdit: true,
                  );
                },
                minLeadingWidth: 20,
                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                leading: Icon(
                  size: 30,
                  Icons.edit_sharp,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  AppLocalizations.of(context)!.translate("edit")!,
                  style: styleW700(context, fontSize: 16),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();

                  BlocProvider.of<RemovePlaylistCubit>(context).removePlaylist(
                    playListsId: widget.playListsDetails.id.toString(),
                    accessToken: context
                        .read<LoginCubit>()
                        .authenticatedUser!
                        .accessToken!,
                  );
                },
                minLeadingWidth: 20,
                contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                leading: Icon(
                  size: 30,
                  Icons.delete_sharp,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  AppLocalizations.of(context)!.translate("remove")!,
                  style: styleW700(context, fontSize: 16),
                ),
              ),
              // ListTile(
              //   onTap: () {
              //     pushNavigate(context, AddSongScreen());
              //   },
              //   minLeadingWidth: 20,
              //   contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              //   leading: Icon(
              //     size: 30,
              //     Icons.add_box,
              //     color: Theme.of(context).iconTheme.color,
              //   ),
              //   title: Text(
              //     AppLocalizations.of(context)!.translate("add_songs")!,
              //     style: styleW700(context, fontSize: 16),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
