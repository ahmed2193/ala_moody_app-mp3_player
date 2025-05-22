import 'package:flutter/material.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/font_style.dart';
import '../../../../../core/utils/back_arrow.dart';

class TobBarSectionMood extends StatelessWidget {
  const TobBarSectionMood({Key? key, this.name}) : super(key: key);
  final String? name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          const BackArrow(),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.only(top: AppPadding.p10),
              child: Column(
                children: [
                  // to title
                  Text(
                    AppLocalizations.of(context)!
                        .translate("how_do_you_feel?")!,
                    textAlign: TextAlign.center,
                    style: styleW600(context, fontSize: FontSize.f18),
                  ),
                  // welcome & name
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .translate("welcome_back!")!,
                        style: styleW400(context, fontSize: FontSize.f18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        ' ${name ?? ""}',
                        style: styleW700(context, fontSize: FontSize.f18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
