import 'package:flutter/material.dart';

import '../../../config/locale/app_localizations.dart';
import '../../helper/font_style.dart';
import '../../utils/hex_color.dart';
import 'widget/blur_screen_widget.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, required this.tryAgin}) : super(key: key);
  final VoidCallback tryAgin;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurBGWidget(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                HexColor("#FF3F3F"),
                HexColor("#FD7575"),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              Text(
                'Error',
                style: styleW600(context),
                textAlign: TextAlign.center,
              ),
              Text(
                'It seems like there was a problem',
                style: styleW400(context),
                textAlign: TextAlign.center,
              ),
              // rounded button
              ElevatedButton(
                onPressed: 
                  tryAgin,
                
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('try_again')!,
                  style: TextStyle(
                    color: HexColor("#FF3F3F"),
                  ),
                ),
              ),
            ]
                .map(
                  (e) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: e,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
