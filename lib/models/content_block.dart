/// Blocs de contenu pédagogique rendus dans les cours et projets.
library;
import 'package:flutter/material.dart';

sealed class ContentBlock {
  const ContentBlock();
}

/// Paragraphe de texte (**gras** et *italique*).
class ParagraphBlock extends ContentBlock {
  final String text;
  const ParagraphBlock(this.text);
}

/// Titre de niveau 2 à l'intérieur d'une leçon.
class HeadingBlock extends ContentBlock {
  final String text;
  const HeadingBlock(this.text);
}

/// Bloc de code avec langage, code brut et explication optionnelle ligne par ligne.
class CodeBlock extends ContentBlock {
  final String language;
  final String code;
  final String? explanation;
  final bool lineByLine;

  const CodeBlock(
    this.code, {
    this.language = 'javascript',
    this.explanation,
    this.lineByLine = false,
  });
}

/// Astuce (encadré vert).
class TipBlock extends ContentBlock {
  final String text;
  const TipBlock(this.text);
}

/// Attention / piège (encadré orange).
class WarningBlock extends ContentBlock {
  final String text;
  const WarningBlock(this.text);
}

/// Information complémentaire (encadré bleu).
class InfoBlock extends ContentBlock {
  final String text;
  const InfoBlock(this.text);
}

/// Tableau de référence.
class TableBlock extends ContentBlock {
  final List<String> headers;
  final List<List<String>> rows;
  const TableBlock({required this.headers, required this.rows});
}

/// Comparaison jQuery / JavaScript moderne.
class ComparisonBlock extends ContentBlock {
  final String title;
  final String jquery;
  final String modern;
  final String? note;
  const ComparisonBlock({
    required this.title,
    required this.jquery,
    required this.modern,
    this.note,
  });
}

/// Étape d'un enchaînement (requête / réponse), rendu sous forme de flux vertical.
class StepsBlock extends ContentBlock {
  final List<String> steps;
  final String? title;
  const StepsBlock({required this.steps, this.title});
}

/// Liste à puces.
class BulletsBlock extends ContentBlock {
  final List<String> items;
  const BulletsBlock(this.items);
}

/// Liste numérotée.
class NumbersBlock extends ContentBlock {
  final List<String> items;
  const NumbersBlock(this.items);
}

/// Lien interne vers un exercice.
class ExerciseLinkBlock extends ContentBlock {
  final String exerciseId;
  const ExerciseLinkBlock(this.exerciseId);
}

/// Icône + titre + texte, pour introduire une notion.
class ConceptCardBlock extends ContentBlock {
  final IconData icon;
  final String title;
  final String text;
  const ConceptCardBlock({required this.icon, required this.title, required this.text});
}
