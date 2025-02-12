// ignore_for_file: file_names

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/config/themes/colors.dart';
import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionOfDrawer extends StatelessWidget {
  const SectionOfDrawer({
    Key? key,
    required this.topTitle,
    required this.items,
  }) : super(key: key);
  final String? topTitle;
  final List<ListTileOfDrawer>? items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppPadding.pDefault),
          child: Text(
            AppLocalizations.of(context)!.translate(topTitle!)!,
            style: styleW500(
              context,
              fontSize: FontSize.f14,
            ),
          ),
        ),
        Column(
          children: List.generate(
            items!.length,
            (index) => items![index],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p10),
          child: Container(
            height: 1.4,
            color: AppColors.cGreyColor,
          ),
        ),
      ],
    );
  }
}

class ListTileOfDrawer extends StatelessWidget {
  const ListTileOfDrawer({
    Key? key,
    this.onTap,
    required this.colorCode,
    required this.imageOfLeading,
    required this.title,
    this.trailing,
  }) : super(key: key);
  final String colorCode;
  final String imageOfLeading;
  final String title;
  final GestureTapCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap ?? () {},
      leading: Container(
        padding: const EdgeInsetsDirectional.all(AppPadding.p4),
        decoration: BoxDecoration(
          color: HexColor(colorCode),
          borderRadius: BorderRadius.circular(AppPadding.p10),
        ),
        child:
        
        imageOfLeading.contains('.svg') ? 
         SvgPicture.asset(
          imageOfLeading,
          color: Colors.white,
          width: 28,
        ):  Image.asset(
          imageOfLeading,
          color: Colors.white,
          width: 28,
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.translate(title)!,
        style: styleW500(context, fontSize: FontSize.f14),
      ),
      trailing: trailing,
    );
  }
}
