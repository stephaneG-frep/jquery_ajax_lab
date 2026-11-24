import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jquery_ajax_lab/data/app_data.dart';
import 'package:jquery_ajax_lab/data/lab_examples.dart';
import 'package:jquery_ajax_lab/models/content_block.dart';
import 'package:jquery_ajax_lab/models/exercise.dart';
import 'package:jquery_ajax_lab/screens/exercise_detail_screen.dart';
import 'package:jquery_ajax_lab/screens/lab_screen.dart';

void main() {
  final codeExercises = AppData.exercises.where((e) => e.type == ExerciseType.code);

  test('la page de test contient les éléments visés par la solution', () {
    for (final e in codeExercises) {
      expect(e.labHtml, isNotNull, reason: e.id);
      for (final m in RegExp(r'''\$\(\s*['"]([#.])([\w-]+)''').allMatches(e.solution)) {
        final attribute = m[1] == '#' ? 'id="${m[2]}"' : 'class="${m[2]}"';
        expect(e.labHtml, contains(attribute), reason: e.id);
      }
    }
  });

  test('le code est placé dans son contexte', () {
    final e = AppData.exerciseById('ex-jquery-2')!;
    expect(e.labCode(r"$(this).hide();"), contains("function () {\n  \$(this).hide();\n}"));
    expect(AppData.exerciseById('ex-jquery-1')!.labCode(' a(); '), 'a();');
  });

  testWidgets('le Lab reçoit la page de l\'exercice', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(412, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final e = AppData.exerciseById('ex-jquery-1')!;
    await tester.pumpWidget(MaterialApp(home: ExerciseDetailScreen(exercise: e)));
    await tester.tap(find.text('Tester dans le Lab'));
    await tester.pumpAndSettle();
    expect(tester.widget<LabScreen>(find.byType(LabScreen)).initialHtml, e.labHtml);
  });

  test('les données reçues ne sont jamais collées dans du HTML', () {
    final codes = {
      for (final s in AppData.allSections)
        for (final (i, b) in s.blocks.indexed)
          if (b is CodeBlock) '${s.id} $i': b.code,
      for (final p in AppData.projects) ...{
        p.id: p.finalCode,
        for (final t in p.tasks) '${p.id} ${t.title}': t.solution,
      },
      for (final p in labPresets) p.id: p.js,
    };
    // '…<balise…' + objet.champ (le menu p3 utilise ses propres textes fixes).
    final unsafe = RegExp(
      r"""('[^'\n]*<\w[^'\n]*'|"[^"\n]*<\w[^"\n]*") \+ (?!m\.)\w+\.(?!length)\w+""",
    );
    expect("append('<li>' + u.name + '</li>')", matches(unsafe));
    for (final e in codes.entries) {
      expect(e.value, isNot(matches(unsafe)), reason: e.key);
    }
  });
}
