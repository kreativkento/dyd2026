/// Non-web platforms: PWA install is not applicable.
class PwaInstallPlatform {
  static bool get canInstall => false;

  static bool get isStandalone => false;

  static bool get isAndroidBrowser => false;

  static bool get isIosBrowser => false;

  static Future<bool> promptInstall() async => false;

  static void listenForInstallAvailable(void Function() onAvailable) {}

  static void listenForInstalled(void Function() onInstalled) {}
}
