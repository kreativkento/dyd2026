import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

enum MenuCardVariant {
  standard,
  featured,
  prominent,
  grid,
  compactGrid,
  half,
  halfCompact,
  halfCompactRow,
  eventTile,
  eventTileCompact,
  directoryCompact,
}

bool _isBrandYellow(Color color) =>
    color.toARGB32() == AppColors.yellow.toARGB32();

Color _brandAccentGlyph(Color baseColor) =>
    _isBrandYellow(baseColor) ? AppColors.primaryDark : baseColor;

Color _brandAccentBadgeFill(Color baseColor) => _isBrandYellow(baseColor)
    ? AppColors.yellow.withValues(alpha: 0.42)
    : baseColor.withValues(alpha: 0.12);

/// Layout for full-width prominent cards on the Event tab.
abstract final class _ProminentMenuCard {
  static const badgeSize = 38.0;
  static const glyphSize = 18.0;
  static const horizontalPadding = 14.0;
  static const verticalPadding = 12.0;
  static const titleFontSize = 14.0;
  /// Stronger card outline; background tint stays in [_ProminentContent].
  static const borderAlpha = 0.42;
}

/// Icon badge metrics for Event tab [MenuCard] variants (tile, prominent, compact).
abstract final class _EventMenuCardIcon {
  static const badgeSize = 44.0;
  static const glyphSize = 20.0;
  static const horizontalPadding = 14.0;
  static const _defaultOutlineAlpha = 0.14;
  static const outlineAlpha = _defaultOutlineAlpha * 1.2;
}

class MenuCard extends StatefulWidget {
  const MenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.imageAsset,
    this.color,
    this.variant = MenuCardVariant.standard,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? imageAsset;
  final VoidCallback onTap;
  final Color? color;
  final MenuCardVariant variant;

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? AppColors.primary;
    final accent = _hovering ? AppColors.blue : baseColor;
    final outlineAlpha = switch (widget.variant) {
      MenuCardVariant.eventTile ||
      MenuCardVariant.eventTileCompact =>
        _EventMenuCardIcon.outlineAlpha,
      MenuCardVariant.prominent => _ProminentMenuCard.borderAlpha,
      _ => 0.14,
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        elevation: widget.variant == MenuCardVariant.standard ? null : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: _isBrandYellow(baseColor)
                ? Color.lerp(
                      AppColors.yellow.withValues(alpha: outlineAlpha),
                      AppColors.textSecondary.withValues(alpha: 0.55),
                      0.5,
                    )!
                : baseColor.withValues(alpha: outlineAlpha),
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          hoverColor: AppColors.blue.withValues(alpha: 0.08),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          child: switch (widget.variant) {
            MenuCardVariant.featured => _FeaturedContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
              ),
            MenuCardVariant.prominent => _ProminentContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                imageAsset: widget.imageAsset,
                cardColor: accent,
                hovering: _hovering,
              ),
            MenuCardVariant.grid => _GridContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
                hovering: _hovering,
              ),
            MenuCardVariant.compactGrid => _CompactGridContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
                hovering: _hovering,
              ),
            MenuCardVariant.half => _HalfContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
                hovering: _hovering,
              ),
            MenuCardVariant.halfCompact => _HalfCompactContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
                hovering: _hovering,
              ),
            MenuCardVariant.halfCompactRow => _HalfCompactRowContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
                hovering: _hovering,
              ),
            MenuCardVariant.eventTile => _EventTileContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
                hovering: _hovering,
                compact: false,
              ),
            MenuCardVariant.eventTileCompact => _EventTileContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
                hovering: _hovering,
                compact: true,
              ),
            MenuCardVariant.standard => _StandardContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                imageAsset: widget.imageAsset,
                cardColor: accent,
                hovering: _hovering,
              ),
            MenuCardVariant.directoryCompact => _DirectoryCompactContent(
                title: widget.title,
                subtitle: widget.subtitle,
                icon: widget.icon,
                cardColor: accent,
                hovering: _hovering,
              ),
          },
        ),
      ),
    );
  }
}

class _StandardContent extends StatelessWidget {
  const _StandardContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.imageAsset,
    required this.cardColor,
    required this.hovering,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? imageAsset;
  final Color cardColor;
  final bool hovering;

  @override
  Widget build(BuildContext context) {
    final showSubtitle = subtitle.trim().isNotEmpty;
    final photo = imageAsset?.trim();

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (photo != null && photo.isNotEmpty)
            _PhotoBadge(
              assetPath: photo,
              cardColor: cardColor,
              size: 52,
              fallbackIcon: icon,
            )
          else
            _IconBadge(icon: icon, cardColor: cardColor, size: 52, iconSize: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: hovering ? AppColors.blue : null,
                      ),
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: cardColor.withValues(alpha: 0.6)),
        ],
      ),
    );
  }
}

class _DirectoryCompactContent extends StatelessWidget {
  const _DirectoryCompactContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.hovering,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final bool hovering;

  @override
  Widget build(BuildContext context) {
    final showSubtitle = subtitle.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IconBadge(icon: icon, cardColor: cardColor, size: 40, iconSize: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        height: 1.22,
                        color: hovering ? AppColors.blue : AppColors.textPrimary,
                      ),
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.2,
                        ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: cardColor.withValues(alpha: hovering ? 0.75 : 0.45),
          ),
        ],
      ),
    );
  }
}

