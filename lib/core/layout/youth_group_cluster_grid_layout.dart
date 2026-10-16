import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Cluster grid on the Groups tab — proportions match a ~360dp-wide phone.
abstract final class YouthGroupClusterGridLayout {
  static const crossAxisCount = 4;

  /// Width inside [AppLayout.tabHorizontalPadding] on the design device.
  static const designContentWidth =
      360.0 - AppLayout.tabHorizontalPadding * 2;

  static const designCellWidth = designContentWidth / crossAxisCount;

  static const childAspectRatio = 0.78;

  static const designLogoSize = 62.208;
  static const designLabelFontSize = 9.45;
  static const designMainAxisSpacing = 4.0;
  static const designCellVerticalPadding = 4.0;
  static const designCellHorizontalPadding = 2.0;

  static const _minScale = 0.72;
  static const _maxScale = 1.28;

  static double contentWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width -
        AppLayout.tabHorizontalPadding * 2;
  }

  static double cellWidth(BuildContext context) {
    return contentWidth(context) / crossAxisCount;
  }

  /// Scale factor from design cell width; clamped for very small/large phones.
  static double scaleForCellWidth(double cellWidth) {
    return (cellWidth / designCellWidth).clamp(_minScale, _maxScale);
  }

  static double scale(BuildContext context) =>
      scaleForCellWidth(cellWidth(context));

  static double logoSizeForCellWidth(double cellWidth) =>
      designLogoSize * scaleForCellWidth(cellWidth);

  static double labelFontSizeForCellWidth(double cellWidth) =>
      designLabelFontSize * scaleForCellWidth(cellWidth);

  static EdgeInsets cellPaddingForCellWidth(double cellWidth) {
    final s = scaleForCellWidth(cellWidth);
    return EdgeInsets.symmetric(
      vertical: designCellVerticalPadding * s,
      horizontal: designCellHorizontalPadding * s,
    );
  }

  static SliverGridDelegate gridDelegate(BuildContext context) {
    final spacing = designMainAxisSpacing * scale(context);
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: spacing,
      crossAxisSpacing: 0,
      childAspectRatio: childAspectRatio,
    );
  }
}
