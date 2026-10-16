import 'package:flutter/material.dart';

/// Renders plain text with segments inside `"..."` shown in italics.
class LiturgyRichText extends StatelessWidget {
  const LiturgyRichText({
    super.key,
    required this.text,
    required this.baseStyle,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle baseStyle;
  final TextAlign textAlign;

  static List<InlineSpan> spansForText(String text, TextStyle baseStyle) {
    if (text.isEmpty) return [TextSpan(text: '', style: baseStyle)];

    final italicStyle = baseStyle.merge(
      const TextStyle(fontStyle: FontStyle.italic),
    );
    final spans = <InlineSpan>[];
    final pattern = RegExp('"([^"]*)"');
    var index = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > index) {
        spans.add(
          TextSpan(
            text: text.substring(index, match.start),
            style: baseStyle,
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: italicStyle,
        ),
      );
      index = match.end;
    }

    if (index < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(index),
          style: baseStyle,
        ),
      );
    }

    return spans.isEmpty ? [TextSpan(text: text, style: baseStyle)] : spans;
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: spansForText(text, baseStyle)),
      textAlign: textAlign,
    );
  }
}
