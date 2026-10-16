import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web: bridge to [web/index.html] PWA install helpers.
class PwaInstallPlatform {
  static bool get canInstall => _dydPwaCanInstall();

  static bool get isStandalone => _dydPwaIsStandalone();

  static bool get isAndroidBrowser => _dydPwaIsAndroid();

  static bool get isIosBrowser => _dydPwaIsIOS();

  static Future<bool> promptInstall() async {
    final result = await _dydPwaPromptInstall().toDart;
    return result.dartify() == true;
  }

  static void listenForInstallAvailable(void Function() onAvailable) {
    web.window.addEventListener(
      'dyd-pwa-install-available',
      ((web.Event _) => onAvailable()).toJS,
    );
  }

  static void listenForInstalled(void Function() onInstalled) {
    web.window.addEventListener(
      'dyd-pwa-installed',
      ((web.Event _) => onInstalled()).toJS,
    );
  }
}

@JS('dydPwaCanInstall')
external bool _dydPwaCanInstall();

@JS('dydPwaIsStandalone')
external bool _dydPwaIsStandalone();

@JS('dydPwaIsAndroid')
external bool _dydPwaIsAndroid();

@JS('dydPwaIsIOS')
external bool _dydPwaIsIOS();

@JS('dydPwaPromptInstall')
external JSPromise _dydPwaPromptInstall();
