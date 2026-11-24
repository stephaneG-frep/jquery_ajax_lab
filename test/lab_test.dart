import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jquery_ajax_lab/data/app_data.dart';
import 'package:jquery_ajax_lab/data/lab_examples.dart';
import 'package:jquery_ajax_lab/models/exercise.dart';
import 'package:jquery_ajax_lab/screens/exercise_detail_screen.dart';
import 'package:jquery_ajax_lab/screens/lab_screen.dart';
import 'package:jquery_ajax_lab/screens/project_detail_screen.dart';
import 'package:jquery_ajax_lab/services/lab_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> openLab(WidgetTester tester, Widget screen, String label) async {
    // Format téléphone : c'est la cible de l'application.
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(home: screen));
    final button = find.text(label);
    await tester.scrollUntilVisible(button, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(LabScreen), findsOneWidget);
    expect(find.text('Laboratoire'), findsOneWidget);
  }

  testWidgets('le lab s\'ouvre depuis un exercice', (tester) async {
    final exercise =
        AppData.exercises.firstWhere((e) => e.type == ExerciseType.code);
    await openLab(
        tester, ExerciseDetailScreen(exercise: exercise), 'Tester dans le Lab');
  });

  testWidgets('le lab s\'ouvre depuis un projet', (tester) async {
    await openLab(tester, ProjectDetailScreen(project: AppData.projects.first),
        'Exécuter le code final dans le Lab');
  });

  test('la console puis jQuery sont chargés avant le code de l\'apprenant', () {
    final page = LabEngine.buildHtml(
      html: '<p>HTML_APPRENANT</p>',
      css: '',
      js: 'JS_APPRENANT',
      jquery: 'SOURCE_JQUERY',
    );
    final order = [
      page.indexOf('window.onerror'),
      page.indexOf('SOURCE_JQUERY'),
      page.indexOf('HTML_APPRENANT'),
      page.indexOf('JS_APPRENANT'),
    ];
    expect(order, everyElement(greaterThanOrEqualTo(0)));
    expect(order, orderedEquals([...order]..sort()));
  });

  test('les attributs HTML des exemples ne cassent pas les chaînes JS', () {
    for (final preset in labPresets) {
      expect(preset.js, isNot(matches(RegExp(r'"[^"\n]*<\w+ class="\w'))),
          reason: preset.id);
    }
  });

  test('la permission INTERNET est dans le manifeste principal', () {
    final manifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(manifest, contains('android.permission.INTERNET'));
  });
}
