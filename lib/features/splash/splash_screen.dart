import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

const splashLogoAsset = 'assets/images/splash.png';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go('/event');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    splashLogoAsset,
                    width: constraints.maxWidth,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.church,
                      size: 64,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(color: AppColors.primary),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
