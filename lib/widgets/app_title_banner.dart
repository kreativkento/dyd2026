import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

abstract final class AppTitleBannerAssets {
  static const image = 'assets/images/dyd_cover.png';
}

class AppTitleBanner extends StatelessWidget {
  const AppTitleBanner({
    super.key,
    this.imageAsset = AppTitleBannerAssets.image,
    this.heightFactor = 0.75,
  });

  final String imageAsset;

  /// Fraction of the image's natural height to display (crops top/bottom evenly).
  final double heightFactor;

  static const _aspectRatio = 2048 / 1228;

  @override
  Widget build(BuildContext context) {
    final displayAspectRatio = _aspectRatio / heightFactor;

    return AspectRatio(
      aspectRatio: displayAspectRatio,
      child: Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => const _TitleBannerPlaceholder(),
      ),
    );
  }
}

class _TitleBannerPlaceholder extends StatelessWidget {
  const _TitleBannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primary,
            AppColors.primary,
            AppColors.green,
            AppColors.blue,
            AppColors.yellow,
          ],
          stops: [0.0, 0.35, 0.55, 0.75, 1.0],
        ),
      ),
    );
  }
}
