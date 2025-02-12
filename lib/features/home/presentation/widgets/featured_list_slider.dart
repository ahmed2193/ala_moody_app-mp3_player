
import 'package:alamoody/features/home/domain/entities/Songs_PlayLists.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../audio_playlists/presentation/screen/audio_playlists_screen.dart';

class FeaturedListSlider extends StatelessWidget {
  const FeaturedListSlider({
    required this.songsPlayLists,
    required this.index,
    Key? key,
  }) : super(key: key);
  final SongsPlayLists songsPlayLists;
  final int index;


  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final double logicalHeightSize = 220 / pixelRatio;
    final double logicalWidthSize = 380 / pixelRatio;
    return GestureDetector(
      onTap: () {
        pushNavigate(
          context,
          AudioPlayListsScreen(
            songsPlayLists: songsPlayLists,
          ),
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          // image
          Container(
            height: logicalHeightSize,
            width: logicalWidthSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pLarge),
              image: DecorationImage(
                image: NetworkImage(
                  songsPlayLists.artworkUrl!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // filter color container
          Container(
                   height: logicalHeightSize,
            width: logicalWidthSize,
            padding: const EdgeInsetsDirectional.only(
              bottom: AppPadding.p10,
            ),
            alignment: AlignmentDirectional.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pLarge),
              gradient: LinearGradient(
                begin: AlignmentDirectional.bottomEnd,
                colors: [
                  HexColor("#D9D9D900"),
                  HexColor("#00B654BA"),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (songsPlayLists.user == null)
                  const SizedBox.shrink()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      songsPlayLists.user!.name == null
                          ? ""
                          : '${songsPlayLists.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: styleW600(
                        context,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
