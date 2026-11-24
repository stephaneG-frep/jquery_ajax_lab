import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/theme.dart';
import '../services/settings_service.dart';

/// Affiche un bloc de code avec coloration syntaxique légère,
/// un bandeau de langue et un bouton de copie.
class CodeView extends StatelessWidget {
  final String code;
  final String language;
  final bool selectable;
  final bool compact;

  const CodeView({
    super.key,
    required this.code,
    this.language = 'javascript',
    this.selectable = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CodeDarkColors.background : CodeLightColors.background;
    final border = isDark ? CodeDarkColors.border : CodeLightColors.border;
    final fg = isDark ? CodeDarkColors.text : CodeLightColors.text;

    final spans = _highlight(code, isDark);

    // La taille du code suit le réglage de l'utilisateur.
    final text = ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) => Text.rich(
        TextSpan(children: spans),
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: AppSettings.instance.codeFontSize - (compact ? 1 : 0),
          height: 1.5,
          color: fg,
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!compact)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF171820) : const Color(0xFFEDF0F5),
                border: Border(bottom: BorderSide(color: border)),
              ),
              child: Row(
                children: [
                  _dot(LabColors.coral),
                  const SizedBox(width: 6),
                  _dot(LabColors.amber),
                  const SizedBox(width: 6),
                  _dot(LabColors.terminal),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      language,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: isDark ? CodeDarkColors.comment : CodeLightColors.comment,
                      ),
                    ),
                  ),
                  if (selectable)
                    InkWell(
                      onTap: () => Clipboard.setData(ClipboardData(text: code)),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.copy,
                          size: 15,
                          color: isDark ? CodeDarkColors.comment : CodeLightColors.comment,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(compact ? 10 : 12),
            child: selectable
                ? SelectionArea(child: text)
                : text,
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  /// Coloration syntaxique légère par expressions régulières.
  List<TextSpan> _highlight(String code, bool isDark) {
    const keywords = {
      'function', 'var', 'let', 'const', 'if', 'else', 'for', 'while',
      'return', 'new', 'true', 'false', 'null', 'undefined', 'async',
      'await', 'try', 'catch', 'finally', 'throw', 'this', 'of', 'in',
      'do', 'switch', 'case', 'break', 'typeof', 'instanceof', 'class',
    };

    final keywordColor = isDark ? CodeDarkColors.keyword : CodeLightColors.keyword;
    final stringColor = isDark ? CodeDarkColors.string : CodeLightColors.string;
    final numberColor = isDark ? CodeDarkColors.number : CodeLightColors.number;
    final commentColor = isDark ? CodeDarkColors.comment : CodeLightColors.comment;
    final functionColor = isDark ? CodeDarkColors.function : CodeLightColors.function;
    final variableColor = isDark ? CodeDarkColors.variable : CodeLightColors.variable;
    final fg = isDark ? CodeDarkColors.text : CodeLightColors.text;

    final spans = <TextSpan>[];
    final buffer = StringBuffer();
    String raw = code;

    void flush() {
      if (buffer.isNotEmpty) {
        spans.add(TextSpan(text: buffer.toString(), style: TextStyle(color: fg)));
        buffer.clear();
      }
    }

    final pattern = RegExp(
      r'''("(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|`(?:[^`\\]|\\.)*`)|(//[^\n]*|/\*.*?\*/)|(\b\d+(?:\.\d+)?\b)|(\$\s*\(|\$[A-Za-z_][\w$]*)|(\.[A-Za-z_][\w$]*\s*\()|\b([A-Za-z_$][\w$]*)\b|(<[^>]*>)''',
      multiLine: true,
    );

    var lastEnd = 0;
    for (final m in pattern.allMatches(raw)) {
      if (m.start > lastEnd) {
        buffer.write(raw.substring(lastEnd, m.start));
      }
      flush();

      if (m.group(1) != null) {
        spans.add(TextSpan(text: m.group(1), style: TextStyle(color: stringColor)));
      } else if (m.group(2) != null) {
        spans.add(TextSpan(text: m.group(2), style: TextStyle(color: commentColor, fontStyle: FontStyle.italic)));
      } else if (m.group(3) != null) {
        spans.add(TextSpan(text: m.group(3), style: TextStyle(color: numberColor)));
      } else if (m.group(4) != null) {
        spans.add(TextSpan(text: m.group(4), style: TextStyle(color: variableColor, fontWeight: FontWeight.w600)));
      } else if (m.group(5) != null) {
        spans.add(TextSpan(text: m.group(5), style: TextStyle(color: functionColor, fontWeight: FontWeight.w600)));
      } else if (m.group(6) != null) {
        final word = m.group(6)!;
        if (keywords.contains(word)) {
          spans.add(TextSpan(text: word, style: TextStyle(color: keywordColor, fontWeight: FontWeight.w700)));
        } else {
          spans.add(TextSpan(text: word, style: TextStyle(color: fg)));
        }
      } else if (m.group(7) != null) {
        spans.add(TextSpan(
          text: m.group(7),
          style: TextStyle(
            color: isDark ? CodeDarkColors.keyword : const Color(0xFF005CC5),
            fontWeight: FontWeight.w600,
          ),
        ));
      }
      lastEnd = m.end;
    }
    if (lastEnd < raw.length) {
      buffer.write(raw.substring(lastEnd));
    }
    flush();
    return spans;
  }
}
