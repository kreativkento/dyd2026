import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    required this.avatarAsset,
    this.size = 36,
    this.fit = BoxFit.cover,
    this.photoBackground,
  });

  final String avatarAsset;
  final double size;
  final BoxFit fit;
  final Color? photoBackground;

  bool get _isCommitteePhoto =>
      avatarAsset.contains('/committee/') ||
      avatarAsset.contains('/people/');

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: ColoredBox(
          color: photoBackground ??
              (_isCommitteePhoto
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : Colors.transparent),
          child: Image.asset(
            avatarAsset,
            fit: fit,
            gaplessPlayback: true,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => _Fallback(size: size),
          ),
        ),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(
          Icons.person_outline,
          size: size * 0.55,
          color: AppColors.primary.withValues(alpha: 0.65),
        ),
      ),
    );
  }
}
