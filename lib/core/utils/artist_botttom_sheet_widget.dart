import 'dart:math';

import 'package:alamoody/config/themes/colors.dart';
import 'package:alamoody/core/entities/artists.dart';
import 'package:alamoody/core/utils/sliver_appbar.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/locale/app_localizations.dart';
import '../../features/audio_playlists/presentation/cubit/audio_playlists_cubit.dart';
import '../../features/audio_playlists/presentation/screen/loading.dart';
import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/home/presentation/cubits/follow_and_unfollow/follow_and_unfollow_cubit.dart';
import '../components/reused_background.dart';
import '../entities/songs.dart';
import '../helper/font_style.dart';
import 'constants.dart';

class ArtistBottomSheetWidget extends StatefulWidget {
  final bool? isNext;
  final Artists artist;
  final List<Songs> songs;

  const ArtistBottomSheetWidget({
    Key? key,
    this.isNext,
    required this.artist,
    required this.songs,
  }) : super(key: key);

  @override
  State<ArtistBottomSheetWidget> createState() =>
      _ArtistBottomSheetWidgetState();
}

class _ArtistBottomSheetWidgetState extends State<ArtistBottomSheetWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

    return ReusedBackground(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.cIconLight..withOpacity(0.1),
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
                          imageUrl: widget.artist.artworkUrl!,
                          memCacheHeight: (200 * devicePexelRatio).round(),
                          memCacheWidth: (200 * devicePexelRatio).round(),
                          maxHeightDiskCache: (200 * devicePexelRatio).round(),
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
                            widget.artist.name!,
                            style: styleW700(context, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            children: [
                              Text(
                                '${Constants.formatNumber(widget.songs.first.followerCount!)} FOLLOWERS',
                                textAlign: TextAlign.left,
                                style: styleW600(
                                  context,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                '${Constants.formatNumber(int.tryParse(widget.songs.first.plays.toString())! ?? 0)} PLAYS',
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
            StatefulBuilder(
              builder: (BuildContext context, setState) {
                bool isfollow = widget.artist.favorite ?? false;
                return BlocConsumer<FollowAndUnFollowCubit,
                    FollowAndUnFollowState>(
                  listener: (context, state) {
                    if (state is FollowAndUnFollowLoading) {
                      setState(() {
                        isfollow = !isfollow;
                        widget.artist.favorite = isfollow;
                      });
                    }

                    if (state is FollowAndUnFollowFailed) {
                      setState(() {
                        isfollow = !isfollow;
                        widget.artist.favorite = isfollow;
                      });
                    }
                    if (state is FollowAndUnFollowSuccess) {
                      setState(() {
                        widget.artist.favorite = isfollow;
                      });
                      // BlocProvider.of<ArtistsCubit>(context).getArtists(
                      //   accessToken:
                      //       context.read<LoginCubit>().authenticatedUser!.accessToken,
                      // );
                    }
                  },
                  builder: (context, state) {
                    return ListTile(
                      onTap: () {
                        BlocProvider.of<FollowAndUnFollowCubit>(context)
                            .followAndUnFollow(
                          id: widget.artist.id!,
                          accessToken: context
                              .read<LoginCubit>()
                              .authenticatedUser!
                              .accessToken!,
                          favtype: !isfollow
                              ? BlocProvider.of<FollowAndUnFollowCubit>(
                                  context,
                                ).type = 1
                              : BlocProvider.of<FollowAndUnFollowCubit>(
                                  context,
                                ).type = 0,
                        );
                      },
                      minLeadingWidth: 20,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 25),
                      leading: Icon(
                        size: 30,
                        CupertinoIcons.check_mark_circled,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(
                        isfollow
                            ? AppLocalizations.of(context)!
                                .translate("following")!
                            : AppLocalizations.of(context)!
                                .translate("follow")!,
                        style: styleW700(context, fontSize: 16),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
              },
              minLeadingWidth: 20,
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              leading: Icon(
                size: 30,
                CupertinoIcons.xmark_circle,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                AppLocalizations.of(context)!.translate("mute_artist")!,
                style: styleW700(context, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {},
              minLeadingWidth: 10,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              leading: ShareSongWidget(
                artists: widget.artist,
              ),
              title: Text(
                AppLocalizations.of(context)!.translate("share")!,
                style: styleW700(context, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                if (widget.songs.isNotEmpty) {
                  // Generate a random index within the bounds of the list
                  final randomIndex = Random().nextInt(widget.songs.length);

                  // Call the playSongs function with the random index
                  BlocProvider.of<AudioPlayListsCubit>(context)
                      .playSongs(context, randomIndex, widget.songs);
                } else {
                  debugPrint('No songs available to play.');
                }
              },
              minLeadingWidth: 20,
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              leading: Icon(
                Icons.queue_music,
                size: 30,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                AppLocalizations.of(context)!.translate("play_more_like_this")!,
                style: styleW700(context, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
              },
              minLeadingWidth: 20,
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              leading: Icon(
                Icons.report,
                size: 30,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                AppLocalizations.of(context)!.translate("report")!,
                style: styleW700(context, fontSize: 16),
              ),
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
