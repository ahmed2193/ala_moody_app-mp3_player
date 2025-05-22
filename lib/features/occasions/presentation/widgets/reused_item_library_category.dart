import 'package:alamoody/core/utils/song_item.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image and shadow
          Expanded(
            child: Container(
              width: 100,
              // height: 90,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: HexColor("#01E1D9").withOpacity(.6),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(AppRadius.pLarge),
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
          // name
          Text(
            library.artists![0].name!,
            style: styleW400(
              context,
              fontSize: FontSize.f10,
              color: AppColors.cOffWhite2,
            ),
          ),
          // title
          Text(
            library.title!,
            style: styleW500(
              context,
            )!
                .copyWith(
              fontSize: FontSize.f14,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
