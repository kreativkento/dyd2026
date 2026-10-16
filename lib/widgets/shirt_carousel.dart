import 'package:flutter/material.dart';

import 'fade_asset_carousel.dart';

/// Official DYD shirt colors shown on the Dress Code guidelines section.
abstract final class ShirtCarouselAssets {
  static const paths = [
    'assets/images/shirts/dc_1.png',
    'assets/images/shirts/dc_2.png',
    'assets/images/shirts/dc_3.png',
    'assets/images/shirts/dc_4.png',
    'assets/images/shirts/dc_5.png',
  ];
}

class ShirtCarousel extends StatelessWidget {
  const ShirtCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeAssetCarousel(
      assetPaths: ShirtCarouselAssets.paths,
      errorIcon: Icons.checkroom_outlined,
    );
  }
}
