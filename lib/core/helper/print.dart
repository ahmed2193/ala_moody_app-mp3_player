import 'package:flutter/foundation.dart'; // Import for kDebugMode

void printColored(dynamic message, {int colorCode = 36}) {
  if (kDebugMode) {
    // ANSI color codes for different colors
    const colorCodes = {
      31: '\x1B[31m', // Red for errors
      32: '\x1B[32m', // Green for success
      33: '\x1B[33m', // Yellow for warnings or general info
      36: '\x1B[36m', // Cyan (light blue) for default
    };
    const String resetColor = '\x1B[0m'; // Reset to default color

    // Set the color code based on input, or fall back to cyan if not found
    final color = colorCodes[colorCode] ?? colorCodes[36];

    print('$color$message$resetColor');
  }
}

