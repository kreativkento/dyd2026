import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Auto-advancing carousel with fade transitions (used for dress-code shirts, venue maps, etc.).
class FadeAssetCarousel extends StatefulWidget {
  const FadeAssetCarousel({
    super.key,
    required this.assetPaths,
    this.aspectRatio = 4 / 3,
    this.slideDuration = const Duration(seconds: 3),
    this.fadeDuration = const Duration(milliseconds: 650),
    this.errorIcon = Icons.image_outlined,
    this.borderColor,
  });

  final List<String> assetPaths;
  final double aspectRatio;
  final Duration slideDuration;
  final Duration fadeDuration;
  final IconData errorIcon;
  final Color? borderColor;

  @override
  State<FadeAssetCarousel> createState() => _FadeAssetCarouselState();
}

class _FadeAssetCarouselState extends State<FadeAssetCarousel> {
  int _index = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoTimer?.cancel();
    if (widget.assetPaths.length <= 1) return;
    _autoTimer = Timer.periodic(widget.slideDuration, (_) {
      if (!mounted) return;
      _advance(1);
    });
  }

  void _advance(int delta) {
    final count = widget.assetPaths.length;
    if (count == 0) return;
    setState(() {
      _index = (_index + delta) % count;
      if (_index < 0) _index += count;
    });
    _startAutoAdvance();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetPaths.isEmpty) {
      return _Frame(
        borderColor: widget.borderColor,
        aspectRatio: widget.aspectRatio,
        child: _ErrorPlaceholder(icon: widget.errorIcon, label: 'No images configured'),
      );
    }

    final asset = widget.assetPaths[_index];
    final canSwipe = widget.assetPaths.length > 1;

    return GestureDetector(
      onHorizontalDragEnd: canSwipe
          ? (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity.abs() < 80) return;
              if (velocity < 0) {
                _advance(1);
              } else {
                _advance(-1);
              }
            }
          : null,
      child: _Frame(
        borderColor: widget.borderColor,
        aspectRatio: widget.aspectRatio,
        child: AnimatedSwitcher(
          duration: widget.fadeDuration,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final dpr = MediaQuery.devicePixelRatioOf(context);
              final maxSide = constraints.biggest.shortestSide;
              final cacheSide = maxSide.isFinite && maxSide > 0
                  ? (maxSide * dpr).round().clamp(1, 2048)
                  : null;

              return Image.asset(
                asset,
                key: ValueKey<String>(asset),
                fit: BoxFit.contain,
                gaplessPlayback: true,
                cacheWidth: cacheSide,
                errorBuilder: (_, __, ___) => _ErrorPlaceholder(
                  icon: widget.errorIcon,
                  label: 'Could not load image.\n$asset',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.child,
    required this.aspectRatio,
    this.borderColor,
  });

  final Widget child;
  final double aspectRatio;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final outline = borderColor ?? AppColors.blue.withValues(alpha: 0.14);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.04),
          border: Border.all(color: outline),
          borderRadius: BorderRadius.circular(14),
        ),
        child: AspectRatio(aspectRatio: aspectRatio, child: child),
      ),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.06),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
