import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/locale/app_localizations.dart';
import '../helper/images.dart';

class NoData extends StatelessWidget {
  final String? message;
  const NoData({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double responsiveHeight = context.height * 0.3; // Adjust height dynamically
    final double responsiveFontSize = context.width * 0.045; // Adjust font size dynamically

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          ImagesPath.noData,
          height: responsiveHeight.clamp(100, 150), // Ensuring a min and max height
        ),
        SizedBox(
          height: context.height * 0.03,
        ),
        Text(
          message ?? AppLocalizations.of(context)!.translate("no_data_found")!,
          textAlign: TextAlign.center,
          style: styleW500(context, fontSize: responsiveFontSize),
        ),
      ],
    );
  }
}
