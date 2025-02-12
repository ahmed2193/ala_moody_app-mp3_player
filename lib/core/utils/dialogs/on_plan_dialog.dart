import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/locale/app_localizations.dart';
import '../../helper/font_style.dart';

class OnPlanDialog extends StatelessWidget {
  final String alertMsg;
  final VoidCallback onTapConfirm;
  final VoidCallback onTapCancel;

  const OnPlanDialog({
    Key? key,
    required this.alertMsg,
    required this.onTapConfirm,
    required this.onTapCancel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Text(alertMsg, style: styleW600(context, fontSize: 16)),
      actions: <Widget>[
        TextButton(
          style: Theme.of(context).textButtonTheme.style,
          onPressed: () => onTapCancel(),
          child: Text(
            AppLocalizations.of(context)!.translate('cancel')!,
          ),
        ),
        TextButton(
          style: Theme.of(context).textButtonTheme.style,
          onPressed: () => onTapConfirm(),
          child: Text(AppLocalizations.of(context)!.translate('ok')!),
        ),
      ],
    );
  }
}
