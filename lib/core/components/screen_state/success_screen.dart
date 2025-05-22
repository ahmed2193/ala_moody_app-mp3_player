import 'package:flutter/material.dart';

import '../../helper/font_style.dart';
import '../../utils/hex_color.dart';
import 'widget/blur_screen_widget.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

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
                HexColor("#14CE78"),
                HexColor("#198754"),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              Text(
                'Success',
                style: styleW600(context),
                textAlign: TextAlign.center,
              ),
              Text(
                'You have been successful',
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
