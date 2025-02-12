import 'package:flutter/cupertino.dart';

import '../../../../../config/themes/colors.dart';
import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/font_style.dart';

class LyricsSection extends StatelessWidget {
  const LyricsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppPadding.p20),
        Text(
          "But now give up",
          style: styleW400(
            context,
            fontSize: FontSize.f10,
            color: AppColors.cOffWhite,
          ),
        ),
        Text(
          "Go easy on me, baby ",
          style: styleW600(
            context,
            fontSize: FontSize.f12,
          ),
        ),
      ],
    );
  }
}
