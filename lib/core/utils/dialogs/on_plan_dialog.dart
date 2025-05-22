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
    print(isDarkMode.toString());
    return Dialog(
    backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child:
      
      
           Container(
        decoration:
         BoxDecoration(
            color: Colors.black,
            // border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

         SizedBox(height: 6,),

            // — Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                alertMsg,
                style: styleW600(context, fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 8),
            const Divider(color: Colors.white30, height: 1),

            // — Buttons
            Row(
              children: [
                // Cancel
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child:  Text(
                AppLocalizations.of(context)!.translate('cancel')!,
                style:
                    TextStyle(color: isDarkMode ? Colors.red[300] : Colors.red),
              ),
                    ),
                  ),
                ),

                // vertical divider
                Container(width: 1, height: 48, color: Colors.white30),

                // Confirm
                Expanded(
                  child: InkWell(
                    onTap: onTapConfirm,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child:
 Text(
                AppLocalizations.of(context)!.translate('ok')!,
                style: TextStyle(
                    color: isDarkMode ? Colors.blue[200] : Colors.blue),
              ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
   
      //  Container(
      //   // decoration: isDarkMode ? darkAlertDialogBackground : null,
      //   child: CupertinoAlertDialog(
      //     content: Text(
      //       alertMsg,
      //       style: styleW600(context,
      //           fontSize: 16,
      //           color: Theme.of(context).textTheme.bodyMedium?.color),
      //     ),
      //     actions: <Widget>[
      //       CupertinoDialogAction(
      //         onPressed: onTapCancel,
      //         child: Text(
      //           AppLocalizations.of(context)!.translate('cancel')!,
      //           style:
      //               TextStyle(color: isDarkMode ? Colors.red[300] : Colors.red),
      //         ),
      //       ),
      //       CupertinoDialogAction(
      //         onPressed: onTapConfirm,
      //         child: Text(
      //           AppLocalizations.of(context)!.translate('ok')!,
      //           style: TextStyle(
      //               color: isDarkMode ? Colors.blue[200] : Colors.blue),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
   
    );
  }
}
