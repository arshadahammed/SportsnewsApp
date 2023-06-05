import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3920036584338725/4754235590";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3920036584338725/4754235590";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3920036584338725/8442199166";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3920036584338725/8442199166";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3920036584338725/5025698334";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3920036584338725/5025698334";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  //native android2
  static String get nativeAdUnitId2 {
    if (Platform.isAndroid) {
      return "ca-app-pub-3920036584338725/7431551583";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3920036584338725/7431551583";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // ca-app-pub-3940256099942544/2247696110

  //native Ios
  // ca-app-pub-3940256099942544/3986624511
}
