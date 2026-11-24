import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jquery_ajax_lab/app/app.dart';
import 'package:jquery_ajax_lab/app/readable_color.dart';
import 'package:jquery_ajax_lab/app/theme.dart';
import 'package:jquery_ajax_lab/core/constants.dart';
import 'package:jquery_ajax_lab/data/app_data.dart';
import 'package:jquery_ajax_lab/data/lab_examples.dart';
import 'package:jquery_ajax_lab/models/content_block.dart';
import 'package:jquery_ajax_lab/screens/courses_screen.dart';
import 'package:jquery_ajax_lab/screens/docs_screen.dart';
import 'package:jquery_ajax_lab/screens/lab_screen.dart';
import 'package:jquery_ajax_lab/services/favorites_service.dart';
import 'package:jquery_ajax_lab/services/lab_draft_service.dart';
import 'package:jquery_ajax_lab/services/progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LabDraftService.instance.load();
    await FavoritesService.instance.reset();
    await ProgressService.instance.reset();
  });

  testWidgets('les textes système sont en français', (tester) async {
    await tester.pumpWidget(const JqueryAjaxLabApp());
    await tester.pump();
    final l10n = MaterialLocalizations.of(tester.element(find.byType(Scaffold).first));
    expect(l10n.backButtonTooltip, 'Retour');
    expect(l10n.copyButtonLabel, 'Copier');
  });

  group('Code pédagogique', () {
    test('aucun extrait JavaScript ne contient de points de suspension en guise de code', () {
      final placeholder = RegExp(r'\{\s*(…|\.\.\.)\s*\}');
      final codes = {
        for (final s in AppData.allSections)
          for (final b in s.blocks)
            if (b is CodeBlock) s.id: b.code,
        for (final s in AppData.snippets) s.id: s.example,
        for (final p in AppData.projects)
          for (final t in p.tasks) '${p.id} ${t.title}': t.solution,
      };
      for (final e in codes.entries) {
        expect(e.value, isNot(matches(placeholder)), reason: e.key);
      }
    });

    test('les blocs étiquetés JavaScript ne contiennent pas de balises', () {
      for (final s in AppData.allSections) {
        for (final b in s.blocks) {
          if (b is CodeBlock && b.language == 'javascript') {
            expect(b.code, isNot(matches(RegExp(r'^\s*<', multiLine: true))), reason: s.id);
          }
        }
      }
    });

    test('la saisie de l\'utilisateur n\'est jamais collée dans du HTML', () {
      final todo = AppData.projectById('p5-todolist')!;
      final form = AppData.projectById('p4-formulaire')!;
      final preset = labPresets.firstWhere((p) => p.id == 'preset-todolist');
      for (final code in [
        todo.finalCode,
        form.finalCode,
        preset.js,
        ...todo.tasks.map((t) => t.solution),
        ...form.tasks.map((t) => t.solution),
      ]) {
        expect(code, isNot(contains('+ texte +')));
        expect(code, isNot(contains('.html(')));
      }
    });
  });

  group('Recherche', () {
    List<String> ids(String q) => AppData.search(q).map((r) => r.id).toList();

    test('aucun doublon', () {
      for (final q in ['ajax', 'fetch', 'append', 'click', 'json', 'get', 'e']) {
        expect(ids(q).toSet().length, ids(q).length, reason: q);
      }
    });

    test('accents et casse sont ignorés', () {
      for (final (a, b) in [('requete', 'Requête'), ('evenement', 'ÉVÉNEMENT')]) {
        expect(ids(a), isNotEmpty);
        expect(ids(a), ids(b));
      }
    });

    test('le texte des leçons est trouvé', () {
      expect(ids('John Resig'), contains('section:jquery-4-1'));
      expect(ids('couteau suisse'), contains('section:anim-7-4'));
    });

    test('les titres passent avant le texte', () {
      expect(AppData.search('delegation').first.title.toLowerCase(), contains('délégation'));
    });
  });

  testWidgets('la liste des exercices se met à jour après une réussite', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CoursesScreen())));
    await tester.tap(find.text('Exercices'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle), findsNothing);
    await ProgressService.instance.markExercisePassed(AppData.exercises.first.id);
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('une fiche peut être ajoutée aux favoris', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: DocsScreen())));
    await tester.tap(find.byTooltip('Ajouter aux favoris').first);
    await tester.pump();
    expect(FavoritesService.instance.favorites.single.kind, FavoriteKind.snippet);
    expect(find.byTooltip('Retirer des favoris'), findsOneWidget);
  });

  test('les couleurs d\'accent sont lisibles dans les deux thèmes', () {
    const accents = [
      LabColors.seed, LabColors.terminal, LabColors.amber,
      LabColors.coral, LabColors.purple, LabColors.sky,
      Colors.red, Colors.green, Colors.orange, Colors.deepPurple, Colors.amber,
      Colors.indigo, Colors.teal, Colors.blueGrey,
    ];
    for (final brightness in Brightness.values) {
      final surfaces = brightness == Brightness.dark
          ? const [Color(0xFF15161F), Color(0xFF1E2130)]
          : const [Colors.white, Color(0xFFF4F6FB)];
      for (final accent in accents) {
        for (final ratio in [3.0, 4.5]) {
          final color = accent.readableOn(brightness, ratio: ratio);
          for (final surface in surfaces) {
            for (final alpha in [0.0, 0.1, 0.18]) {
              final bg = Color.alphaBlend(accent.withValues(alpha: alpha), surface);
              expect(ReadableColor.contrast(color, bg), greaterThanOrEqualTo(ratio),
                  reason: '$accent $brightness $ratio');
            }
          }
        }
      }
    }
  });

  group('Brouillon du Lab', () {
    Finder editor() => find.byType(TextField).hitTestable();

    Future<void> openLab(WidgetTester tester, {bool keepsDraft = true}) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: LabScreen(key: UniqueKey(), keepsDraft: keepsDraft)),
      ));
      await tester.pumpAndSettle();
    }

    Future<void> choosePreset(WidgetTester tester, String label) async {
      await tester.tap(find.byType(DropdownButtonFormField<LabPreset>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label).last);
      await tester.pumpAndSettle();
    }

    testWidgets('le code est enregistré puis repris', (tester) async {
      await openLab(tester);
      await tester.enterText(editor(), '<h1>À moi</h1>');
      await tester.pump(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      final saved = jsonDecode(prefs.getString(StorageKeys.labDraftJson)!) as Map;
      expect(saved['html'], '<h1>À moi</h1>');

      await LabDraftService.instance.load(); // comme au prochain lancement
      await openLab(tester);
      expect(find.text('<h1>À moi</h1>'), findsOneWidget);
    });

    testWidgets('un exemple ne remplace pas le code modifié sans accord', (tester) async {
      await openLab(tester);
      await tester.enterText(editor(), 'MON CODE');
      await choosePreset(tester, 'Afficher / masquer');
      expect(find.text('Remplacer votre code ?'), findsOneWidget);
      await tester.tap(find.text('Garder mon code'));
      await tester.pumpAndSettle();
      expect(find.text('MON CODE'), findsOneWidget);
      expect(find.text('Exemple : clic simple'), findsOneWidget);

      await choosePreset(tester, 'Afficher / masquer');
      await tester.tap(find.text('Remplacer'));
      await tester.pumpAndSettle();
      expect(find.text('MON CODE'), findsNothing);
      expect(find.text('Afficher / masquer'), findsOneWidget);
    });

    testWidgets('sans modification, aucun message', (tester) async {
      await openLab(tester);
      await choosePreset(tester, 'Afficher / masquer');
      expect(find.text('Remplacer votre code ?'), findsNothing);
    });

    testWidgets('le Lab d\'un exercice ne touche pas au brouillon', (tester) async {
      await openLab(tester, keepsDraft: false);
      await tester.enterText(editor(), 'essai');
      await tester.pump(const Duration(seconds: 1));
      expect(LabDraftService.instance.code, isNull);
    });

    test('un brouillon illisible est ignoré', () async {
      SharedPreferences.setMockInitialValues({StorageKeys.labDraftJson: '{oups'});
      await LabDraftService.instance.load();
      expect(LabDraftService.instance.code, isNull);
    });
  });
}
