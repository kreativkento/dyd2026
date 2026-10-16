import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';
import 'shirt_carousel.dart';

/// House rules / guidelines list for the Event flow ([event.json] `guidelines`).
class EventGuidelinesView extends StatelessWidget {
  const EventGuidelinesView({super.key, required this.guidelines});

  final List<ContentSection> guidelines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < guidelines.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          if (_isDressCode(guidelines[i].title)) ...[
            const ShirtCarousel(),
            const SizedBox(height: 12),
          ],
          _GuidelineCard(section: guidelines[i]),
        ],
      ],
    );
  }
}

class _GuidelineCard extends StatelessWidget {
  const _GuidelineCard({required this.section});

  final ContentSection section;

  static const _accent = AppColors.blue;

  @override
  Widget build(BuildContext context) {
    final points = _guidelinePoints(section.body);
    final useBullets = points.length > 1;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: _accent.withValues(alpha: 0.168)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _accent.withValues(alpha: 0.11),
                  _accent.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      _guidelineIcon(section.title),
                      color: _accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      section.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                            height: 1.25,
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
            child: useBullets
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < points.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        _GuidelineBullet(text: points[i]),
                      ],
                    ],
                  )
                : Text(
                    section.body.trim(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.55,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _GuidelineBullet extends StatelessWidget {
  const _GuidelineBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
          ),
        ),
      ],
    );
  }
}

bool _isDressCode(String title) =>
    title.toLowerCase().contains('dress');

IconData _guidelineIcon(String title) {
  final t = title.toLowerCase();
  if (t.contains('dress')) return Icons.checkroom_outlined;
  if (t.contains('house') || t.contains('rule')) return Icons.rule_outlined;
  if (t.contains('safety') || t.contains('emergency')) {
    return Icons.health_and_safety_outlined;
  }
  return Icons.article_outlined;
}

List<String> _guidelinePoints(String body) {
  final trimmed = body.trim();
  if (trimmed.isEmpty) return const [];

  if (trimmed.contains('\n')) {
    return trimmed
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  final parts = trimmed
      .split(RegExp(r'\.\s+'))
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();

  if (parts.length <= 1) return [trimmed];

  return parts
      .map((part) => part.endsWith('.') ? part : '$part.')
      .toList(growable: false);
}
