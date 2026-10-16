import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';

/// Hotlines from [assets/data/emergency.json].
class EmergencyContactsList extends StatelessWidget {
  const EmergencyContactsList({
    super.key,
    required this.contacts,
    this.compact = false,
  });

  final List<EmergencyContact> contacts;

  /// Tighter, calmer layout for the quick-access bottom sheet.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < contacts.length; i++) ...[
          if (contacts[i].section != null &&
              contacts[i].section!.trim().isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(
                top: i == 0 ? (compact ? 4 : 0) : (compact ? 20 : 10),
                bottom: compact ? 10 : 8,
              ),
              child: Text(
                contacts[i].section!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 12 : 12,
                      letterSpacing: 0.2,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
              ),
            ),
          ],
          _EmergencyContactTile(
            contact: contacts[i],
            compact: compact,
            isLast: i == contacts.length - 1,
          ),
        ],
      ],
    );
  }
}

class _EmergencyContactTile extends StatelessWidget {
  const _EmergencyContactTile({
    required this.contact,
    required this.compact,
    this.isLast = false,
  });

  final EmergencyContact contact;
  final bool compact;
  final bool isLast;

  /// Supports `\n` and ` / ` in [emergency.json] `number` fields.
  static List<String> numberLines(String number) {
    final raw = number.trim();
    if (raw.isEmpty) return const [];

    final parts = <String>[];
    for (final segment in raw.split('\n')) {
      final piece = segment.trim();
      if (piece.isEmpty) continue;
      if (piece.contains(' / ')) {
        parts.addAll(
          piece.split(' / ').map((s) => s.trim()).where((s) => s.isNotEmpty),
        );
      } else {
        parts.add(piece);
      }
    }
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    final lines = numberLines(contact.number);
    final nameStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: compact ? 14.5 : 14,
          height: 1.3,
          color: AppColors.emergency,
        );
    final numberStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: compact ? 13 : 13.5,
          height: 1.4,
          color: AppColors.textPrimary.withValues(alpha: 0.88),
        );
    final noteStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          height: 1.35,
          fontSize: 12,
        );

    if (compact) {
      return Padding(
        padding: EdgeInsets.only(bottom: isLast ? 4 : 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: AppColors.textSecondary.withValues(alpha: 0.12),
                    ),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 12, 2, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: nameStyle),
                if (lines.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  for (var i = 0; i < lines.length; i++)
                    Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 5),
                      child: Text(lines[i], style: numberStyle),
                    ),
                ],
                if (contact.notes != null &&
                    contact.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(contact.notes!, style: noteStyle),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contact.name, style: nameStyle),
          if (lines.isNotEmpty) ...[
            const SizedBox(height: 6),
            for (var i = 0; i < lines.length; i++)
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 2),
                child: Text(lines[i], style: numberStyle),
              ),
          ],
          if (contact.notes != null && contact.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(contact.notes!, style: noteStyle),
          ],
        ],
      ),
    );
  }
}
