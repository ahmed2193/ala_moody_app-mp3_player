import 'package:alamoody/features/main/presentation/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../main/presentation/cubit/locale_cubit.dart';
import 'icon_button_reuse.dart';

class TitleGoBar extends StatelessWidget {
  const TitleGoBar({
    Key? key,
    required this.text,
    this.imagePath,
    this.onPressed,
  }) : super(key: key);
  final String? text;
  final String? imagePath;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: AppPadding.p20, bottom: 4,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment  

.spaceBetween  ,
        children: [
          Text(
        text!   ,
            style:!MainCubit.isDark?styleW600(context, fontSize: 16 , color: HexColor('#58257F')): styleW600(context, fontSize: FontSize.f16),
          ),
          if (imagePath != null)
            RotatedBox(
              quarterTurns:  context.read<LocaleCubit>().currentLangCode =='ar'?2:4,
                                      
              child: ReusedIconButton(
                image: imagePath,
                onPressed: onPressed,
                width: 10,
              ),
            ),
        ],
      ),
    );
  }
}
