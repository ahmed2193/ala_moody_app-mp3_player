import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReusedIconButton extends StatelessWidget {
  const ReusedIconButton({
    Key? key,
    required this.image,
    this.onPressed,
    this.width,
  }) : super(key: key);
  final String? image;
  final double? width;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
      icon: SvgPicture.asset(
        image!,
        color: Theme.of(context).primaryIconTheme.color,
        width: width ?? 26,
      ),
    );
  }
}
