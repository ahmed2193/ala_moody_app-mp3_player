import 'package:alamoody/core/utils/hex_color.dart';
import 'package:flutter/material.dart';

class DownloadProgressWidget extends StatelessWidget {
  const DownloadProgressWidget({
    super.key,
    required this.progress,
  });
  final double progress;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [HexColor('#3D8B86'), HexColor('#D3F570')],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            CircularProgressIndicator(
              value: progress / 100,
              strokeWidth: 8.0, // Adjust the thickness of the progress line
              backgroundColor: Colors.grey.shade200,
            ),
            Positioned(
              child: Text(
                '${(progress ).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change text color for contrast
                ),
              ),
            ),
          ],
        ));
  }
}
