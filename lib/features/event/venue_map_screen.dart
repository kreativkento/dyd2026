import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/venue_map_areas.dart';
import '../../models/content_models.dart';
import '../../widgets/app_page_scaffold.dart';
import '../../widgets/fade_asset_carousel.dart';
import '../../widgets/section_header.dart';

class VenueMapScreen extends StatefulWidget {
  const VenueMapScreen({super.key, required this.section});

  final ContentSection section;

  @override
  State<VenueMapScreen> createState() => _VenueMapScreenState();
}

class _VenueMapScreenState extends State<VenueMapScreen> {
  late VenueMapArea _selected = venueMapAreaById('whole_venue');

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          SectionHeader(
            title: widget.section.title,
            subtitle: widget.section.subtitle?.trim().isNotEmpty == true
                ? widget.section.subtitle
                : null,
          ),
          const SizedBox(height: 16),
          _VenueAreaSelector(
            selected: _selected,
            onChanged: (area) => setState(() => _selected = area),
          ),
          const SizedBox(height: 12),
          if (_selected.usesCarousel)
            FadeAssetCarousel(
              key: ValueKey(_selected.id),
              assetPaths: _selected.carouselAssets!,
              aspectRatio: _selected.carouselAspectRatio ?? 4 / 3,
              errorIcon: Icons.map_outlined,
              borderColor: AppColors.primary.withValues(alpha: 0.12),
            )
          else if (_selected.usesStackedGallery)
            _VenueStackedImages(
              key: ValueKey(_selected.id),
              assetPaths: _selected.stackedAssets!,
              hideErrorPlaceholder: _selected.id == 'parking_area',
            )
          else
            _VenueMapImageFrame(
              key: ValueKey(_selected.id),
              child: _VenueMapFullWidthImage(
                assetPath: _selected.displayImageAsset,
              ),
            ),
        ],
      ),
    );
  }
}

class _VenueAreaSelector extends StatelessWidget {
  const _VenueAreaSelector({
    required this.selected,
    required this.onChanged,
  });

  final VenueMapArea selected;
  final ValueChanged<VenueMapArea> onChanged;

  static const _venueAccent = Color(0xFF9CA3AF);
  static const _radius = 14.0;

  static const _fieldTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    letterSpacing: 0,
    height: 1.3,
  );

  @override
  Widget build(BuildContext context) {
    final outline = _venueAccent.withValues(alpha: 0.45);
    final fill = _venueAccent.withValues(alpha: 0.08);
    final menuShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_radius),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<VenueMapArea>(
          key: ValueKey(selected.id),
          initialSelection: selected,
          onSelected: (area) {
            if (area == null) return;
            onChanged(area);
          },
          enableFilter: false,
          requestFocusOnTap: false,
          expandedInsets: EdgeInsets.zero,
          menuHeight: 360,
          width: constraints.maxWidth,
          textStyle: _fieldTextStyle.copyWith(color: AppColors.textPrimary),
          menuStyle: MenuStyle(
            elevation: const WidgetStatePropertyAll(6),
            backgroundColor: const WidgetStatePropertyAll(AppColors.surface),
            shape: WidgetStatePropertyAll(menuShape),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 6),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            filled: true,
            fillColor: fill,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_radius),
              borderSide: BorderSide(color: outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_radius),
              borderSide: BorderSide(color: outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_radius),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
          leadingIcon: Icon(
            Icons.map_outlined,
            color: AppColors.primary.withValues(alpha: 0.8),
            size: 22,
          ),
          trailingIcon: Icon(
            Icons.expand_more_rounded,
            color: AppColors.primary.withValues(alpha: 0.85),
            size: 26,
          ),
          selectedTrailingIcon: Icon(
            Icons.expand_less_rounded,
            color: AppColors.primary.withValues(alpha: 0.85),
            size: 26,
          ),
          dropdownMenuEntries: [
            for (final area in venueMapAreasAlphabetical)
              DropdownMenuEntry<VenueMapArea>(
                value: area,
                label: area.label,
                style: MenuItemButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(0, 48),
                  foregroundColor: area.id == selected.id
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  textStyle: _fieldTextStyle.copyWith(
                    fontWeight: area.id == selected.id
                        ? FontWeight.w700
                        : FontWeight.w600,
                  ),
                ),
                trailingIcon: area.id == selected.id
                    ? Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: AppColors.primary.withValues(alpha: 0.9),
                      )
                    : null,
              ),
          ],
        );
      },
    );
  }
}

class _VenueMapImageFrame extends StatelessWidget {
  const _VenueMapImageFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.04),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.12),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      ),
    );
  }
}

class _VenueMapFullWidthImage extends StatelessWidget {
  const _VenueMapFullWidthImage({
    required this.assetPath,
    this.hideErrorPlaceholder = false,
  });

  final String assetPath;
  final bool hideErrorPlaceholder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final dpr = MediaQuery.devicePixelRatioOf(context);
        final cacheWidth = width.isFinite && width > 0
            ? (width * dpr).round().clamp(1, 2048)
            : null;

        return Image.asset(
          assetPath,
          width: width,
          fit: BoxFit.fitWidth,
          cacheWidth: cacheWidth,
          errorBuilder: (_, __, ___) => hideErrorPlaceholder
              ? const SizedBox.shrink()
              : const _VenueMapImageError(),
        );
      },
    );
  }
}

class _VenueMapImageError extends StatelessWidget {
  const _VenueMapImageError();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ColoredBox(
        color: AppColors.primary.withValues(alpha: 0.06),
        child: Center(
          child: Icon(
            Icons.map_outlined,
            size: 48,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _VenueStackedImages extends StatelessWidget {
  const _VenueStackedImages({
    super.key,
    required this.assetPaths,
    this.hideErrorPlaceholder = false,
  });

  final List<String> assetPaths;
  final bool hideErrorPlaceholder;

  @override
  Widget build(BuildContext context) {
    return _VenueMapImageFrame(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < assetPaths.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _VenueMapFullWidthImage(
                  assetPath: assetPaths[i],
                  hideErrorPlaceholder: hideErrorPlaceholder,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
