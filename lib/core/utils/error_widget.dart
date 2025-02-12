import 'package:flutter/material.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import '../../config/locale/app_localizations.dart';
import '../../config/themes/colors.dart';
import '../../features/auth/presentation/widgets/gradient_auth_button.dart';
import '../helper/font_style.dart';
import 'constants.dart';
import 'hex_color.dart';

class ErrorWidget extends StatelessWidget {
  final String msg;
  final VoidCallback? onRetryPressed;

  const ErrorWidget({Key? key, required this.msg, this.onRetryPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = constraints.maxWidth * 0.3; // Adaptive icon size
        double textFontSize = constraints.maxWidth < 400 ? 16 : 18; // Adjust font size for smaller screens

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Warning Icon
              Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.cPrimary,
                  size: iconSize < 100 ? 100 : iconSize, // Minimum size is 100
                ),
              ),
              
              // Error Message
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
                child: Text(
                  Constants.handleErrorMsg(context, msg)!,
                  style: styleW700(context, fontSize: textFontSize),
                  textAlign: TextAlign.center,
                ),
              ),

              // Try Again Text
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
                child: Text(
                  AppLocalizations.of(context)!.translate('try_again')!,
                  style: styleW400(context, fontSize: textFontSize),
                  textAlign: TextAlign.center,
                ),
              ),

              // Retry Button
              Container(
                width: constraints.maxWidth * 0.65, // Adjust button width
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: GradientCenterTextButton(
                  buttonText: AppLocalizations.of(context)!.translate('reload_screen'),
                  listOfGradient: [
                    HexColor("#DF23E1"),
                    HexColor("#3820B2"),
                    HexColor("#39BCE9"),
                  ],
                  onTap: () {
                    if (onRetryPressed != null) {
                      onRetryPressed!();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
