import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/content_models.dart';
import 'liturgy_rich_text.dart';

class LiturgyReadingAccordionList extends StatelessWidget {
  const LiturgyReadingAccordionList({
    super.key,
    required this.readings,
    this.initiallyExpandedIndex,
  });

  final List<LiturgyReading> readings;

  /// When set, only that reading starts expanded; otherwise all are collapsed.
  final int? initiallyExpandedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < readings.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _LiturgyReadingAccordionTile(
              reading: readings[i],
              initiallyExpanded:
                  initiallyExpandedIndex != null && i == initiallyExpandedIndex,
            ),
          ),
      ],
    );
  }
}

class _LiturgyReadingAccordionTile extends StatelessWidget {
  const _LiturgyReadingAccordionTile({
    required this.reading,
    this.initiallyExpanded = false,
  });

  final LiturgyReading reading;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          controlAffinity: ListTileControlAffinity.trailing,
          tilePadding: const EdgeInsets.fromLTRB(14, 4, 8, 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          title: Text(
            reading.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
          ),
          subtitle: reading.citation != null && reading.citation!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    reading.citation!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.5,
                        ),
                  ),
                )
              : null,
          children: [
            _LiturgyReadingBody(reading: reading),
          ],
        ),
      ),
    );
  }
}

class _LiturgyReadingBody extends StatelessWidget {
  const _LiturgyReadingBody({required this.reading});

  final LiturgyReading reading;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.55,
          color: AppColors.textPrimary,
          fontSize: 14,
        );
    final responseStyle = bodyStyle?.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
    );

    if (reading.isPsalm) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reading.response != null && reading.response!.isNotEmpty) ...[
            LiturgyRichText(
              text: reading.response!,
              baseStyle: responseStyle ?? const TextStyle(),
            ),
            const SizedBox(height: 12),
          ],
          for (var i = 0; i < reading.psalmStanzas.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _PsalmStanzaBlock(
              stanza: reading.psalmStanzas[i],
              bodyStyle: bodyStyle ?? const TextStyle(),
              responseStyle: responseStyle ?? const TextStyle(),
              fullResponse: reading.response,
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reading.response != null && reading.response!.isNotEmpty) ...[
          LiturgyRichText(
            text: reading.response!,
            baseStyle: responseStyle ?? const TextStyle(),
          ),
          const SizedBox(height: 10),
        ],
        LiturgyRichText(
          text: reading.content,
          baseStyle: bodyStyle ?? const TextStyle(),
        ),
      ],
    );
  }
}

class _PsalmStanzaBlock extends StatelessWidget {
  const _PsalmStanzaBlock({
    required this.stanza,
    required this.bodyStyle,
    required this.responseStyle,
    this.fullResponse,
  });

  final LiturgyPsalmStanza stanza;
  final TextStyle bodyStyle;
  final TextStyle responseStyle;
  final String? fullResponse;

  @override
  Widget build(BuildContext context) {
    final stanzaText = stanza.lines.join('\n');
    final refrain = stanza.response?.trim();
    String? refrainText;
    if (refrain != null && refrain.isNotEmpty) {
      if (refrain == 'R.' || refrain == 'R') {
        refrainText = fullResponse ?? 'R.';
      } else {
        refrainText = refrain;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiturgyRichText(text: stanzaText, baseStyle: bodyStyle),
        if (refrainText != null) ...[
          const SizedBox(height: 8),
          LiturgyRichText(
            text: refrainText,
            baseStyle: responseStyle,
          ),
        ],
      ],
    );
  }
}
