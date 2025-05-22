import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/audio_playlists/presentation/cubit/audio_playlists_cubit.dart';
import '../../features/audio_playlists/presentation/screen/loading.dart';
import '../entities/songs.dart';
import '../helper/app_size.dart';
import '../helper/font_style.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.songs});
  final List<Songs> songs;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.only(
          top: AppPadding.p20,
          bottom: AppPadding.p20 * 6,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(
          height: AppPadding.p20,
        ),
        itemCount: widget.songs.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              BlocProvider.of<AudioPlayListsCubit>(
                context,
              ).playSongs(context, i, widget.songs);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Text(
                          (i + 1).toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).listTileTheme.iconColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: CachedNetworkImage(
                            errorWidget: (
                              context,
                              url,
                              error,
                            ) =>
                                const Icon(Icons.error),
                            imageUrl: widget.songs[i].artworkUrl!,
                            width: 50,
                            height: 50,
                            maxHeightDiskCache: 100,
                            maxWidthDiskCache: 100,
                            memCacheHeight: (50 *
                                    MediaQuery.of(
                                      context,
                                    ).devicePixelRatio)
                                .round(),
                            memCacheWidth: (50 *
                                    MediaQuery.of(
                                      context,
                                    ).devicePixelRatio)
                                .round(),
                            progressIndicatorBuilder: (context, url, l) =>
                                const LoadingImage(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        AudioWave(
                          song: widget.songs[i],
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.songs[i].title!,
                                  maxLines: 1,
                                  style: styleW400(
                                    context,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.songs[i].duration.toString(),
                                  style: styleW400(
                                    context,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MenuItemButtonWidget(
                    song: widget.songs[i],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
