import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../data/dyd_gallery_assets.dart';

Future<void> showDydLogoGalleryModal(BuildContext context) {
  return showDydImageGalleryModal(
    context,
    title: 'DYD Logo',
    subtitle: 'Official logo variants',
    accent: AppColors.yellow,
    headerIcon: Icons.image_outlined,
    assetDirectory: DydGalleryAssets.logoDirectory,
    fallbackAssets: DydGalleryAssets.logoFallback,
  );
}

Future<void> showDydBrandingGalleryModal(BuildContext context) {
  return showDydImageGalleryModal(
    context,
    title: 'Branding',
    subtitle: 'Colors, marks & usage',
    accent: AppColors.primary,
    headerIcon: Icons.palette_outlined,
    assetDirectory: DydGalleryAssets.brandingDirectory,
  );
}

Future<void> showDydImageGalleryModal(
  BuildContext context, {
  required String title,
  required String assetDirectory,
  String subtitle = '',
  Color accent = AppColors.primary,
  IconData headerIcon = Icons.photo_library_outlined,
  List<String> fallbackAssets = const [],
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.82),
    builder: (dialogContext) => _DydImageGalleryDialog(
      title: title,
      subtitle: subtitle,
      accent: accent,
      headerIcon: headerIcon,
      assetDirectory: assetDirectory,
      fallbackAssets: fallbackAssets,
    ),
  );
}

Future<List<String>> _resolveGalleryAssetPaths({
  required String assetDirectory,
  required List<String> fallbackAssets,
}) async {
  final prefix =
      assetDirectory.endsWith('/') ? assetDirectory : '$assetDirectory/';

  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final paths = manifest
      .listAssets()
      .where((path) => _isGalleryImagePath(path, prefix))
      .toList()
    ..sort();

  if (paths.isNotEmpty) return paths;
  return List<String>.from(fallbackAssets);
}

bool _isGalleryImagePath(String path, String directoryPrefix) {
  if (!path.startsWith(directoryPrefix)) return false;
  final lower = path.toLowerCase();
  return lower.endsWith('.png') ||
      lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.webp') ||
      lower.endsWith('.gif');
}

class _DydImageGalleryDialog extends StatelessWidget {
  const _DydImageGalleryDialog({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.headerIcon,
    required this.assetDirectory,
    required this.fallbackAssets,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData headerIcon;
  final String assetDirectory;
  final List<String> fallbackAssets;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final carouselHeight = (size.width * 0.78).clamp(280.0, 420.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: size.height * 0.9,
        ),
        child: Material(
          color: AppColors.surface,
          elevation: 12,
          shadowColor: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GalleryModalHeader(
                title: title,
                subtitle: subtitle,
                accent: accent,
                icon: headerIcon,
                onClose: () => Navigator.of(context).pop(),
              ),
              SizedBox(
                height: carouselHeight,
                width: double.infinity,
                child: FutureBuilder<List<String>>(
                  future: _resolveGalleryAssetPaths(
                    assetDirectory: assetDirectory,
                    fallbackAssets: fallbackAssets,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: accent,
                          strokeWidth: 2.5,
                        ),
                      );
                    }

                    final assets = snapshot.data ?? const [];
                    if (assets.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_outlined,
                              size: 44,
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.45),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No images in this gallery yet.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.45,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    return _DydImageGalleryCarousel(
                      assets: assets,
                      accent: accent,
                    );
                  },
                ),
              ),
              const _GalleryModalFooterHint(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryModalHeader extends StatelessWidget {
  const _GalleryModalHeader({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            accent.withValues(alpha: 0.14),
            accent.withValues(alpha: 0.04),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: accent.withValues(alpha: 0.12)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withValues(alpha: 0.22)),
              ),
              child: Icon(icon, color: _brandAccentGlyph(accent), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: AppColors.textPrimary,
                          height: 1.15,
                        ),
                  ),
                  if (subtitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.25,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: 'Close',
              onPressed: onClose,
              icon: Icon(
                Icons.close_rounded,
                color: AppColors.textSecondary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _brandAccentGlyph(Color accent) {
  if (accent.toARGB32() == AppColors.yellow.toARGB32()) {
    return AppColors.primaryDark;
  }
  return accent;
}

class _GalleryModalFooterHint extends StatelessWidget {
  const _GalleryModalFooterHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Text(
        'Swipe to browse · pinch or tap zoom to inspect',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.85),
              fontSize: 11,
              height: 1.3,
            ),
      ),
    );
  }
}

class _DydImageGalleryCarousel extends StatefulWidget {
  const _DydImageGalleryCarousel({
    required this.assets,
    required this.accent,
  });

  final List<String> assets;
  final Color accent;

