import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/helper/font_style.dart';

class GradientRoundedButton extends StatelessWidget {
  const GradientRoundedButton({
    Key? key,
    required this.buttonText,
    this.onTap,
    this.backgroundColor,
    this.listOfGradient,
    this.circleAvatarColor,
    this.listOfGradientBorder,
    required this.startIcon,
  }) : super(key: key);
  final String? buttonText;
  final GestureTapCallback? onTap;
  final Color? backgroundColor;
  final Color? circleAvatarColor;
  final List<Color>? listOfGradient;
  final List<Color>? listOfGradientBorder;
  final Widget? startIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(32),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: AppPadding.p6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomStart,
            end: const Alignment(0, 2),
            // 10% of the width, so there are ten blinds.
            colors: listOfGradient!,
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
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: circleAvatarColor ?? Colors.white,
              child: startIcon,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Text(
                '$buttonText',
                overflow: TextOverflow.ellipsis,
                style: styleW400(
                  context,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
