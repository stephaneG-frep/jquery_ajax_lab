/// Exercices pédagogiques avec niveaux, indices, solutions et validation.
library;

import '../utils/js_text.dart';

enum ExerciseLevel {
  guided('GUIDÉ', 'Instructions détaillées, étape par étape.'),
  semiGuided('SEMI-GUIDÉ', 'Objectif clair, quelques indications seulement.'),
  autonomous('AUTONOME', 'Uniquement l\'objectif, à vous de jouer !');

  const ExerciseLevel(this.label, this.description);
  final String label;
  final String description;
}

enum ExerciseType {
  code,
  choice,
}

/// Règle de validation automatique d'un exercice de type code.
///
/// Les motifs sont des expressions régulières appliquées à la forme canonique
/// de la réponse ([JsText.canonical]) : sans commentaires, guillemets simples,
/// sans espaces autour de la ponctuation. Raccourcis disponibles :
/// - `<jq>` : `$` ou `jQuery` ;
/// - `<fn>` : début d'une fonction anonyme ou fléchée ;
/// - `<cb>` : `<fn>` ou le nom d'une fonction.
class ValidationRule {
  /// Tous ces motifs doivent être trouvés.
  final List<String> patterns;

  /// Aucun de ces motifs ne doit être trouvé.
  final List<String> forbidden;

  /// Message pédagogique si la réponse est incorrecte.
  final String feedback;

  const ValidationRule({
    required this.patterns,
    this.forbidden = const [],
    this.feedback = 'Votre réponse est proche, mais il manque un élément essentiel.',
  });

  static const String _fn =
      r'(?:async ?)?(?:function ?\w*\([^)]*\)|(?:\([\w$,]*\)|[\w$]+)=>)';

  static RegExp _compile(String pattern) => RegExp(
        pattern
            .replaceAll('<cb>', '(?:<fn>|[A-Za-z_]\\w*\\))')
            .replaceAll('<fn>', _fn)
            .replaceAll('<jq>', r'(?<![\w$.])(?:\$|jQuery)'),
        dotAll: true,
      );

  /// Vérifie un code déjà mis sous forme canonique.
  bool accepts(String canonicalCode) =>
      patterns.every((p) => _compile(p).hasMatch(canonicalCode)) &&
      !forbidden.any((p) => _compile(p).hasMatch(canonicalCode));
}

class Exercise {
  final String id;
  final String title;
  final String moduleId;
  final String category;
  final ExerciseLevel level;
  final ExerciseType type;

  /// Énoncé / contexte.
  final String objective;

  /// Instructions détaillées (niveau guidé) ou indications brèves.
  final String instructions;

  /// Indices progressifs (indice 1, indice 2, …).
  final List<String> hints;

  /// Solution complète (code ou réponse).
  final String solution;

  /// Explication pédagogique de la solution.
  final String solutionExplanation;

  /// Réponses possibles (exercice à choix multiple).
  final List<String>? choices;

  /// Index de la bonne réponse pour les exercices à choix multiple.
  final int? correctChoiceIndex;

  /// Règle de validation pour les exercices de code.
  final ValidationRule? rule;

  const Exercise({
    required this.id,
    required this.title,
    required this.moduleId,
    required this.category,
    required this.level,
    required this.type,
    required this.objective,
    required this.instructions,
    required this.hints,
    required this.solution,
    required this.solutionExplanation,
    this.choices,
    this.correctChoiceIndex,
    this.rule,
  });

  /// Vérifie la structure d'une réponse libre (le code n'est pas exécuté).
  /// Retourne (valide, message pédagogique).
  ({bool valid, String? feedback}) validate(String answer) {
    if (!JsText.isBalanced(answer)) {
      return (
        valid: false,
        feedback: 'Votre code contient une erreur de syntaxe : vérifiez que chaque '
            'parenthèse, accolade et guillemet ouvert est bien fermé.',
      );
    }

    final code = JsText.canonical(answer);
    final r = rule;
    if (r == null) {
      // Aucune règle : on compare simplement à la solution.
      final ok = code == JsText.canonical(solution);
      return (valid: ok, feedback: ok ? null : 'Comparez votre réponse avec la solution proposée.');
    }
    return r.accepts(code)
        ? (valid: true, feedback: null)
        : (valid: false, feedback: r.feedback);
  }

  /// Vérifie la réponse d'un exercice à choix multiple.
  ({bool valid, String? feedback}) validateChoice(int selectedIndex) {
    if (correctChoiceIndex == null) return (valid: false, feedback: 'Aucune réponse attendue.');
    if (selectedIndex == correctChoiceIndex) {
      return (valid: true, feedback: solutionExplanation);
    }
    final chosen = (choices != null && selectedIndex >= 0 && selectedIndex < choices!.length)
        ? choices![selectedIndex]
        : '';
    return (
      valid: false,
      feedback: 'Ce n\'est pas tout à fait cela. Vous avez choisi : "$chosen". '
          'Relisez l\'énoncé, aidez-vous des indices, puis réessayez.',
    );
  }
}
