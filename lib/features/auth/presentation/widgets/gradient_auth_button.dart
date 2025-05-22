import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../../../core/helper/font_style.dart';

class GradientCenterTextButton extends StatelessWidget {
  const GradientCenterTextButton(
      {Key? key,
      required this.buttonText,
      this.onTap,
      this.backgroundColor,
      this.textColor,
      this.listOfGradient,
      this.circleAvatarColor,
      this.listOfGradientBorder,
      this.icon = const SizedBox(),
      this.width = double.infinity,
      
      }
      )
      : super(key: key);
  final String? buttonText;
  final GestureTapCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? circleAvatarColor;
  final List<Color>? listOfGradient;
  final List<Color>? listOfGradientBorder;
  final Widget? icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(32),
      child: Container(
          alignment: Alignment.center,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              //begin: AlignmentDirectional.bottomStart,
              end: const Alignment(1, 2),
              // 10% of the width, so there are ten blinds.
              colors: listOfGradient ??
                  [
                    Colors.white,
                    Colors.white,
                  ],
            ),
            color: backgroundColor,
            border: listOfGradientBorder != null
                ? GradientBoxBorder(
                    gradient: LinearGradient(colors: listOfGradientBorder!),
                    width: 1.4,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon!,
              Text(
                '$buttonText',
                overflow: TextOverflow.ellipsis,
                style: styleW400(
                  context,
                  fontSize: 16,
                  color: textColor ?? Colors.white,
                ),
              ),
            ],
          ),),
    );
  }
}
