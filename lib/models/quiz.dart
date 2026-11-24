/// Question de quiz à choix unique.
class QuizQuestion {
  final String question;

  /// Extrait de code affiché sous la question.
  final String? code;

  final List<String> choices;
  final int correctIndex;

  /// Affichée après chaque réponse, juste ou fausse.
  final String explanation;

  const QuizQuestion(
    this.question,
    this.choices,
    this.correctIndex,
    this.explanation, {
    this.code,
  });
}

/// Quiz de fin de module.
class Quiz {
  final String moduleId;
  final List<QuizQuestion> questions;

  const Quiz({required this.moduleId, required this.questions});

  /// Nombre de bonnes réponses nécessaires pour réussir (80 %).
  int get passMark => (questions.length * 0.8).ceil();
}
