import 'package:flutter_test/flutter_test.dart';

import 'package:jquery_ajax_lab/data/app_data.dart';
import 'package:jquery_ajax_lab/models/exercise.dart';
import 'package:jquery_ajax_lab/utils/js_text.dart';

/// Écritures différentes de la solution, mais correctes.
const Map<String, List<String>> _correct = {
  'ex-js-1': [
    r'const saluer = (nom) => `Bonjour ${nom} !`;',
    r'const saluer = nom => "Bonjour " + nom + " !";',
    'function saluer(n) { var t = "Bonjour " + n + " !"; return t; }',
  ],
  'ex-jquery-1': [r'$( "#demo" ).text( "Modifié !" )', "jQuery('p#demo').text('Modifié !');"],
  'ex-jquery-2': [r"$(this).parents('.carte').first().remove();"],
  'ex-jquery-3': [
    r"$(function () { console.log('Prêt'); });",
    r'$(() => { console.log("Prêt") })',
    r'$(document).ready(() => console.log("Prêt"));',
  ],
  'ex-dom-2': [
    r"$('#resultat').text(parseInt($('#age').val(), 10) * 2);",
    r"let age = Number($('#age').val());" '\n' r"$('#resultat').text(2 * age);",
  ],
  'ex-dom-3': [r'$("#carte").toggleClass("active")'],
  'ex-dom-4': [
    r"$('<li>Nouveau</li>').appendTo('#liste');",
    r"$('#liste').append($('<li>').text('Nouveau'));",
  ],
  'ex-events-1': [
    'e.preventDefault();',
    r"$('#form').submit(function (event) { event.preventDefault(); });",
    r"$('#form').on('submit', e => e.preventDefault());",
  ],
  'ex-events-2': [
    r"$('#recherche').keyup(function () { console.log(this.value); });",
    r"$('#recherche').on('keyup', (e) => console.log($(e.target).val()));",
  ],
  'ex-events-3': [
    r"$('#bouton').on('click', () => $('#message').text('Bonjour !'));",
    'function saluer() { \$("#message").text("Bonjour !"); }\n\$("#bouton").on("click", saluer);',
  ],
  'ex-events-4': [r"$('.bouton').click(function () { $(this).hide(); });"],
  'ex-events-5': [r'$("#liste").on("click", "li", function () { $(this).addClass("fait"); });'],
  'ex-anim-1': [r"$('#btn').click(() => { $('#zone').fadeToggle(300); });"],
  'ex-anim-2': [r"$('#banner').fadeOut(500, () => { $('#banner').remove(); });"],
  'ex-anim-3': [r"$('#btn').click(function () { $('#panneau').slideToggle(300) })"],
  'ex-anim-4': [r'$("#boite").animate({ "left": "+=150px" }, 800)'],
  'ex-ajax-1': [
    r"$.ajax({ url: 'https://jsonplaceholder.typicode.com/users', type: 'GET', success(d) { console.log(d); } });",
    r"$.ajax({ url: 'https://jsonplaceholder.typicode.com/users', method: 'GET' }).done(d => console.log(d));",
  ],
  'ex-ajax-2': [
    r'$.get("https://jsonplaceholder.typicode.com/posts/1").done(p => $("#titre").text(p.title));',
  ],
  'ex-ajax-3': [
    r"$.ajax({ url, method: 'GET', success, error: () => console.error('Erreur') });",
    r"$.ajax({ url: u, method: 'GET' }).fail(function () { console.log('Erreur'); });",
  ],
  'ex-http-2': [
    r"""$.ajax({
      type: "POST",
      url: "https://jsonplaceholder.typicode.com/posts", // l'endpoint
      contentType: "application/json",
      data: JSON.stringify({ title: "Mon post" }),
    });""",
  ],
  'ex-json-1': ["console.log(data['name']);", 'console.log( data.name )'],
  'ex-json-4': ['let o = JSON.parse( texte )'],
  'ex-rest-3': [
    r"""$.ajax({ url: '/api/todos', method: 'GET' });
$.ajax({ method: 'POST', url: '/api/todos', data: { title: 'x' } });
$.ajax({ method: 'PATCH', url: '/api/todos/1', data: JSON.stringify({ done: true }) });
$.ajax({ type: 'DELETE', url: '/api/todos/1' });""",
  ],
  'ex-modern-1': [
    "fetch('https://jsonplaceholder.typicode.com/users').then(r => r.json()).then(d => console.log(d))",
    'fetch("https://jsonplaceholder.typicode.com/users").then(function (r) { return r.json(); }).then(console.log);',
  ],
  'ex-modern-2': [
    'const charger = async () => { const r = await fetch(url); const d = await r.json(); console.log(d); };',
    'async function charger() { const d = await (await fetch(url)).json(); console.log(d); }',
  ],
  'ex-modern-3': [
    'const charger = async () => { try { const r = await fetch(u); } catch (e) { console.error(e); } };',
  ],
};

