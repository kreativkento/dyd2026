import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';

class ThemeSongView extends StatelessWidget {
  const ThemeSongView({super.key, required this.song});

  final ThemeSongContent song;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TaglineBanner(text: song.tagline),
        const SizedBox(height: 20),
        for (var i = 0; i < song.sections.length; i++) ...[
          _ThemeSongSectionBlock(section: song.sections[i]),
          if (i < song.sections.length - 1) const SizedBox(height: 18),
        ],
      ],
    );
  }
}

class _TaglineBanner extends StatelessWidget {
  const _TaglineBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.yellow.withValues(alpha: 0.18),
          ],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.35,
                letterSpacing: 0.2,
                color: AppColors.primary,
              ),
        ),
      ),
    );
  }
}

class _ThemeSongSectionBlock extends StatelessWidget {
  const _ThemeSongSectionBlock({required this.section});

  final ThemeSongSection section;

  @override
  Widget build(BuildContext context) {
    switch (section.kind) {
      case ThemeSongSectionKind.note:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            section.label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.textSecondary,
                ),
          ),
        );
      case ThemeSongSectionKind.finale:
        return _FinaleBlock(label: section.label, lines: section.lines);
      case ThemeSongSectionKind.chorus:
        return _ChorusBlock(label: section.label, lines: section.lines);
      case ThemeSongSectionKind.verse:
        return _VerseBlock(label: section.label, lines: section.lines);
    }
  }
}

class _VerseBlock extends StatelessWidget {
  const _VerseBlock({required this.label, required this.lines});

  final String label;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.55,
          fontSize: 15,
          color: AppColors.textPrimary,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.trim().isNotEmpty)
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                ),
          ),
        if (label.trim().isNotEmpty && lines.isNotEmpty)
          const SizedBox(height: 8),
        for (final line in lines)
          if (line.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(line, style: bodyStyle),
            ),
      ],
    );
  }
}

class _ChorusBlock extends StatelessWidget {
  const _ChorusBlock({required this.label, required this.lines});

  final String label;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final lineStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.5,
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 12),
            for (final line in lines)
              if (line.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    line,
                    textAlign: TextAlign.center,
                    style: lineStyle,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _FinaleBlock extends StatelessWidget {
  const _FinaleBlock({required this.label, required this.lines});

  final String label;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.5,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final line in lines)
          if (line.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(line, textAlign: TextAlign.center, style: bodyStyle),
            ),
        if (lines.isNotEmpty) const SizedBox(height: 8),
        if (label.trim().isNotEmpty)
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  height: 1.3,
                  color: AppColors.primary,
                ),
          ),
      ],
    );
  }
}