  @override
  State<_DydImageGalleryCarousel> createState() =>
      _DydImageGalleryCarouselState();
}

class _DydImageGalleryCarouselState extends State<_DydImageGalleryCarousel> {
  late final PageController _pageController;
  int _itemIndex = 0;
  bool _isAnimating = false;

  int get _count => widget.assets.length;
  bool get _canLoop => _count > 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _animateToIndex(int targetIndex) async {
    if (!_pageController.hasClients || _isAnimating || _count <= 0) return;

    final index = targetIndex.clamp(0, _count - 1);
    if (index == _itemIndex) return;

    setState(() => _isAnimating = true);
    try {
      await _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } finally {
      if (mounted) setState(() => _isAnimating = false);
    }
  }

  void _goNext() {
    if (!_canLoop || _isAnimating || !_pageController.hasClients) return;

    if (_itemIndex >= _count - 1) {
      _pageController.jumpToPage(0);
      setState(() => _itemIndex = 0);
      return;
    }

    _animateToIndex(_itemIndex + 1);
  }

  void _goPrevious() {
    if (!_canLoop || _isAnimating || !_pageController.hasClients) return;

    if (_itemIndex <= 0) {
      final last = _count - 1;
      _pageController.jumpToPage(last);
      setState(() => _itemIndex = last);
      return;
    }

    _animateToIndex(_itemIndex - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _count,
                onPageChanged: (page) {
                  setState(() => _itemIndex = page);
                },
                itemBuilder: (context, page) {
                  return _ZoomableCarouselSlide(
                    assetPath: widget.assets[page],
                    accent: widget.accent,
                  );
                },
              ),
              if (_canLoop) ...[
                Positioned(
                  left: 6,
                  child: _CarouselNavButton(
                    icon: Icons.chevron_left_rounded,
                    accent: widget.accent,
                    onPressed: _isAnimating ? null : _goPrevious,
                  ),
                ),
                Positioned(
                  right: 6,
                  child: _CarouselNavButton(
                    icon: Icons.chevron_right_rounded,
                    accent: widget.accent,
                    onPressed: _isAnimating ? null : _goNext,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_canLoop)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: widget.accent.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    '${_itemIndex + 1} / $_count',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _brandAccentGlyph(widget.accent),
                          fontSize: 12,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                ...List.generate(_count, (index) {
                  final active = index == _itemIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? widget.accent
                          : AppColors.textSecondary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ],
            ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }
}

class _CarouselNavButton extends StatelessWidget {
  const _CarouselNavButton({
    required this.icon,
    required this.accent,
    required this.onPressed,
  });

  final IconData icon;
  final Color accent;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final iconColor = enabled
        ? _brandAccentGlyph(accent)
        : AppColors.textSecondary.withValues(alpha: 0.35);

    return Material(
      color: AppColors.surface.withValues(alpha: enabled ? 0.92 : 0.65),
      elevation: enabled ? 3 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: iconColor, size: 26),
        ),
      ),
    );
  }
}

class _ZoomableCarouselSlide extends StatelessWidget {
  const _ZoomableCarouselSlide({
    required this.assetPath,
    required this.accent,
  });

  final String assetPath;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: accent.withValues(alpha: 0.12)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: _InteractiveGalleryImage(assetPath: assetPath),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: _GalleryZoomButton(assetPath: assetPath),
          ),
        ],
      ),
    );
  }
}

class _InteractiveGalleryImage extends StatelessWidget {
  const _InteractiveGalleryImage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      clipBehavior: Clip.hardEdge,
      minScale: 1,
      maxScale: 5,
      panEnabled: true,
      scaleEnabled: true,
      boundaryMargin: const EdgeInsets.all(28),
      child: Center(
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => const Padding(
            padding: EdgeInsets.all(24),
            child: _GalleryImageError(),
          ),
        ),
      ),
    );
  }
}

class _GalleryZoomButton extends StatelessWidget {
  const _GalleryZoomButton({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryDark.withValues(alpha: 0.72),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showFullScreenZoom(context, assetPath),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.zoom_in_rounded, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                'Zoom',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showFullScreenZoom(BuildContext context, String assetPath) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.94),
    builder: (zoomContext) {
      return Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            minScale: 0.8,
            maxScale: 8,
            panEnabled: true,
            scaleEnabled: true,
            boundaryMargin: const EdgeInsets.all(80),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => const Padding(
                padding: EdgeInsets.all(32),
                child: _GalleryImageError(),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(zoomContext).top + 8,
            right: 12,
            child: Material(
              color: Colors.white.withValues(alpha: 0.14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(zoomContext).pop(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _GalleryImageError extends StatelessWidget {
  const _GalleryImageError();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
        const SizedBox(height: 8),
        Text(
          'Could not load image',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
