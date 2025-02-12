import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../../../core/helper/font_style.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/helper/app_size.dart';
import '../../../main/presentation/cubit/main_cubit.dart';

class BannerButton extends StatelessWidget {
  const BannerButton({
    Key? key,
    required this.buttonText,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.listOfGradientBorder,
  }) : super(key: key);
  final String? buttonText;
  final GestureTapCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final List<Color>? listOfGradientBorder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            BlocProvider.of<MainCubit>(context).changeThem();
          },
      borderRadius: BorderRadius.circular(AppRadius.pDefault),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p4, vertical: AppPadding.p4,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pDefault),
          color: backgroundColor,
          border: listOfGradientBorder != null
              ? GradientBoxBorder(
                  gradient: LinearGradient(colors: listOfGradientBorder!),
                  width: 1.4,
                )
              : null,
        ),
        child: Text(
          AppLocalizations.of(context)!.translate('$buttonText')!,
          overflow: TextOverflow.ellipsis,
          style: styleW500(
            context,
            fontSize: FontSize.f14,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
