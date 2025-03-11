import 'package:alamoody/core/utils/song_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/entities/songs.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/hex_color.dart';

class ItemOfLibraryCategory extends StatelessWidget {
  const ItemOfLibraryCategory({
    Key? key,
    required this.library,
  }) : super(key: key);
  final Songs library;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize =
        screenWidth * 0.25; // Adjust the size relative to screen width
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

    final double logicalSize = 280 / devicePexelRatio;
    final borderRadius = screenWidth * 0.03; // 3% of screen width
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and shadow
          Expanded(
            child: Container(
              width: screenWidth / 4,
              height: logicalSize, // Ensure the container is square
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: HexColor("#01E1D9").withOpacity(.6),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4), // Changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(borderRadius),
                image: DecorationImage(
                  image: NetworkImage(
                    library.artworkUrl!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: AudioWave(
                song: library,
              ),
            ),
          ),
          const SizedBox(
            height: AppPadding.p10,
          ),
          // Artist name
          SizedBox(
            width: imageSize - 10,
            child: Text(
              library.artists != null && library.artists!.isNotEmpty
                  ? library.artists![0].name!
                  : 'Unknown',
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: styleW400(
                context,
                fontSize: screenWidth *
                    0.025, // Adjust the font size relative to screen width
                color: AppColors.cOffWhite2,
              ),
            ),
          ),
          // Song title
          SizedBox(
            width: imageSize,
            child: Text(
              library.title!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: styleW500(
                context,
              )!
                  .copyWith(
                fontSize: screenWidth *
                    0.030, // Adjust the font size relative to screen width
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
