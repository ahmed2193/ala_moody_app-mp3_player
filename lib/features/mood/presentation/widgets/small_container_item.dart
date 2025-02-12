import 'package:alamoody/config/themes/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/media_query_values.dart';

class SmallContainerMood extends StatelessWidget {
  const SmallContainerMood({
    Key? key,
    this.isSelected = false,
    this.titleMood,
    this.image,
    this.color,
    this.onTap,
  }) : super(key: key);
  final bool isSelected;
  final String? titleMood;
  final String? image;
  final String? color;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p6),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: context.width * .25,
          height: context.width * .28,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              if (isSelected)
                Image.asset(
                  ImagesPath.moodsBorder,
                  width: context.width * .25,
                  height: context.width * .28,
                  fit: BoxFit.fill,
                ),
              // container
              Container(
                decoration: BoxDecoration(
                  color: color == null ? AppColors.cPrimary : HexColor(color!),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: context.width * .20,
                height: context.width * .22,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // emoji image
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => const Icon(Icons.error),

                        imageUrl: image!,
                        // if
                        width: 60,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
const SizedBox(height: 4,)  ,                  FittedBox(
                      child: Text(
                        titleMood ?? "",
                        style: styleW500(
                          context,
                          fontSize: FontSize.f12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
