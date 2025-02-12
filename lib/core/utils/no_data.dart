import 'package:alamoody/core/helper/font_style.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/locale/app_localizations.dart';
import '../helper/images.dart';

class NoData extends StatelessWidget {
  final String? message;
  final double height;
  const NoData({Key? key, this.message, this.height = 250}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          ImagesPath.noData,
          height: height,
        ),
        SizedBox(
          height: context.height * 0.03,
        ),
        Text(
          message ?? AppLocalizations.of(context)!.translate("no_data_found")!,
          textAlign: TextAlign.center,
          style: styleW500(context, fontSize: 18),
        ),
      ],
    );
  }
}
