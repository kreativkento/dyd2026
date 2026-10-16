import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';

Future<void> showDydHistoryModal(
  BuildContext context,
  DydHistoryContent history,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _DydHistorySheet(history: history),
  );
}

class DydHistoryView extends StatelessWidget {
  const DydHistoryView({super.key, required this.history});

  final DydHistoryContent history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HistoryHeadlineBanner(
          headline: history.headline,
          bylines: history.bylines,
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < history.sections.length; i++) ...[
          _HistorySectionBlock(section: history.sections[i]),
          if (i < history.sections.length - 1) const SizedBox(height: 22),
        ],
      ],
    );
  }
}

class _DydHistorySheet extends StatelessWidget {
  const _DydHistorySheet({required this.history});

  final DydHistoryContent history;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.96,
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.blue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.history_edu_outlined,
                      color: AppColors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      history.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: AppColors.primary,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (history.isStructured)
                DydHistoryView(history: history)
              else if (history.body.trim().isNotEmpty)
                Text(
                  history.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 14.5,
                        color: AppColors.textPrimary,
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

class _HistoryHeadlineBanner extends StatelessWidget {
  const _HistoryHeadlineBanner({
    required this.headline,
    required this.bylines,
  });

  final String headline;
  final List<String> bylines;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.blue.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          children: [
            Text(
              headline,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                    letterSpacing: 0.2,
                    color: AppColors.primary,
                  ),
            ),
            for (final line in bylines) ...[
              const SizedBox(height: 6),
              Text(
                line,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                      height: 1.25,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HistorySectionBlock extends StatelessWidget {
  const _HistorySectionBlock({required this.section});

  final DydHistorySection section;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.6,
          fontSize: 14.5,
          color: AppColors.textPrimary,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          section.heading,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
                letterSpacing: 0.3,
              ),
        ),
        const SizedBox(height: 10),
        for (final paragraph in section.paragraphs) ...[
          Text(paragraph, style: bodyStyle),
          const SizedBox(height: 10),
        ],
        for (final group in section.groups) ...[
          _HistoryGroupBlock(group: group),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _HistoryGroupBlock extends StatelessWidget {
  const _HistoryGroupBlock({required this.group});

  final DydHistoryGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          group.title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
                height: 1.35,
              ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < group.entries.length; i++) ...[
          _DydTimelineEntry(entry: group.entries[i]),
          if (i < group.entries.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _DydTimelineEntry extends StatelessWidget {
  const _DydTimelineEntry({required this.entry});

  final DydHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.55,
          fontSize: 14,
          color: AppColors.textPrimary,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: AppColors.primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                              color: AppColors.primaryDark,
                            ),
                      ),
                      for (final bullet in entry.bullets) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: bodyStyle?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(child: Text(bullet, style: bodyStyle)),
                          ],
                        ),
                      ],
                    ],
                  ),
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
