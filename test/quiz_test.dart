import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jquery_ajax_lab/core/constants.dart';
import 'package:jquery_ajax_lab/data/app_data.dart';
import 'package:jquery_ajax_lab/models/content_block.dart';
import 'package:jquery_ajax_lab/models/quiz.dart';
import 'package:jquery_ajax_lab/screens/course_detail_screen.dart';
import 'package:jquery_ajax_lab/screens/progress_screen.dart';
import 'package:jquery_ajax_lab/screens/quiz_screen.dart';
import 'package:jquery_ajax_lab/screens/section_screen.dart';
import 'package:jquery_ajax_lab/services/progress_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ProgressService.instance.reset();
  });

  group('Questions', () {
    test('chaque module a un quiz de 5 questions', () {
      expect(AppData.quizzes.map((q) => q.moduleId), AppData.modules.map((m) => m.id));
      for (final q in AppData.quizzes) {
        expect(q.questions.length, 5, reason: q.moduleId);
        expect(q.passMark, 4);
      }
    });

    test('chaque question est complète et sans ambiguïté', () {
      final seen = <String>{};
      for (final quiz in AppData.quizzes) {
        for (final q in quiz.questions) {
          expect(q.choices.length, 4, reason: q.question);
          expect(q.choices.toSet().length, 4, reason: q.question);
          expect(q.correctIndex, inInclusiveRange(0, 3), reason: q.question);
          expect(q.explanation.length, greaterThan(20), reason: q.question);
          expect(seen.add('${quiz.moduleId} ${q.question} ${q.code}'), isTrue);
        }
      }
    });
  });

  test('tous les exercices liés existent', () {
    for (final s in AppData.allSections) {
      for (final b in s.blocks) {
        if (b is ExerciseLinkBlock) {
          expect(AppData.exerciseById(b.exerciseId), isNotNull, reason: s.id);
        }
      }
    }
  });

  test('les exercices sont tous accessibles depuis une leçon', () {
    final linked = {
      for (final s in AppData.allSections)
        for (final b in s.blocks)
          if (b is ExerciseLinkBlock) b.exerciseId,
    };
    for (final e in AppData.exercises) {
      expect(linked, contains(e.id));
    }
  });

  test('les leçons sont numérotées dans l\'ordre', () {
    for (final m in AppData.modules) {
      expect(m.sections.map((s) => s.order), List.generate(m.sections.length, (i) => i + 1),
          reason: m.id);
    }
  });

  group('Score', () {
    test('seul le meilleur score est conservé, et relu au lancement', () async {
      final p = ProgressService.instance;
      await p.recordQuizScore('web', 3);
      expect(AppData.isQuizPassed('web'), isFalse);
      await p.recordQuizScore('web', 5);
      await p.recordQuizScore('web', 2);
      expect(p.bestQuizScore('web'), 5);
      expect(AppData.isQuizPassed('web'), isTrue);

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(StorageKeys.progressJson)!;
      await p.reset();
      expect(p.bestQuizScore('web'), isNull);
      await prefs.setString(StorageKeys.progressJson, saved);
      await p.load();
      expect(p.bestQuizScore('web'), 5);
    });

    test('une progression enregistrée avant les quiz reste lisible', () async {
      SharedPreferences.setMockInitialValues({
        StorageKeys.progressJson: '{"sections":["web-1-1"],"exercises":[],"projects":[]}',
      });
      await ProgressService.instance.load();
      expect(ProgressService.instance.isSectionComplete('web-1-1'), isTrue);
      expect(ProgressService.instance.bestQuizScore('web'), isNull);
    });
  });

  group('Écran', () {
    Future<void> open(WidgetTester tester, Widget screen) async {
      tester.view.physicalSize = const Size(412, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(home: screen));
    }

    Future<void> answer(WidgetTester tester, QuizQuestion q, {required bool right}) async {
      final index = right ? q.correctIndex : (q.correctIndex + 1) % 4;
      await tester.tap(find.text(q.choices[index]));
      await tester.pumpAndSettle();
      expect(find.text(q.explanation), findsOneWidget);
      expect(find.text(right ? 'Exact !' : 'Pas tout à fait.'), findsOneWidget);
    }

    Future<void> play(WidgetTester tester, Quiz quiz, int rightAnswers) async {
      for (var i = 0; i < 5; i++) {
        await answer(tester, quiz.questions[i], right: i < rightAnswers);
        await tester.tap(find.text(i < 4 ? 'Question suivante' : 'Voir mon score'));
        await tester.pumpAndSettle();
      }
    }

    testWidgets('un quiz réussi est enregistré', (tester) async {
      final quiz = AppData.quizOf('web')!;
      await open(tester, QuizScreen(quiz: quiz, random: Random(1)));
      await play(tester, quiz, 4);
      expect(find.text('4 / 5'), findsOneWidget);
      expect(find.text('Quiz réussi, bravo !'), findsOneWidget);
      expect(AppData.isQuizPassed('web'), isTrue);
    });

    testWidgets('un échec propose de recommencer', (tester) async {
      final quiz = AppData.quizOf('http')!;
      await open(tester, QuizScreen(quiz: quiz, random: Random(2)));
      await play(tester, quiz, 2);
      expect(find.textContaining('Il faut 4 bonnes réponses'), findsOneWidget);
      expect(AppData.isQuizPassed('http'), isFalse);
      await tester.tap(find.text('Recommencer'));
      await tester.pumpAndSettle();
      expect(find.text('Question 1 sur 5'), findsOneWidget);
    });

    testWidgets('on ne peut pas changer de réponse', (tester) async {
      final quiz = AppData.quizOf('json')!;
      final q = quiz.questions.first;
      await open(tester, QuizScreen(quiz: quiz, random: Random(3)));
      await answer(tester, q, right: false);
      await tester.tap(find.text(q.choices[q.correctIndex]));
      await tester.pumpAndSettle();
      expect(find.text('Pas tout à fait.'), findsOneWidget);
    });

    testWidgets('le quiz est proposé dans le module et à la dernière leçon', (tester) async {
      final module = AppData.modules.first;
      await open(tester, CourseDetailScreen(module: module));
      expect(find.text('Quiz du module'), findsOneWidget);
      await open(tester, SectionScreen(section: module.sections.first));
      expect(find.text('Quiz du module'), findsNothing);
      await open(tester, SectionScreen(key: UniqueKey(), section: module.sections.last));
      await tester.scrollUntilVisible(find.text('Quiz du module'), 300,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('Quiz du module'), findsOneWidget);
    });

    testWidgets('la progression compte les quiz réussis', (tester) async {
      await ProgressService.instance.recordQuizScore('web', 5);
      await open(tester, const ProgressScreen());
      expect(find.text('1/12'), findsOneWidget);
    });

    for (final quiz in AppData.quizzes) {
      testWidgets('${quiz.moduleId} tient sur un petit écran, texte agrandi', (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.4)),
            child: child!,
          ),
          home: QuizScreen(quiz: quiz, random: Random(4)),
        ));
        for (var i = 0; i < 5; i++) {
          final choice = find.text(quiz.questions[i].choices[0]);
          await tester.scrollUntilVisible(choice, 100,
              scrollable: find.byType(Scrollable).first);
          await tester.ensureVisible(choice);
          await tester.pumpAndSettle();
          await tester.tap(choice);
          await tester.pumpAndSettle();
          await tester.tap(find.byType(FilledButton));
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
        expect(find.text('Terminer'), findsOneWidget);
      });
    }
  });
}
