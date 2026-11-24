import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

/// Progression locale de l'apprenant : sections terminées, exercices réussis,
/// scores de quiz, projets terminés, position actuelle.
class ProgressService extends ChangeNotifier {
  ProgressService._();

  static final ProgressService instance = ProgressService._();

  final Set<String> _completedSections = {};
  final Set<String> _passedExercises = {};
  final Set<String> _completedProjects = {};
  final Map<String, int> _quizScores = {};

  String? _currentSectionId;
  String? _currentExerciseId;
  String? _currentProjectId;
  bool _loaded = false;

  Set<String> get completedSections => Set.unmodifiable(_completedSections);
  Set<String> get passedExercises => Set.unmodifiable(_passedExercises);
  Set<String> get completedProjects => Set.unmodifiable(_completedProjects);
  String? get currentSectionId => _currentSectionId;
  String? get currentExerciseId => _currentExerciseId;
  String? get currentProjectId => _currentProjectId;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(StorageKeys.progressJson);
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _completedSections
          ..clear()
          ..addAll((map['sections'] as List<dynamic>? ?? const []).cast<String>());
        _passedExercises
          ..clear()
          ..addAll((map['exercises'] as List<dynamic>? ?? const []).cast<String>());
        _completedProjects
          ..clear()
          ..addAll((map['projects'] as List<dynamic>? ?? const []).cast<String>());
        _quizScores
          ..clear()
          ..addAll((map['quizzes'] as Map<String, dynamic>? ?? const {}).cast<String, int>());
        _currentSectionId = map['currentSection'] as String?;
        _currentExerciseId = map['currentExercise'] as String?;
        _currentProjectId = map['currentProject'] as String?;
      }
      _loaded = true;
      notifyListeners();
    } catch (_) {
      _loaded = true;
    }
  }

  Future<void> markSectionComplete(String sectionId) async {
    if (_completedSections.add(sectionId)) {
      _currentSectionId = sectionId;
      notifyListeners();
      await _save();
    }
  }

  Future<void> markExercisePassed(String exerciseId) async {
    if (_passedExercises.add(exerciseId)) {
      _currentExerciseId = exerciseId;
      notifyListeners();
      await _save();
    }
  }

  Future<void> markProjectComplete(String projectId) async {
    if (_completedProjects.add(projectId)) {
      _currentProjectId = projectId;
      notifyListeners();
      await _save();
    }
  }

  /// Meilleur score obtenu au quiz d'un module, ou null s'il n'a pas été fait.
  int? bestQuizScore(String moduleId) => _quizScores[moduleId];

  /// Enregistre un score de quiz ; seul le meilleur est conservé.
  Future<void> recordQuizScore(String moduleId, int score) async {
    if (score <= (_quizScores[moduleId] ?? -1)) return;
    _quizScores[moduleId] = score;
    notifyListeners();
    await _save();
  }

  Future<void> setCurrentSection(String sectionId) async {
    _currentSectionId = sectionId;
    notifyListeners();
    await _save();
  }

  bool isSectionComplete(String id) => _completedSections.contains(id);
  bool isExercisePassed(String id) => _passedExercises.contains(id);
  bool isProjectComplete(String id) => _completedProjects.contains(id);

  /// Réinitialise toute la progression (après confirmation).
  Future<void> reset() async {
    _completedSections.clear();
    _passedExercises.clear();
    _completedProjects.clear();
    _quizScores.clear();
    _currentSectionId = null;
    _currentExerciseId = null;
    _currentProjectId = null;
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        StorageKeys.progressJson,
        jsonEncode({
          'sections': _completedSections.toList(),
          'exercises': _passedExercises.toList(),
          'projects': _completedProjects.toList(),
          'quizzes': _quizScores,
          'currentSection': _currentSectionId,
          'currentExercise': _currentExerciseId,
          'currentProject': _currentProjectId,
        }),
      );
    } catch (_) {
      // Stockage indisponible (tests) : on ignore.
    }
  }
}
