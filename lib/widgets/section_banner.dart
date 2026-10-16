import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

abstract final class SectionBannerAssets {
  static const image = 'assets/images/section_banner.png';
}

/// Compact banner for subsection/detail screens.
class SectionBanner extends StatelessWidget {
  const SectionBanner({
    super.key,
    this.imageAsset = SectionBannerAssets.image,
    this.heightFactor = 1.0,
  });

  final String imageAsset;

  /// Fraction of the image's natural height to display (crops top/bottom evenly).
  final double heightFactor;

  static const _aspectRatio = 2048 / 327;

  @override
  Widget build(BuildContext context) {
    final displayAspectRatio = _aspectRatio / heightFactor;

    return AspectRatio(
      aspectRatio: displayAspectRatio,
      child: Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => const _SectionBannerPlaceholder(),
      ),
    );
  }
}

class _SectionBannerPlaceholder extends StatelessWidget {
  const _SectionBannerPlaceholder();

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
