import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';

const hostParishPriestPhoto = 'assets/people/img_parishpriest.png';
const hostParishAssociatePastorPhoto = 'assets/people/img_assocpastor.png';
const hostParishCoordinatorPhoto = 'assets/people/img_pyc.png';
const hostParishLeaderPhoto = 'assets/people/img_pyl.png';

String? hostParishOfficialPhotoAsset(ContentSection section) {
  final fromJson = section.imageAsset?.trim();
  if (fromJson != null && fromJson.isNotEmpty) return fromJson;

  return switch (section.title) {
    "Parish Priest's Message" => hostParishPriestPhoto,
    "Associate Pastor's Message" => hostParishAssociatePastorPhoto,
    'Parish Youth Coordinator' ||
    "Parish Youth Coordinator's Message" =>
      hostParishCoordinatorPhoto,
    'Parish Youth Leader' || "Parish Youth Leader's Message" =>
      hostParishLeaderPhoto,
    _ => null,
  };
}

Future<void> showHostParishOfficialProfileModal(
  BuildContext context,
  ContentSection section,
) {
  final name = (section.subtitle != null && section.subtitle!.trim().isNotEmpty)
      ? section.subtitle!.trim()
      : section.title;
  final role = section.title;
  final photoAsset = hostParishOfficialPhotoAsset(section);

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.88),
    builder: (dialogContext) {
      final maxWidth = MediaQuery.sizeOf(dialogContext).width - 52;
      final cardWidth = maxWidth.clamp(260.0, 340.0);
      const photoHeight = 320.0;

      return Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: AppColors.surface,
              elevation: 8,
              shadowColor: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: cardWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      height: photoHeight,
                      child: photoAsset != null
                          ? Image.asset(
                              photoAsset,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, __, ___) =>
                                  _ProfilePhotoFallback(name: name),
                            )
                          : _ProfilePhotoFallback(name: name),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.06),
                            Colors.transparent,
                          ],
                        ),
                        border: Border(
                          top: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: Theme.of(dialogContext)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 19,
                                  height: 1.25,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            role,
                            textAlign: TextAlign.center,
                            style: Theme.of(dialogContext)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.3,
                                  color: AppColors.blue,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

class _ProfilePhotoFallback extends StatelessWidget {
  const _ProfilePhotoFallback({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.12),
      child: Center(
        child: Text(
          initial,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.primary.withValues(alpha: 0.55),
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}