class _FeaturedContent extends StatelessWidget {
  const _FeaturedContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardColor.withValues(alpha: 0.14),
            cardColor.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Row(
        children: [
          _IconBadge(icon: icon, cardColor: cardColor, size: 72, iconSize: 36),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: cardColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: cardColor.withValues(alpha: 0.7), size: 28),
        ],
      ),
    );
  }
}

class _ProminentContent extends StatelessWidget {
  const _ProminentContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.imageAsset,
    required this.cardColor,
    required this.hovering,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? imageAsset;
  final Color cardColor;
  final bool hovering;

  @override
  Widget build(BuildContext context) {
    final photo = imageAsset?.trim();
    final badgeSize = _ProminentMenuCard.badgeSize;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            cardColor.withValues(alpha: 0.1),
            cardColor.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _ProminentMenuCard.horizontalPadding,
          vertical: _ProminentMenuCard.verticalPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (photo != null && photo.isNotEmpty)
              _PhotoBadge(
                assetPath: photo,
                cardColor: cardColor,
                size: badgeSize,
                fallbackIcon: icon,
              )
            else
              _IconBadge(
                icon: icon,
                cardColor: cardColor,
                size: badgeSize,
                iconSize: _ProminentMenuCard.glyphSize,
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          fontSize: _ProminentMenuCard.titleFontSize,
                          color: hovering ? AppColors.blue : AppColors.textPrimary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.2,
                            fontSize: 11.5,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: cardColor.withValues(alpha: hovering ? 0.85 : 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridContent extends StatelessWidget {
  const _GridContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.hovering,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final bool hovering;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IconBadge(icon: icon, cardColor: cardColor, size: 36, iconSize: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        color: hovering ? AppColors.blue : null,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.2,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactGridContent extends StatelessWidget {
  const _CompactGridContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.hovering,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final bool hovering;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IconBadge(icon: icon, cardColor: cardColor, size: 36, iconSize: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        color: hovering ? AppColors.blue : null,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.2,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HalfContent extends StatelessWidget {
  const _HalfContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.hovering,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final bool hovering;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon, cardColor: cardColor, size: 52, iconSize: 26),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: hovering ? AppColors.blue : null,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _EventTileContent extends StatelessWidget {
  const _EventTileContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.hovering,
    required this.compact,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final bool hovering;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final verticalPadding = compact ? 14.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _EventMenuCardIcon.horizontalPadding,
        verticalPadding,
        _EventMenuCardIcon.horizontalPadding,
        verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: icon,
                cardColor: cardColor,
                size: _EventMenuCardIcon.badgeSize,
                iconSize: _EventMenuCardIcon.glyphSize,
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: _isBrandYellow(cardColor) && !hovering
                    ? AppColors.primaryDark.withValues(alpha: 0.55)
                    : cardColor.withValues(alpha: hovering ? 0.85 : 0.45),
              ),
            ],
          ),
          SizedBox(height: compact ? 10 : 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  fontSize: compact
                      ? _ProminentMenuCard.titleFontSize
                      : 14.5,
                  color: hovering ? AppColors.blue : AppColors.textPrimary,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.25,
                    fontSize: compact ? 11.5 : 12,
                  ),
              maxLines: compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact half-width card: icon left, title (and optional subtitle) on the right.
class _HalfCompactRowContent extends StatelessWidget {
  const _HalfCompactRowContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.hovering,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final bool hovering;

  static const _iconSize = 32.0;
  static const _glyphSize = 16.0;

  @override
  Widget build(BuildContext context) {
    final showSubtitle = subtitle.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IconBadge(
            icon: icon,
            cardColor: cardColor,
            size: _iconSize,
            iconSize: _glyphSize,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        fontSize: 12.5,
                        color: hovering ? AppColors.blue : AppColors.textPrimary,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                          height: 1.2,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HalfCompactContent extends StatelessWidget {
  const _HalfCompactContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    required this.hovering,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final bool hovering;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon, cardColor: cardColor, size: 36, iconSize: 18),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  fontSize: 13.5,
                  color: hovering ? AppColors.blue : null,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.2,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.cardColor,
    required this.size,
    required this.iconSize,
    this.backgroundColor,
  });

  final IconData icon;
  final Color cardColor;
  final double size;
  final double iconSize;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? _brandAccentBadgeFill(cardColor),
        borderRadius: BorderRadius.circular(size * 0.27),
        border: backgroundColor != null
            ? Border.all(
                color: cardColor.withValues(alpha: 0.35),
                width: 1,
              )
            : null,
      ),
      child: Icon(
        icon,
        color: _brandAccentGlyph(cardColor),
        size: iconSize,
      ),
    );
  }
}

class _PhotoBadge extends StatelessWidget {
  const _PhotoBadge({
    required this.assetPath,
    required this.cardColor,
    required this.size,
    required this.fallbackIcon,
  });

  final String assetPath;
  final Color cardColor;
  final double size;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.27);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: cardColor.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: ColoredBox(
          color: Colors.white,
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => ColoredBox(
              color: _brandAccentBadgeFill(cardColor),
              child: Icon(
                fallbackIcon,
                color: _brandAccentGlyph(cardColor),
                size: size * 0.54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
