import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jquery_ajax_lab/app/app.dart';
import 'package:jquery_ajax_lab/core/constants.dart';
import 'package:jquery_ajax_lab/data/app_data.dart';
import 'package:jquery_ajax_lab/models/content_block.dart';
import 'package:jquery_ajax_lab/models/exercise.dart';
import 'package:jquery_ajax_lab/screens/ajax_explorer_screen.dart';
import 'package:jquery_ajax_lab/screens/exercise_detail_screen.dart';
import 'package:jquery_ajax_lab/screens/lab_screen.dart';
import 'package:jquery_ajax_lab/services/http_service.dart';
import 'package:jquery_ajax_lab/services/settings_service.dart';
import 'package:jquery_ajax_lab/utils/explain_service.dart';
import 'package:jquery_ajax_lab/widgets/code_view.dart';
import 'package:jquery_ajax_lab/widgets/inline_text.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings.instance.setTextScale(1.0);
    await AppSettings.instance.setCodeFontSize(13.5);
  });

  void usePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(412, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('« Tester dans le Lab » copie le code de l\'élève', (tester) async {
    usePhone(tester);
    final ex = AppData.exercises.firstWhere((e) => e.type == ExerciseType.code);
    await tester.pumpWidget(MaterialApp(home: ExerciseDetailScreen(exercise: ex)));
    await tester.enterText(find.byType(TextField), 'monCode();');
    await tester.tap(find.text('Tester dans le Lab'));
    await tester.pumpAndSettle();
    expect(tester.widget<LabScreen>(find.byType(LabScreen)).initialJs, 'monCode();');
  });

  group('Réglages', () {
    testWidgets('la taille du texte agit sur l\'application', (tester) async {
      await tester.pumpWidget(const JqueryAjaxLabApp());
      await tester.pump();
      final title = find.text('Progression globale');
      final before = tester.getSize(title).height;
      await AppSettings.instance.setTextScale(1.4);
      await tester.pump();
      expect(tester.getSize(title).height, greaterThan(before * 1.2));
      tester.takeException(); // la police de test est plus large que nature
    });

    testWidgets('la taille du code agit sur les blocs de code', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CodeView(code: 'a\nb\nc'))));
      double? size() => tester
          .widgetList<Text>(find.byType(Text))
          .firstWhere((t) => t.textSpan?.toPlainText() == 'a\nb\nc')
          .style
          ?.fontSize;
      expect(size(), 13.5);
      await AppSettings.instance.setCodeFontSize(20);
      await tester.pump();
      expect(size(), 20);
    });
  });

  group('Gras et italique', () {
    String plain(String s) => InlineText.spans(s).map((x) => x.text).join();

    test('les marques sont interprétées', () {
      final spans = InlineText.spans('un **client** qui *demande*');
      expect(spans[1].text, 'client');
      expect(spans[1].style!.fontWeight, FontWeight.w700);
      expect(spans[3].text, 'demande');
      expect(spans[3].style!.fontStyle, FontStyle.italic);
    });

    test('les * ordinaires sont conservés', () {
      for (final s in ['avec + - * / et %.', 'id, data-*…, 2 * 3 * 4']) {
        expect(plain(s), s);
      }
      expect(plain('**data-*** : données'), 'data-* : données');
    });

    test('plus aucun ** visible dans les leçons', () {
      for (final s in AppData.allSections) {
        for (final b in s.blocks) {
          final texts = switch (b) {
            ParagraphBlock(:final text) ||
            TipBlock(:final text) ||
            WarningBlock(:final text) ||
            InfoBlock(:final text) ||
            ConceptCardBlock(:final text) =>
              [text],
            BulletsBlock(:final items) || NumbersBlock(:final items) => items,
            StepsBlock(:final steps) => steps,
            _ => const <String>[],
          };
          for (final t in texts) {
            expect(plain(t), isNot(contains('**')), reason: s.id);
          }
        }
      }
    });
  });

  test('chaque ressource a une catégorie de progression', () {
    expect(ProgressCategories.byModule.keys, AppData.modules.map((m) => m.id));
    for (final e in AppData.exercises) {
      expect(ProgressCategories.byModule, contains(e.moduleId), reason: e.id);
    }
    for (final p in AppData.projects) {
      expect(ProgressCategories.all, contains(p.category), reason: p.id);
    }
    expect(ProgressCategories.all, containsAll(ProgressCategories.byModule.values.toSet()));
  });

  group('Explorateur AJAX', () {
    testWidgets('un exemple sélectionne sa méthode', (tester) async {
      usePhone(tester);
      await tester.pumpWidget(const MaterialApp(home: AjaxExplorerScreen()));
      await tester.tap(find.widgetWithText(ActionChip, 'POST'));
      await tester.pump();
      bool selected(String m) =>
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, m)).selected;
      expect(selected('POST'), isTrue);
      expect(selected('GET'), isFalse);
      expect(find.textContaining('"Content-Type": "application/json"'), findsWidgets);
    });

    Future<({HttpResult? result, HttpFailure? failure})> call(
      MockClientHandler handler, {
      String method = 'GET',
      Map<String, String> headers = const {},
      String? body,
    }) =>
        HttpService(client: MockClient(handler))
            .send(method: method, url: 'https://x.fr', headers: headers, body: body);

    test('un corps sans Content-Type part en JSON, en UTF-8', () async {
      late http.Request sent;
      await call((r) async {
        sent = r;
        return http.Response('', 201);
      }, method: 'POST', body: '{"nom":"Zoé"}');
      expect(sent.headers['content-type'], startsWith('application/json'));
      expect(utf8.decode(sent.bodyBytes), '{"nom":"Zoé"}');
    });

    test('un Content-Type choisi est respecté', () async {
      late http.Request sent;
      await call((r) async {
        sent = r;
        return http.Response('', 200);
      }, method: 'PUT', headers: {'content-type': 'text/csv'}, body: 'a;b');
      expect(sent.headers['content-type'], startsWith('text/csv'));
    });

    test('un DELETE sans corps n\'annonce pas de contenu', () async {
      late http.Request sent;
      await call((r) async {
        sent = r;
        return http.Response('', 200);
      }, method: 'DELETE', body: '');
      expect(sent.headers, isNot(contains('content-type')));
    });

    test('une réponse latin1 reste lisible', () async {
      final r = await call((_) async => http.Response.bytes(latin1.encode('é à ç'), 200));
      expect(r.result!.body, 'é à ç');
    });

    test('une image est résumée au lieu d\'échouer', () async {
      final r = await call((_) async => http.Response.bytes([0x89, 0xff], 200,
          headers: {'content-type': 'image/png'}));
      expect(r.result!.statusCode, 200);
      expect(r.result!.body, contains('image/png, 2 octets'));
    });
  });

  group('Explique-moi ce code', () {
    String first(String code, [String language = 'javascript']) =>
        ExplainService.explain(code, language: language).first.explanation;

    test('chaque explication rédigée correspond à une leçon', () {
      final lessonCodes = [
        for (final s in AppData.allSections)
          for (final b in s.blocks)
            if (b is CodeBlock) ExplainService.explain(b.code, language: b.language),
      ];
      for (final known in AppData.explainableCodes) {
        expect(lessonCodes.any((lines) => identical(lines, known.lines)), isTrue,
            reason: known.id);
      }
    });

    test('un mot contenu dans un autre ne trompe pas l\'explication', () {
      expect(first('const industry = 1;'), contains('constante industry'));
      expect(first('let x = entry;'), contains('variable x'));
      expect(first("console.log('try');"), isNot(contains('protégé')));
      expect(first('.catch(function (e) {'), contains('échec'));
    });

    test('les éléments importants de la ligne sont nommés', () {
      final text = first(r"$('#f').on('submit', function (e) {");
      expect(text, allOf(contains('« f »'), contains('« submit »')));
    });

    test('les autres langages ont leurs propres explications', () {
      expect(first('<button id="btn">', 'html'), allOf(contains('bouton'), contains('btn')));
      expect(first('"age": 30,', 'json'), contains('un nombre'));
      expect(first('GET /api HTTP/1.1', 'http'), contains('GET'));
      expect(first('#a { color: red; }', 'css'), contains('#a'));
    });
  });

  test('projet 1 : le libellé est calculé après l\'animation', () {
    final p = AppData.projectById('p1-afficher-masquer')!;
    expect(p.finalCode, contains('fadeToggle(300, function'));
  });
}
