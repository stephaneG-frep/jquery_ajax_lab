import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jquery_ajax_lab/core/constants.dart';
import 'package:jquery_ajax_lab/data/app_data.dart';
import 'package:jquery_ajax_lab/models/exercise.dart';
import 'package:jquery_ajax_lab/services/favorites_service.dart';
import 'package:jquery_ajax_lab/services/lab_engine.dart';
import 'package:jquery_ajax_lab/services/progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FavoritesService.instance.reset();
    ProgressService.instance.reset();
  });

  group('Données', () {
    test('les modules, sections, exercices et projets existent', () {
      expect(AppData.modules, isNotEmpty);
      expect(AppData.allSections.length, greaterThan(20));
      expect(AppData.exercises.length, greaterThanOrEqualTo(10));
      expect(AppData.projects.length, greaterThanOrEqualTo(10));
      expect(AppData.snippets.length, greaterThan(20));
      expect(AppData.glossary, isNotEmpty);
    });

    test('chaque section appartient à un module existant', () {
      for (final s in AppData.allSections) {
        expect(AppData.moduleById(s.moduleId), isNotNull, reason: 'module de ${s.id}');
      }
    });

    test('la recherche globale retourne des résultats', () {
      final results = AppData.search('ajax');
      expect(results, isNotEmpty);
    });

    test('aucun id n\'est dupliqué', () {
      final ids = AppData.allSections.map((s) => s.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  group('Exercices', () {
    test('la solution proposée valide les exercices de code', () {
      final codeExercises =
          AppData.exercises.where((e) => e.type == ExerciseType.code).toList();
      expect(codeExercises, isNotEmpty);
      var checked = 0;
      for (final ex in codeExercises) {
        if (ex.rule == null) continue;
        final result = ex.validate(ex.solution);
        expect(result.valid, isTrue,
            reason: 'solution invalide pour ${ex.id} : ${result.feedback}');
        checked++;
      }
      expect(checked, greaterThan(0));
    });

    test('les exercices à choix multiple ont une bonne réponse', () {
      final choiceExercises =
          AppData.exercises.where((e) => e.type == ExerciseType.choice).toList();
      expect(choiceExercises, isNotEmpty);
      for (final ex in choiceExercises) {
        expect(ex.correctChoiceIndex, isNotNull, reason: ex.id);
        expect(ex.choices, isNotNull);
        expect(ex.correctChoiceIndex, lessThan(ex.choices!.length), reason: ex.id);
      }
    });

    test('une mauvaise réponse échoue avec un retour pédagogique', () {
      final ex = AppData.exercises.firstWhere(
        (e) => e.type == ExerciseType.choice,
      );
      final wrong = ex.correctChoiceIndex == 0 ? 1 : 0;
      final result = ex.validateChoice(wrong);
      expect(result.valid, isFalse);
      expect(result.feedback, isNotNull);
    });
  });

  group('Progression', () {
    test('marque une section terminée puis la réinitialise', () async {
      final p = ProgressService.instance;
      await p.markSectionComplete('sec-base-1');
      expect(p.isSectionComplete('sec-base-1'), isTrue);
      expect(p.completedSections, contains('sec-base-1'));
      await p.reset();
      expect(p.completedSections, isEmpty);
    });

    test('la progression est persistée', () async {
      final p = ProgressService.instance;
      await p.markExercisePassed('ex-jquery-1');
      await p.markSectionComplete('jquery-4-1');
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(StorageKeys.progressJson)!;

      // Comme au prochain lancement : mémoire vidée, stockage conservé.
      await p.reset();
      expect(p.isExercisePassed('ex-jquery-1'), isFalse);
      await prefs.setString(StorageKeys.progressJson, saved);
      await p.load();
      expect(p.isExercisePassed('ex-jquery-1'), isTrue);
      expect(p.currentSectionId, 'jquery-4-1');
    });
  });

  group('Favoris', () {
    test('ajoute et retire un favori', () async {
      final f = FavoritesService.instance;
      expect(f.isFavorite(FavoriteKind.section, 'sec-base-1'), isFalse);
      await f.toggle(FavoriteKind.section, 'sec-base-1');
      expect(f.isFavorite(FavoriteKind.section, 'sec-base-1'), isTrue);
      await f.toggle(FavoriteKind.section, 'sec-base-1');
      expect(f.isFavorite(FavoriteKind.section, 'sec-base-1'), isFalse);
    });
  });

  group('LabEngine', () {
    test('construit un document HTML complet', () async {
      final html = LabEngine.buildHtml(
        html: '<button id="btn">Clic</button>',
        css: '#btn { color: red; }',
        js: '\$("#btn").on("click", function () { console.log("ok"); });',
        jquery: 'window.jQuery = {};',
      );
      expect(html, contains('<button id="btn">Clic</button>'));
      expect(html, contains('#btn { color: red; }'));
      expect(html, contains('console.log'));
      expect(html, contains('AndroidBridge'));
    });

    test('l\'asset jQuery est lisible', () async {
      final source = await LabEngine.jquerySource();
      expect(source, contains('jQuery'));
    });
  });
}
