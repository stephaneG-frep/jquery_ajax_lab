/// Fiche de référence (docs / aide-mémoire) et snippets.
library;
import 'package:flutter/widgets.dart';

class Snippet {
  final String id;
  final String name;
  final String description;
  final String syntax;
  final String example;
  final String category;
  final IconData icon;

  const Snippet({
    required this.id,
    required this.name,
    required this.description,
    required this.syntax,
    required this.example,
    required this.category,
    required this.icon,
  });
}

class GlossaryEntry {
  final String term;
  final String definition;
  final String? example;

  const GlossaryEntry({
    required this.term,
    required this.definition,
    this.example,
  });
}

/// Objets utilisés pour la fonction « Explique-moi ce code ».
class CodeLineExplanation {
  final String line;
  final String explanation;

  const CodeLineExplanation({required this.line, required this.explanation});
}

class ExplainableCode {
  final String id;
  final String title;
  final String code;
  final List<CodeLineExplanation> lines;

  const ExplainableCode({
    required this.id,
    required this.title,
    required this.code,
    required this.lines,
  });
}
