import '../models/snippet.dart';

/// Explications rédigées de « Explique-moi ce code ».
///
/// Chaque code doit correspondre à un bloc d'une leçon (commentaires, espaces
/// et type de guillemets mis à part), sinon il n'est jamais affiché.
List<ExplainableCode> allExplainableCodes() => const [
      ExplainableCode(
        id: 'expl-delegation',
        title: 'Délégation d\'événements',
        code: r'''$('#liste').on('click', '.supprimer', function () {
  $(this).closest('li').remove();
});''',
        lines: [
          CodeLineExplanation(
            line: r"$('#liste')",
            explanation: 'sélectionne la liste, présente dès le départ.',
          ),
          CodeLineExplanation(
            line: ".on('click', …)",
            explanation: 'installe un gestionnaire pour l\'événement clic.',
          ),
          CodeLineExplanation(
            line: "'.supprimer'",
            explanation: 'cible les boutons .supprimer. C\'est la délégation : l\'événement marche '
                'aussi pour les éléments créés plus tard.',
          ),
          CodeLineExplanation(
            line: r'$(this)',
            explanation: 'l\'élément concerné : le bouton .supprimer cliqué.',
          ),
          CodeLineExplanation(
            line: ".closest('li')",
            explanation: 'remonte au <li> parent le plus proche.',
          ),
          CodeLineExplanation(
            line: '.remove()',
            explanation: 'supprime ce <li> du DOM.',
          ),
        ],
      ),
      ExplainableCode(
        id: 'expl-ready',
        title: 'Le document prêt',
        code: r'''$(document).ready(function () {
  console.log('La page est prête !');
});''',
        lines: [
          CodeLineExplanation(
            line: r'$(document)',
            explanation: 'enveloppe le document dans un objet jQuery.',
          ),
          CodeLineExplanation(
            line: '.ready(…)',
            explanation: 'attend que le DOM soit entièrement construit.',
          ),
          CodeLineExplanation(
            line: 'function () { … }',
            explanation: 'le callback : exécuté quand la page est prête.',
          ),
          CodeLineExplanation(
            line: "console.log('La page est prête !')",
            explanation: 'affiche un message dans la console du navigateur.',
          ),
        ],
      ),
      ExplainableCode(
        id: 'expl-click',
        title: 'Un clic simple',
        code: r'''$('#bouton').on('click', function () {
  $('#message').text('Bonjour !');
});''',
        lines: [
          CodeLineExplanation(
            line: r"$('#bouton')",
            explanation: 'sélectionne l\'élément avec l\'id bouton.',
          ),
          CodeLineExplanation(
            line: ".on('click', …)",
            explanation: 'écoute l\'événement clic sur ce bouton.',
          ),
          CodeLineExplanation(
            line: 'function () { … }',
            explanation: 'le callback : exécuté à chaque clic.',
          ),
          CodeLineExplanation(
            line: r"$('#message')",
            explanation: 'sélectionne l\'élément avec l\'id message.',
          ),
          CodeLineExplanation(
            line: ".text('Bonjour !')",
            explanation: 'remplace son texte par « Bonjour ! ».',
          ),
        ],
      ),
      ExplainableCode(
        id: 'expl-ajax',
        title: 'Une requête AJAX complète',
        code: r'''$.ajax({
  url: 'https://example.com/api/users',
  method: 'GET',
  dataType: 'json',
  success: function (data) {
    console.log('Données reçues :', data);
  },
  error: function (error) {
    console.log('Erreur :', error.status, error.statusText);
  }
});''',
        lines: [
          CodeLineExplanation(
            line: r'$.ajax({ … })',
            explanation: 'lance une requête HTTP avec les options fournies.',
          ),
          CodeLineExplanation(
            line: "url: 'https://example.com/api/users'",
            explanation: 'l\'endpoint à interroger.',
          ),
          CodeLineExplanation(
            line: "method: 'GET'",
            explanation: 'le verbe HTTP : GET pour lire des données.',
          ),
          CodeLineExplanation(
            line: "dataType: 'json'",
            explanation: 'le format attendu : jQuery convertit la réponse JSON en objet.',
          ),
          CodeLineExplanation(
            line: 'success: function (data) { … }',
            explanation: 'callback exécuté si la requête réussit : data contient la réponse.',
          ),
          CodeLineExplanation(
            line: 'error: function (error) { … }',
            explanation: 'callback exécuté si la requête échoue : status est le code HTTP.',
          ),
        ],
      ),
      ExplainableCode(
        id: 'expl-toggle',
        title: 'Afficher / masquer',
        code: r'''$('#bouton').on('click', function () {
  $('#zone').toggle(300);
});''',
        lines: [
          CodeLineExplanation(
            line: r"$('#bouton').on('click', function () {",
            explanation: 'écoute le clic sur le bouton.',
          ),
          CodeLineExplanation(
            line: r"$('#zone')",
            explanation: 'sélectionne la zone à afficher ou masquer.',
          ),
          CodeLineExplanation(
            line: '.toggle(300)',
            explanation: 'bascule sa visibilité avec une animation de 300 ms.',
          ),
        ],
      ),
      ExplainableCode(
        id: 'expl-modern',
        title: 'JavaScript moderne : async / await',
        code: r'''async function chargerUtilisateurs() {
  const response = await fetch('/api/users');
  const data = await response.json();
  console.log(data);
}

chargerUtilisateurs();''',
        lines: [
          CodeLineExplanation(
            line: 'async function chargerUtilisateurs() {',
            explanation: 'déclare une fonction asynchrone : elle peut utiliser await.',
          ),
          CodeLineExplanation(
            line: "await fetch('/api/users')",
            explanation: 'envoie la requête et attend sa réponse : la page ne se bloque pas.',
          ),
          CodeLineExplanation(
            line: 'await response.json()',
            explanation: 'lit le corps de la réponse et le convertit en objet JavaScript.',
          ),
          CodeLineExplanation(
            line: 'console.log(data)',
            explanation: 'affiche les données reçues.',
          ),
          CodeLineExplanation(
            line: 'chargerUtilisateurs();',
            explanation: 'appelle la fonction : sans cette ligne, rien ne se passe.',
          ),
        ],
      ),
      ExplainableCode(
        id: 'expl-create',
        title: 'Insérer des éléments',
        code: r'''$('#liste').append('<li>À la fin</li>');
$('#liste').prepend('<li>Au début</li>');
$('#element').before('<p>Avant</p>');
$('#element').after('<p>Après</p>');''',
        lines: [
          CodeLineExplanation(
            line: r"$('#liste').append('<li>À la fin</li>')",
            explanation: 'insère le <li> en dernier enfant de la liste.',
          ),
          CodeLineExplanation(
            line: r"$('#liste').prepend('<li>Au début</li>')",
            explanation: 'insère le <li> en premier enfant de la liste.',
          ),
          CodeLineExplanation(
            line: r"$('#element').before('<p>Avant</p>')",
            explanation: 'insère le paragraphe juste avant l\'élément, au même niveau.',
          ),
          CodeLineExplanation(
            line: r"$('#element').after('<p>Après</p>')",
            explanation: 'insère le paragraphe juste après l\'élément, au même niveau.',
          ),
        ],
      ),
    ];
