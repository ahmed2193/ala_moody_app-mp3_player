import 'dart:io';

class AdHelper {
  static String get interstitialAdUnitId {
    const bool testMode = true;

    if (testMode) {
      return 'ca-app-pub-3940256099942544/8691691433';
    } else if (Platform.isAndroid) {
      return "ca-app-pub-8612091469481696/7057553664";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8612091469481696/7057553664";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
