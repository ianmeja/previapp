import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1493005695014214~2413569177";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1493005695014214/1368080817";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1493005695014214/1559652502";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1493005695014214/2489590794";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}