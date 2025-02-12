import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../core/helper/app_size.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/media_query_values.dart';

class IconButtonOfPlay extends StatelessWidget {
  const IconButtonOfPlay({
    Key? key,
    required this.icon,
    this.width,
    this.widthOfBorder,
    this.onPressed,
    this.padding,
  }) : super(key: key);
  final Widget icon;
  final double? width;
  final double? padding;
  final double? widthOfBorder;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
     // highlightColor: Colors.white.withOpacity(.5),
      icon: Container(
        padding: EdgeInsets.all(padding??AppPadding.p4 - 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                HexColor("#A866AE"),
                HexColor("#37C3EE"),
              ],
            ),
            width: widthOfBorder??3,
          ),
        ),
        child:icon,
        //  IconReuseForPlayBar(
        //   icon: icon,
        //   width: width,
        // ),
      ),
    );
  }
}

class IconReuseForPlayBar extends StatelessWidget {
  const IconReuseForPlayBar({
    Key? key,
    required this.icon,
    this.width,
  }) : super(key: key);
  final IconData icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white,
      size: width ?? context.width * .05,
    );
  }
}
