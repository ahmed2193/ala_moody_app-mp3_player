import 'dart:ui';

import 'package:flutter/material.dart';

class BlurBGWidget extends StatelessWidget {
  const BlurBGWidget({Key? key,required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.1),
            ),
          ),
          Center(child: child),
        ],
      ),
    );
  }
}
