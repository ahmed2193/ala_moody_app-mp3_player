import 'package:flutter/material.dart';

import '../../../../../../config/themes/colors.dart';
import '../../../../../../core/helper/font_style.dart';
import '../../../../config/locale/app_localizations.dart';

class ReuseCheckbox extends StatelessWidget {
  const ReuseCheckbox({Key? key, this.value, this.onChanged}) : super(key: key);
  final bool? value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: AppColors.cPrimary,
          fillColor: WidgetStateProperty.all(Colors.transparent),
          checkColor: AppColors.cPrimary,
          value: value ?? false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              color: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          onChanged: onChanged,
        ),
        Text(
          AppLocalizations.of(context)!.translate("remember_me")!,
          style: styleW400(context),
        ),
      ],
    );
  }
}
