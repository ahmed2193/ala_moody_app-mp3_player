import 'package:alamoody/core/utils/dialogs/confirmation_dialog.dart';
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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent, // Removes default white background
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: isDarkMode ? darkAlertDialogBackground : null,
        padding: const EdgeInsets.all(16),
        child: CupertinoAlertDialog(
          content: Text(
            alertMsg,
            style: styleW600(context, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: onTapCancel,
              child: Text(
                AppLocalizations.of(context)!.translate('cancel')!,
                style: TextStyle(color: isDarkMode ? Colors.red[300] : Colors.red),
              ),
            ),
            CupertinoDialogAction(
              onPressed: onTapConfirm,
              child: Text(
                AppLocalizations.of(context)!.translate('ok')!,
                style: TextStyle(color: isDarkMode ? Colors.blue[200] : Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
