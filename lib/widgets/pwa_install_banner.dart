import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/pwa_install.dart';
import '../core/theme/app_theme.dart';

/// Shown on Android Chrome (and other Chromium browsers) when the PWA is not yet installed.
class PwaInstallBanner extends StatefulWidget {
  const PwaInstallBanner({super.key});

  static const _prefsKey = 'pwa_install_banner_dismissed_v1';

  @override
  State<PwaInstallBanner> createState() => _PwaInstallBannerState();
}

class _PwaInstallBannerState extends State<PwaInstallBanner> {
  bool _visible = false;
  bool _canInstall = false;
  bool _installing = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    _initWeb();
  }

  Future<void> _initWeb() async {
    if (PwaInstallPlatform.isStandalone) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(PwaInstallBanner._prefsKey) == true) return;

    // iOS uses Safari "Add to Home Screen"; Android uses Chrome install criteria.
    if (!PwaInstallPlatform.isAndroidBrowser) return;

    PwaInstallPlatform.listenForInstallAvailable(() {
      if (mounted) {
        setState(() {
          _canInstall = true;
          _visible = true;
        });
      }
    });

    PwaInstallPlatform.listenForInstalled(() {
      if (mounted) setState(() => _visible = false);
    });

    if (PwaInstallPlatform.canInstall) {
      _canInstall = true;
    }

    if (mounted) {
      setState(() => _visible = true);
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PwaInstallBanner._prefsKey, true);
    if (mounted) setState(() => _visible = false);
  }

  Future<void> _install() async {
    setState(() => _installing = true);
    try {
      final accepted = await PwaInstallPlatform.promptInstall();
      if (accepted && mounted) setState(() => _visible = false);
    } finally {
      if (mounted) setState(() => _installing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || !_visible) return const SizedBox.shrink();

    return Material(
      elevation: 6,
      color: AppColors.primaryDark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.install_mobile, color: AppColors.accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Install DYD 2026',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _canInstall
                          ? 'Add the app to your home screen for full-screen offline use.'
                          : 'In Chrome: tap ⋮ (menu) → Install app or Add to Home screen. Use Chrome, not an in-app browser.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            height: 1.35,
                          ),
                    ),
                    if (_canInstall) ...[
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: _installing ? null : _install,
                        icon: _installing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : const Icon(Icons.download, size: 18),
                        label: Text(_installing ? 'Installing…' : 'Install app'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: _dismiss,
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                tooltip: 'Dismiss',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
