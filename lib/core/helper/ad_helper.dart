import 'dart:io';

class AdHelper {
  final bool testMode;

  AdHelper({this.testMode = true});

  String get interstitialAdUnitId {
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
