import 'dart:developer';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/features/home/domain/entities/Songs_PlayLists.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Reduce sizes by 10% for better performance
    final double containerHeight = screenHeight * 0.1; 
    final double containerWidth = screenWidth * 0.40; 
    const double borderRadius = 14.0; // Reduced border radius for smoother UI

    log(songsPlayLists.artworkUrl.toString());

    return GestureDetector(
      onTap: () {
        pushNavigate(
          context,
          AudioPlayListsScreen(songsPlayLists: songsPlayLists),
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          // ✅ Playlist Image
          Container(
            height: containerHeight,
            width: containerWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: CachedNetworkImage(
                imageUrl: songsPlayLists.artworkUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ), // ✅ Loading indicator
                errorWidget: (context, url, error) => Image.asset(
                  ImagesPath.playlistDefultImage, // ✅ Fallback image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // ✅ Gradient Overlay
          Container(
            height: containerHeight,
            width: containerWidth,
            padding: EdgeInsets.only(bottom: screenHeight * 0.012),
            alignment: AlignmentDirectional.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
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
                if (songsPlayLists.user != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: Text(
                      songsPlayLists.user!.name == null ? "" : '${songsPlayLists.title}',
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