/// Réponses fausses, y compris celles qui contiennent les bons mots.
const Map<String, List<String>> _wrong = {
  'ex-js-1': ['function return', 'function saluer(nom) { return "Bonjour"; }'],
  'ex-jquery-1': ['demo text', r"$('demo').text('Modifié !')", r"$('#demo').text('Modifié !'"],
  'ex-jquery-2': ['closest .carte', r"$(this).closest('.carte');"],
  'ex-jquery-3': ['document ready', r"$(document); console.log('Prêt');"],
  'ex-dom-2': ['val Number', r"$('#resultat').text($('#age').val() + 2);"],
  'ex-dom-3': ['toggleClass', r"$('.carte').toggleClass('active');"],
  'ex-dom-4': ['append <li>', r"$('#liste').prepend('<li>Nouveau</li>');"],
  'ex-events-1': ['// preventDefault', 'preventDefault', 'e.preventDefault'],
  'ex-events-2': ['keyup', r"$('#recherche').on('keyup', () => console.log($(this).val()));"],
  'ex-events-3': ['on( click', r"$('#bouton').on('click', function () { });"],
  'ex-events-4': [r'$(this)', r"$('.bouton').on('click', () => { $(this).hide(); });"],
  'ex-events-5': ['on( li', r"$('#liste li').on('click', function () { $(this).addClass('fait'); });"],
  'ex-anim-1': ['toggle', r"$('#zone').toggle(300);"],
  'ex-anim-2': ['fadeOut remove', r"$('#banner').remove(); $('#banner').fadeOut(500);"],
  'ex-anim-3': ['slideToggle', r"$('#panneau').slideToggle(300);"],
  'ex-anim-4': ['animate left', r"$('#boite').animate({ left: '150px' }, 800);"],
  'ex-ajax-1': ['ajax method GET', r"$.ajax({ url: 'https://jsonplaceholder.typicode.com/users', method: 'GET' });"],
  'ex-ajax-2': ['get( title', r"$.get('https://jsonplaceholder.typicode.com/posts/1');"],
  'ex-ajax-3': ['error', r"$.ajax({ url: u, success: function () { console.log('Erreur'); } });"],
  'ex-http-2': ['stringify', r"$.ajax({ url: 'https://jsonplaceholder.typicode.com/posts', method: 'POST', data: { title: 'x' } });"],
  'ex-json-1': ['// data.name', 'data.name', 'console.log(data.names)'],
  'ex-json-4': ['JSON.parse', 'JSON.stringify(texte)'],
  'ex-rest-3': [r'$.get $.post PATCH DELETE', r"$.get('/api/todos'); $.post('/api/todos', { title: 'x' });"],
  'ex-modern-1': [
    'fetch( response.json',
    "fetch('https://jsonplaceholder.typicode.com/users').then(r => { r.json() }).then(d => console.log(d))",
  ],
  'ex-modern-2': ['async await', 'function charger() { const r = await fetch(u); const d = await r.json(); console.log(d); }'],
  'ex-modern-3': ['try catch', 'async function charger() { try { await fetch(u); } catch (e) { } }'],
};

void main() {
  final codeExercises =
      AppData.exercises.where((e) => e.type == ExerciseType.code).toList();

  test('chaque exercice de code est couvert', () {
    final ids = codeExercises.map((e) => e.id).toSet();
    expect(_correct.keys.toSet(), ids);
    expect(_wrong.keys.toSet(), ids);
  });

  for (final e in codeExercises) {
    test('validation de ${e.id}', () {
      expect(e.validate(e.solution).valid, isTrue, reason: 'solution');
      for (final answer in _correct[e.id]!) {
        expect(e.validate(answer).valid, isTrue, reason: 'refusée à tort : $answer');
      }
      for (final answer in _wrong[e.id]!) {
        final result = e.validate(answer);
        expect(result.valid, isFalse, reason: 'acceptée à tort : $answer');
        expect(result.feedback, isNotEmpty);
      }
    });
  }

  test('une erreur de QCM ne révèle pas la bonne réponse', () {
    for (final e in AppData.exercises.where((e) => e.type == ExerciseType.choice)) {
      final wrong = e.correctChoiceIndex == 0 ? 1 : 0;
      final feedback = e.validateChoice(wrong).feedback!;
      expect(feedback, isNot(contains('"${e.choices![e.correctChoiceIndex!]}"')), reason: e.id);
      expect(feedback, isNot(contains(e.solutionExplanation)), reason: e.id);
    }
  });

  test('une majuscule ajoutée par le clavier est signalée', () {
    final e = AppData.exerciseById('ex-json-1')!;
    final result = e.validate('Console.log(data.name);');
    expect(result.valid, isFalse);
    expect(result.feedback, contains('majuscule'));
    expect(AppData.exerciseById('ex-json-4')!.validate('JSON.parse(texte)').valid, isTrue);
  });

  test('JsText distingue commentaires et URL', () {
    expect(JsText.canonical("get( 'https://a.fr' ) // fin"), "get('https://a.fr')");
    expect(JsText.canonical("f(x) { // début\n  g('a'); }"), "f(x){g('a');}");
    expect(JsText.canonical('f("a")'), JsText.canonical("f( 'a' )"));
    expect(JsText.isBalanced("f('(') // )"), isTrue);
    expect(JsText.isBalanced("f('a)"), isFalse);
    expect(JsText.isBalanced('f({)}'), isFalse);
  });
}
