import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';

abstract final class SpeakersGuestAssets {
  static const cardPortrait = 'assets/images/speakers/kk_speaker.png';
  static const poster = 'assets/images/speakers/poster_speaker.png';

  /// Filename slugs for Ka-Kwentuhan (`kk_<slug>.png` → `poster_<slug>.png`).
  static const kaKwentuhanSlugs = [
    'eduardo',
    'shiela',
    'karl',
    'mishael',
    'romulo',
    'ranz',
  ];

  static String kkAssetForSlug(String slug) =>
      'assets/images/speakers/kk_$slug.png';

  static String posterAssetForSlug(String slug) =>
      'assets/images/speakers/poster_$slug.png';

  static List<String> get kaKwentuhanGrid => [
        for (final slug in kaKwentuhanSlugs) kkAssetForSlug(slug),
      ];
}

/// Ka-Kwentuhan–style poster popup: image, name, optional role, Close.
Future<void> showParticipantPosterModal(
  BuildContext context, {
  required String imageAsset,
  required String name,
  String? role,
}) {
  final roleText = role?.trim() ?? '';

  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.88),
    builder: (dialogContext) {
      final width = MediaQuery.sizeOf(dialogContext).width - 56;

      return Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: width,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ColoredBox(
                    color: AppColors.surface.withValues(alpha: 0.08),
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: AppColors.yellow.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.25,
                  ),
            ),
            if (roleText.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                roleText,
                textAlign: TextAlign.center,
                style: Theme.of(dialogContext).textTheme.titleSmall?.copyWith(
                      color: AppColors.yellow.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
              ),
            ],
            const SizedBox(height: 22),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(dialogContext).pop(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.yellow.withValues(alpha: 0.62),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showKaKwentuhanGuestPosterModal(
  BuildContext context, {
  required EventGuestParticipant participant,
  required String slug,
}) {
  return showParticipantPosterModal(
    context,
    imageAsset: SpeakersGuestAssets.posterAssetForSlug(slug),
    name: participant.name,
    role: participant.role,
  );
}

Future<void> showPlenarySpeakerModal(
  BuildContext context,
  PlenarySpeakerProfile speaker,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _PlenarySpeakerSheet(speaker: speaker),
  );
}

class _PlenarySpeakerSheet extends StatelessWidget {
  const _PlenarySpeakerSheet({required this.speaker});

  final PlenarySpeakerProfile speaker;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.65,
          color: AppColors.textPrimary,
          fontSize: 15,
        );

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  SpeakersGuestAssets.poster,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, __, ___) => AspectRatio(
                    aspectRatio: 3 / 4,
                    child: ColoredBox(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.textSecondary.withValues(alpha: 0.45),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _SpeakerCopyCard(
                child: Text(
                  speaker.copy.trim(),
                  style: bodyStyle,
                ),
              ),
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

class _SpeakerCopyCard extends StatelessWidget {
  const _SpeakerCopyCard({required this.child});

  final Widget child;

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
              Container(width: 5, color: AppColors.primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: child,
                ),
              ),
            ],
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
          color: AppColors.textSecondary.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
