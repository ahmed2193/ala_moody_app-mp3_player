import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/locale/app_localizations.dart';
import '../../helper/font_style.dart';

class ConfirmationDialog extends StatelessWidget {
  final String alertMsg;
  final VoidCallback onTapConfirm;

  const ConfirmationDialog({
    Key? key,
    required this.alertMsg,
    required this.onTapConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
      child: Dialog(
        backgroundColor: Colors.transparent, // Remove default white background
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          
          decoration: isDarkMode ? darkAlertDialogBackground : null,
          padding: const EdgeInsets.all(16),
          child: CupertinoAlertDialog(
            content: Text(
              alertMsg,
              style: styleW600(context, fontSize: 16, color: Colors.white),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  AppLocalizations.of(context)!.translate('cancel')!,
                  style: TextStyle(color: isDarkMode ? Colors.red[300] : Colors.red),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () => onTapConfirm(),
                child: Text(
                  AppLocalizations.of(context)!.translate('ok')!,
                  style: TextStyle(color: isDarkMode ? Colors.blue[200] : Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
const BoxDecoration darkAlertDialogBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(30, 10, 60, 1),  // Deep Purple
      Color.fromRGBO(50, 20, 100, 0.9),  // Rich Blue
      Color.fromRGBO(70, 40, 140, 0.8),  // Darker Cyan
      Color.fromRGBO(90, 60, 180, 0.7),  // Soft Glow Effect
    ],
    stops: [0.0, 0.3, 0.6, 1.0],
  ),
  borderRadius: BorderRadius.all(Radius.circular(15)),
);















