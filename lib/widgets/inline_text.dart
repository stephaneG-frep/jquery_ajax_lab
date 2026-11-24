import 'package:flutter/material.dart';

/// Texte avec mise en forme légère : `**gras**` et `*italique*`.
class InlineText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const InlineText(this.text, {super.key, this.style});

  // Gras, ou italique délimité par des * isolés (« 2 * 3 » et « data-* » sont
  // laissés tels quels).
  static final RegExp _marks = RegExp(
    r'\*\*(.+?)\*\*(?!\*)|(?<![\w*-])\*([^\s*](?:[^*]*[^\s*])?)\*(?![\w*])',
  );

  static List<TextSpan> spans(String text) {
    final result = <TextSpan>[];
    var last = 0;
    for (final m in _marks.allMatches(text)) {
      if (m.start > last) result.add(TextSpan(text: text.substring(last, m.start)));
      result.add(m[1] != null
          ? TextSpan(text: m[1], style: const TextStyle(fontWeight: FontWeight.w700))
          : TextSpan(text: m[2], style: const TextStyle(fontStyle: FontStyle.italic)));
      last = m.end;
    }
    if (last < text.length) result.add(TextSpan(text: text.substring(last)));
    return result;
  }

  @override
  Widget build(BuildContext context) =>
      Text.rich(TextSpan(children: spans(text)), style: style);
}
