import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/locale/app_localizations.dart';
import '../../helper/font_style.dart';

class ConfirmationDialog extends StatelessWidget {
  final String alertMsg;
  final VoidCallback onTapConfirm;

  const ConfirmationDialog(
      {Key? key, required this.alertMsg, required this.onTapConfirm,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Text(alertMsg, style: styleW600(context, fontSize: 16)),
      actions: <Widget>[
        TextButton(
            style: Theme.of(context).textButtonTheme.style,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.translate('cancel')!,
            ),),
        TextButton(
          style: Theme.of(context).textButtonTheme.style,
          onPressed: () => onTapConfirm(),
          child: Text(AppLocalizations.of(context)!.translate('ok')!),
        ),
      ],
    );
  }
}
