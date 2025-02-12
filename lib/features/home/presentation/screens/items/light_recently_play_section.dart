import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/utils/controllers/main_controller.dart';
import '../../../../../core/utils/hex_color.dart';
import '../../../../../core/utils/lyrics_screen.dart';
import '../../../../../core/utils/menu_item_button.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../audio_playlists/presentation/screen/loading.dart';
import '../../../../main/presentation/cubit/main_cubit.dart';
import '../../../../recently_play/presentation/screen/recently_play_screen.dart';

class LightRecentlyPlaySection extends StatelessWidget {
  const LightRecentlyPlaySection({
    Key? key,
    required this.recentListen,
  }) : super(key: key);
  final List<Songs> recentListen;
  @override
  Widget build(BuildContext context) {
    return _buildBodyContent(context);
  }

  Widget _buildBodyContent(context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

    return SizedBox(
      height: recentListen.length >= 2
          ? MediaQuery.of(context).size.height / 3.1
          : MediaQuery.of(context).size.height / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              AppLocalizations.of(context)!.translate('recently_play')!,
              style: styleW600(context,
                  fontSize: 16,
                  color: MainCubit.isDark ? Colors.white : HexColor('#58257F'),),
            ),
          ),
          // const SizedBox(
          //   height: AppPadding.p6,
          // ),
          if (recentListen.isEmpty)
            Center(
              child: Text(
                AppLocalizations.of(context)!.translate('no_data_found')!,
                style: styleW600(context,
                    fontSize: 16, color: HexColor('#58257F'),),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: recentListen.length >= 2 ? 2 : 1,
                itemBuilder: (context, index) {
                  final song = recentListen[index];
                  return GestureDetector(
                    onTap: () async {
                      final con =
                          Provider.of<MainController>(context, listen: false);
                      con.playSong(
                        con.convertToAudio(recentListen),
                        recentListen.indexOf(song),
                      );

                      // downloadSong(context, song);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: [
                              HexColor("#8D00FF"),
                              HexColor("#CF3DFF"),
                              // Colors.white,
                            ],
                          ),
                          width: 0.8,
                        ),
                        gradient: const LinearGradient(
                          end: Alignment(1, 2),
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              width: context.width * 0.165,
                              height: context.height * 0.088,
                              imageUrl: song.artworkUrl!,
                              memCacheHeight: (300 * devicePexelRatio).round(),
                              memCacheWidth: (300 * devicePexelRatio).round(),
                              maxHeightDiskCache:
                                  (300 * devicePexelRatio).round(),
                              maxWidthDiskCache:
                                  (300 * devicePexelRatio).round(),
                              progressIndicatorBuilder: (context, url, l) =>
                                  const LoadingImage(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: context.height * 0.016,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AudioWave(
                                      song: song,
                                    ),
                                    Expanded(
                                      child: Text(
                                        maxLines: 1,
                                        song.title!,
                                        style: styleW600(context,
                                            color: !MainCubit.isDark
                                                ? HexColor('#1B0E3E')
                                                : Colors.white,
                                            fontSize: 14,),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  song.artists![0].name!,
                                  style: styleW400(context,
                                      color: HexColor('#AAAAAA'), fontSize: 14,),
                                  overflow: TextOverflow.clip,
                                ),
                                SizedBox(
                                  height: context.height * 0.0145,
                                ),
                                if (song.lyrics!.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      pushNavigate(
                                        context,
                                        LyricsScreen(
                                          songs: song,
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: HexColor('#D9D9D9'),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8),),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('lyrics')!,
                                            style: styleW400(
                                              context,
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          song.artists![0].name!,
                                          style: styleW400(
                                            context,
                                          ),
                                        ),
                                        const SizedBox(),
                                      ],
                                    ),
                                  )
                                else
                                  const SizedBox(),
                              ],
                            ),
                          ),
                          const Spacer(),
                          MenuItemButtonWidget(
                            song: song,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          GestureDetector(
            onTap: () {
              pushNavigate(
                context,
                RecentlyPlayScreen(
                  headerTitle:
                      AppLocalizations.of(context)!.translate('recently_play')!,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  AppLocalizations.of(context)!.translate('view_history')!,
                  style: styleW700(context,
                      color: HexColor('#A5508C'), fontSize: 14,),
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
