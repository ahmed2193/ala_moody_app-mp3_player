import 'dart:ui';

import 'package:alamoody/features/home/domain/entities/Songs_PlayLists.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../audio_playlists/presentation/screen/audio_playlists_screen.dart';

class LightFeaturedListSlider extends StatelessWidget {
  const LightFeaturedListSlider({
    required this.songsPlayLists,
    required this.index,
    Key? key,
  }) : super(key: key);
  final SongsPlayLists songsPlayLists;
  final int index;


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize =
        screenWidth * 0.33; // Adjust the size relative to screen width

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
            height: imageSize,
            width: imageSize,
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
          ClipPath(
            clipper: BottomRoundedClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                width: imageSize,
                height: 40.0,
                child: songsPlayLists.user == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          songsPlayLists.user!.name == null
                              ? ""
                              : '${songsPlayLists.title}',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: styleW600(
                            context,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - AppRadius.pLarge);
    path.quadraticBezierTo(0, size.height, AppRadius.pLarge, size.height);
    path.lineTo(size.width - AppRadius.pLarge, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - AppRadius.pLarge,);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
