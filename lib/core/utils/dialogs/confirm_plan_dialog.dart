import 'package:flutter/material.dart';
import '../../../config/locale/app_localizations.dart';
import '../../helper/font_style.dart';

class ConfirmationPlanDialog extends StatelessWidget {
  // final String title;
  final String alertMsg;
  final VoidCallback onTapConfirm;

  const ConfirmationPlanDialog({
    Key? key,
    // this.title = "Confirm Subscription",
    required this.alertMsg,
    required this.onTapConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      child:
       Container(
        decoration: BoxDecoration(
            color: Colors.black,
            // border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // — Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                AppLocalizations.of(context)!.translate('confirm_sub')!,
                style: styleW600(context, fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

            // — Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                alertMsg,
                style: styleW600(context, fontSize: 16, color: Colors.white70),
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
                      child: Text(
                        AppLocalizations.of(context)!.translate('cancel_plan')!,
                        style: styleW600(context,
                            fontSize: 16, color: Colors.redAccent),
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
                      child: Text(
                        AppLocalizations.of(context)!.translate('confirm')!,
                        style: styleW600(context,
                            fontSize: 16, color: Colors.lightGreenAccent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
   
   
    );
  }
}


/// A simple light background if you need it
final BoxDecoration lightAlertDialogBackground = BoxDecoration(
  color: Colors.white,
);
