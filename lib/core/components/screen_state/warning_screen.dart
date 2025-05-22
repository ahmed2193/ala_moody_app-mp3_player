import 'package:flutter/material.dart';

import '../../helper/font_style.dart';
import '../../utils/hex_color.dart';
import 'widget/blur_screen_widget.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurBGWidget(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                HexColor("#F4C856"),
                HexColor("#C5B317"),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              Text(
                'Warning',
                style: styleW600(context),
                textAlign: TextAlign.center,
              ),
              Text(
                'Something went wrong',
                style: styleW400(context),
                textAlign: TextAlign.center,

              ),
            ]
                .map(
                  (e) => Padding(
                padding: const EdgeInsets.all(8.0),
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
