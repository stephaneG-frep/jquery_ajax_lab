import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jquery_ajax_lab/app/app.dart';
import 'package:jquery_ajax_lab/app/theme.dart';
import 'package:jquery_ajax_lab/data/app_data.dart';
import 'package:jquery_ajax_lab/models/exercise.dart';
import 'package:jquery_ajax_lab/screens/ajax_explorer_screen.dart';
import 'package:jquery_ajax_lab/screens/exercise_detail_screen.dart';
import 'package:jquery_ajax_lab/screens/lab_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Finder editorField() => find.descendant(
      of: find.byType(LabScreen), matching: find.byType(TextField));

  Future<void> openLab(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const JqueryAjaxLabApp());
    await tester.tap(find.byIcon(Icons.science_outlined).last);
    await tester.pumpAndSettle();
  }

  Future<void> keyboard(WidgetTester tester, double height) async {
    tester.view.viewInsets = FakeViewPadding(bottom: height);
    await tester.pumpAndSettle();
  }

  /// Hauteur de l'aperçu (message de remplacement en test).
  double previewHeight(WidgetTester tester) => tester
      .getSize(find
          .ancestor(
              of: find.text('Aperçu indisponible', skipOffstage: false),
              matching: find.byType(Center))
          .first)
      .height;

  for (final size in const [Size(360, 640), Size(369, 812), Size(412, 915)]) {
    testWidgets('clavier ouvert, aperçu utilisable (${size.width}x${size.height})',
        (tester) async {
      await openLab(tester, size);
      expect(editorField(), findsOneWidget);

      // Saisie dans l'aperçu : il récupère la place.
      await keyboard(tester, size.height * 0.42);
      expect(tester.takeException(), isNull);
      expect(previewHeight(tester), greaterThan(100));

      // Retour : l'éditeur réapparaît avec la console.
      await keyboard(tester, 0);
      expect(editorField(), findsOneWidget);

      // Saisie dans l'éditeur : il reste visible, l'aperçu aussi.
      await tester.tap(editorField());
      await keyboard(tester, size.height * 0.42);
      expect(tester.takeException(), isNull);
      expect(tester.getSize(editorField()).height, greaterThan(40));
      expect(previewHeight(tester), greaterThanOrEqualTo(60));
    });
  }

  testWidgets('paysage : éditeur et aperçu côte à côte', (tester) async {
    await openLab(tester, const Size(812, 369));
    expect(tester.takeException(), isNull);
    expect(editorField(), findsOneWidget);
    expect(previewHeight(tester), greaterThan(60));
    expect(tester.getTopLeft(find.text('Aperçu')).dx, greaterThan(400));
    await keyboard(tester, 200);
    expect(tester.takeException(), isNull);
    await keyboard(tester, 260);
    expect(tester.takeException(), isNull);
  });

  testWidgets('le code n\'est ni corrigé ni mis en majuscule', (tester) async {
    void check(TextField field) {
      expect(field.autocorrect, isFalse);
      expect(field.enableSuggestions, isFalse);
      expect(field.textCapitalization, TextCapitalization.none);
    }

    await openLab(tester, const Size(412, 915));
    check(tester.widget(editorField()));

    final ex = AppData.exercises.firstWhere((e) => e.type == ExerciseType.code);
    await tester.pumpWidget(MaterialApp(home: ExerciseDetailScreen(exercise: ex)));
    check(tester.widget(find.byType(TextField)));

    await tester.pumpWidget(const MaterialApp(home: AjaxExplorerScreen()));
    for (final label in ['Headers (JSON)', 'Body (JSON)']) {
      check(tester.widget(find.widgetWithText(TextField, label)));
    }
  });

  test('la bannière d\'accueil est lisible dans les deux thèmes', () {
    double contrast(Color a, Color b) {
      final l = [a.computeLuminance(), b.computeLuminance()]..sort();
      return (l[1] + 0.05) / (l[0] + 0.05);
    }

    for (final theme in [LabTheme.light(), LabTheme.dark()]) {
      final s = theme.colorScheme;
      final end = Color.alphaBlend(
          s.primary.withValues(alpha: 0.9), theme.scaffoldBackgroundColor);
      for (final background in [s.primary, end]) {
        expect(contrast(s.onPrimary, background), greaterThan(4.5),
            reason: '${theme.brightness}');
        final chip = Color.alphaBlend(s.onPrimary.withValues(alpha: 0.12), background);
        expect(contrast(s.onPrimary, chip), greaterThan(3.5),
            reason: 'bouton ${theme.brightness}');
      }
    }
  });
}
