import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jquery_ajax_lab/app/app.dart';
import 'package:jquery_ajax_lab/screens/home_screen.dart';
import 'package:jquery_ajax_lab/services/favorites_service.dart';
import 'package:jquery_ajax_lab/services/progress_service.dart';
import 'package:jquery_ajax_lab/services/settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FavoritesService.instance.reset();
    ProgressService.instance.reset();
  });

  testWidgets('l\'écran d\'accueil affiche les éléments principaux',
      (tester) async {
    await AppSettings.instance.load();
    await tester.pumpWidget(const JqueryAjaxLabApp());
    await tester.pumpAndSettle();

    expect(find.text('jQuery AJAX Lab'), findsWidgets);
    expect(find.text('Accueil'), findsWidgets);
    expect(find.text('Cours'), findsWidgets);
    expect(find.text('Lab'), findsWidgets);
    expect(find.text('Projets'), findsWidgets);
    expect(find.text('Docs'), findsWidgets);
  });

  testWidgets('l\'écran d\'accueil autonome s\'affiche sans erreur',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: HomeScreen(onNavigate: _noop)),
    ));
    await tester.pumpAndSettle();

    expect(find.text('jQuery AJAX Lab'), findsOneWidget);
    expect(find.text('Progression globale'), findsOneWidget);
    expect(find.text('Laboratoire'), findsOneWidget);
    expect(find.text('Explorateur AJAX'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Mode d\'emploi'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Mode d\'emploi'), findsOneWidget);
  });
}

void _noop(int tab) {}
