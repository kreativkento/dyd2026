import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';
import 'host_parish_profile_modal.dart';

Future<void> showContentSectionModal(
  BuildContext context,
  ContentSection section,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ContentSectionSheet(section: section),
  );
}

Future<void> showParishOfficialMessageModal(
  BuildContext context,
  ContentSection section,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ParishOfficialMessageSheet(section: section),
  );
}

class _ContentSectionSheet extends StatelessWidget {
  const _ContentSectionSheet({required this.section});

  final ContentSection section;

  IconData get _headerIcon {
    final title = section.title.toLowerCase();
    if (title.contains('history')) return Icons.history_edu_outlined;
    if (title.contains('mission') || title.contains('vision')) {
      return Icons.flag_outlined;
    }
    if (title.contains('objective') || title.contains('guideline')) {
      return Icons.track_changes_outlined;
    }
    return Icons.article_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.45,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + bottomInset),
            children: [
              const _SheetHandle(),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _headerIcon,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          section.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    height: 1.25,
                                    color: AppColors.primary,
                                  ),
                        ),
                        if (section.subtitle != null &&
                            section.subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            section.subtitle!,
                            style:
                                Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w600,
                                      height: 1.35,
                                    ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.08),
                  ),
                ),
                child: _ContentSectionBody(text: section.body),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContentSectionBody extends StatelessWidget {
  const _ContentSectionBody({required this.text});

  final String text;

  static bool _isSectionHeading(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.length > 48) return false;
    if (trimmed.endsWith('.')) return false;
    if (trimmed.contains('. ') && trimmed.length > 24) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final paragraphStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.55,
          fontSize: 14,
          color: AppColors.textPrimary,
        );
    final headingStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 0.15,
          color: AppColors.primary,
          height: 1.3,
        );
    final leadStyle = paragraphStyle?.copyWith(
      fontSize: 14.5,
      fontWeight: FontWeight.w500,
      height: 1.5,
    );

    final blocks = text
        .split('\n\n')
        .map((b) => b.trim())
        .where((b) => b.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          _ContentBlock(
            block: blocks[i],
            paragraphStyle: paragraphStyle ?? const TextStyle(),
            headingStyle: headingStyle ?? const TextStyle(),
            leadStyle: i == 0 ? leadStyle : null,
          ),
        ],
      ],
    );
  }
}

class _ContentBlock extends StatelessWidget {
  const _ContentBlock({
    required this.block,
    required this.paragraphStyle,
    required this.headingStyle,
    this.leadStyle,
  });

  final String block;
  final TextStyle paragraphStyle;
  final TextStyle headingStyle;
  final TextStyle? leadStyle;

  @override
  Widget build(BuildContext context) {
    final lines = block.split('\n');
    if (lines.length >= 2 &&
        _ContentSectionBody._isSectionHeading(lines.first)) {
      final body = lines.sublist(1).join('\n').trim();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lines.first.trim(), style: headingStyle),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(body, style: paragraphStyle),
          ],
        ],
      );
    }

    return Text(
      block,
      style: leadStyle ?? paragraphStyle,
    );
  }
}

class _ParishOfficialMessageSheet extends StatelessWidget {
  const _ParishOfficialMessageSheet({required this.section});

  final ContentSection section;

  String get _displayName =>
      (section.subtitle != null && section.subtitle!.trim().isNotEmpty)
          ? section.subtitle!.trim()
          : section.title;

  String get _portraitName =>
      section.signatoryName?.trim().isNotEmpty == true
          ? section.signatoryName!.trim()
          : _displayName;

  String? get _portraitAsset =>
      hostParishOfficialPhotoAsset(section) ?? section.imageAsset;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final formalLayout = section.hasSignatoryBlock;

    return DraggableScrollableSheet(
      initialChildSize: formalLayout ? 0.88 : 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.94,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20 + bottomInset),
            children: [
              const _SheetHandle(),
              const SizedBox(height: 16),
              if (formalLayout) ...[
                _MessageSheetHero(title: section.title),
                const SizedBox(height: 16),
                Center(
                  child: _OfficialPortraitFrame(
                    name: _portraitName,
                    imageAsset: _portraitAsset,
                    size: 280,
                    imageFit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 22),
              ] else ...[
                Center(
                  child: _OfficialPortraitFrame(
                    name: _displayName,
                    imageAsset: _portraitAsset,
                    size: 160,
                    imageFit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _displayName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Message',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 8),
              ],
              if (formalLayout)
                _MessageBodyCard(child: _ContentSectionBody(text: section.body))
              else
                Text(
                  section.body,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: AppColors.textPrimary,
                      ),
                ),
              if (formalLayout) ...[
                const SizedBox(height: 20),
                _MessageSignatoryBlock(section: section),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MessageSheetHero extends StatelessWidget {
  const _MessageSheetHero({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.blue.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 26,
            color: AppColors.primary.withValues(alpha: 0.55),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}

class _OfficialPortraitFrame extends StatelessWidget {
  const _OfficialPortraitFrame({
    required this.name,
    this.imageAsset,
    double? size,
    double? width,
    double? height,
    this.imageFit = BoxFit.cover,
  })  : width = width ?? size ?? 132,
        height = height ?? size ?? 132;

  final String name;
  final String? imageAsset;
  final double width;
  final double height;
  final BoxFit imageFit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.35),
            AppColors.blue.withValues(alpha: 0.25),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          color: Colors.white,
          child: _OfficialPortrait(
            name: name,
            imageAsset: imageAsset,
            fit: imageFit,
          ),
        ),
      ),
    );
  }
}

class _MessageBodyCard extends StatelessWidget {
  const _MessageBodyCard({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                color: AppColors.primary,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageSignatoryBlock extends StatelessWidget {
  const _MessageSignatoryBlock({required this.section});

  final ContentSection section;

  @override
  Widget build(BuildContext context) {
    final name = section.signatoryName?.trim();
    final role = section.signatoryRole?.trim();
    final affiliation = section.signatoryAffiliation?.trim();

    return Column(
      children: [
        Divider(
          color: AppColors.textSecondary.withValues(alpha: 0.25),
        ),
        const SizedBox(height: 16),
        if (name != null && name.isNotEmpty)
          Text(
            name.toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: AppColors.primary,
                  height: 1.35,
                ),
          ),
        if (role != null && role.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            role,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.blue,
                ),
          ),
        ],
        if (affiliation != null && affiliation.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            affiliation,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          ),
        ],
      ],
    );
  }
}

class _OfficialPortrait extends StatelessWidget {
  const _OfficialPortrait({
    required this.name,
    this.imageAsset,
    this.fit = BoxFit.cover,
  });

  final String name;
  final String? imageAsset;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageAsset != null && imageAsset!.isNotEmpty) {
      return Image.asset(
        imageAsset!,
        fit: fit,
        errorBuilder: (_, __, ___) => _InitialsPlaceholder(name: name),
      );
    }
    return _InitialsPlaceholder(name: name);
  }
}

class _InitialsPlaceholder extends StatelessWidget {
  const _InitialsPlaceholder({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.85),
            AppColors.blue.withValues(alpha: 0.75),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
