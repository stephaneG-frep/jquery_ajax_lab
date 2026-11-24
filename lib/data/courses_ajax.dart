import 'package:flutter/material.dart';

import '../models/content_block.dart';
import '../models/course.dart';

/// MODULES 8 à 12 : AJAX, HTTP, JSON, REST et JavaScript moderne.
List<CourseModule> ajaxModules() => [
      CourseModule(
        id: 'ajax',
        number: 8,
        title: 'AJAX',
        subtitle: 'Charger des données sans recharger la page.',
        icon: Icons.cloud_sync,
        sections: [
          CourseSection(
            id: 'ajax-8-1',
            moduleId: 'ajax',
            order: 1,
            title: 'Qu\'est-ce qu\'AJAX ?',
            blocks: [
              const ParagraphBlock(
                  '**AJAX** (Asynchronous JavaScript And XML) désigne la technique qui permet d\'échanger '
                  'des données avec un serveur **sans recharger la page**. Aujourd\'hui, les données sont '
                  'presque toujours en **JSON** plutôt qu\'en XML, mais le nom est resté.'),
              const ConceptCardBlock(
                icon: Icons.compare_arrows,
                title: 'Le grand mot caché : asynchrone',
                text: 'La requête part en arrière-plan. Le reste du code continue de tourner, et un callback '
                    'est appelé quand la réponse arrive.',
              ),
              const ParagraphBlock('À quoi sert AJAX concrètement ?'),
              const BulletsBlock([
                'Afficher des utilisateurs chargés depuis une API.',
                'Enregistrer un formulaire sans recharger la page.',
                'Faire une recherche instantanée.',
                'Mettre à jour un compteur, un dashboard…',
              ]),
              const CodeBlock(
                '''// Exemple de réaction « page entière » (à éviter)
// Chaque clic recharge toute la page…

// AJAX : on échange seulement les données
\$.get('https://example.com/api/users', function (data) {
  afficherUsers(data);
});''',
                explanation: 'Avec AJAX, seul le contenu pertinent est actualisé.',
              ),
              const TipBlock(
                  'Le laboratoire de cette application vous permet de tester les requêtes réelles dans '
                  'l\'Explorateur AJAX, avec de vraies API publiques.'),
            ],
          ),
          CourseSection(
            id: 'ajax-8-2',
            moduleId: 'ajax',
            order: 2,
            title: 'Le cycle requête / réponse',
            blocks: [
              const ParagraphBlock('Visualisez toujours le parcours d\'une donnée :'),
              const StepsBlock(
                title: 'Le cycle complet',
                steps: [
                  'Application (votre code jQuery)',
                  'Requête HTTP',
                  'Serveur / API',
                  'Réponse',
                  'JSON',
                  'Affichage',
                ],
              ),
              const ParagraphBlock(
                  'Votre code ne fait que deux choses : **préparer la requête** et **traiter la réponse**. '
                  'Tout le reste (le voyage réseau) est géré par le navigateur.'),
              const CodeBlock(
                '''// 1. Préparer la requête
\$.get('https://jsonplaceholder.typicode.com/users', function (data) {
  // 2. Traiter la réponse (data est déjà du JSON)
  \$('#liste').html('');
  data.forEach(function (user) {
    \$('<li>').text(user.name).appendTo('#liste');
  });
});''',
                explanation: 'La fonction de rappel reçoit les données déjà parsées et les affiche.',
              ),
              const WarningBlock(
                  'Les données reçues ne sont pas de confiance : insérez-les avec .text(), jamais en '
                  'les collant dans une chaîne HTML. Sinon, un nom contenant une balise <script> ou '
                  '<img> pourrait exécuter du code chez vos visiteurs (faille XSS).'),
              const InfoBlock(
                  'L\'explorateur AJAX de l\'application vous montre chaque étape : status, temps, headers '
                  'et body — exactement le cycle ci-dessus.'),
            ],
          ),
          CourseSection(
            id: 'ajax-8-3',
            moduleId: 'ajax',
            order: 3,
            title: '\$.ajax() : la méthode complète',
            blocks: [
              const ParagraphBlock(
                  '**\$.ajax()** est la méthode générale : un seul objet d\'options contrôle tout. '
                  'Les autres méthodes (\$.get, \$.post) ne sont que des raccourcis vers elle.'),
              const CodeBlock(
                '''\$.ajax({
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
                explanation: 'url : la cible. method : le verbe HTTP. success/error : les callbacks de résultat.',
                lineByLine: true,
              ),
              const TableBlock(
                headers: ['Option', 'Rôle'],
                rows: [
                  ['url', 'Adresse de la ressource'],
                  ['method', 'GET, POST, PUT, PATCH ou DELETE'],
                  ['data', 'Paramètres à envoyer (objet ou chaîne)'],
                  ['dataType', 'Format attendu (json, text…)'],
                  ['headers', 'En-têtes HTTP supplémentaires'],
                  ['timeout', 'Délai maximum en millisecondes'],
                  ['success', 'Callback si la requête aboutit'],
                  ['error', 'Callback si la requête échoue'],
                ],
              ),
              const CodeBlock(
                '''// Envoyer des données avec POST
\$.ajax({
  url: 'https://example.com/api/users',
  method: 'POST',
  contentType: 'application/json',
  data: JSON.stringify({ name: 'Alice', email: 'alice@example.com' }),
  success: function (reponse) {
    console.log('Créé !', reponse);
  },
  error: function (xhr) {
    console.log('Erreur', xhr.status);
  }
});''',
                explanation: 'POST envoie un corps JSON. Toujours utiliser JSON.stringify() pour convertir un objet.',
              ),
              const ExerciseLinkBlock('ex-ajax-1'),
            ],
          ),
          CourseSection(
            id: 'ajax-8-4',
            moduleId: 'ajax',
            order: 4,
            title: '\$.get() et \$.post() : les raccourcis',
            blocks: [
              const ParagraphBlock(
                  'Pour les cas simples, jQuery fournit des raccourcis lisibles :'),
              const CodeBlock(
                '''// GET : lire des données
\$.get(url, callback);

// POST : créer une ressource
\$.post(url, donnees, callback);

// Exemple
\$.get('https://jsonplaceholder.typicode.com/posts/1', function (post) {
  \$('#titre').text(post.title);
});''',
                explanation: 'Premier argument : l\'URL. Dernier : le callback de succès.',
              ),
              const ParagraphBlock('On peut aussi ajouter une fonction d\'erreur :'),
              const CodeBlock(
                '''\$.get('https://exemple.invalide/api', function (data) {
  console.log(data);
}).fail(function () {
  console.log('La requête a échoué');
});''',
                explanation: '\$.get renvoie un objet jqXHR qui supporte .fail() pour les erreurs.',
              ),
              const ComparisonBlock(
                title: 'GET : jQuery vs Fetch',
                jquery: '''\$.get('/api/users', function (data) {
  console.log(data);
});''',
                modern: '''fetch('/api/users')
  .then(response => response.json())
  .then(data => console.log(data));''',
                note: 'Le module 12 détaille cette migration : même idée, syntaxe différente.',
              ),
              const ExerciseLinkBlock('ex-ajax-2'),
            ],
          ),
          CourseSection(
            id: 'ajax-8-5',
            moduleId: 'ajax',
            order: 5,
            title: 'Gérer le succès et les erreurs',
            blocks: [
              const ParagraphBlock(
                  'Toujours prévoir les deux issues : la **réussite** (success) et l\'**échec** (error). '
                  'Un utilisateur doit savoir ce qui se passe quand une requête échoue.'),
              const CodeBlock(
                '''\$.ajax({
  url: 'https://api.exemple.com/users',
  method: 'GET',
  success: function (data) {
    \$('#etat').text(data.length + ' utilisateurs chargés');
    \$('#liste').empty();
    data.forEach(function (u) {
      \$('<li>').text(u.name).appendTo('#liste');
    });
  },
  error: function (xhr, statut, erreur) {
    \$('#etat').text('Échec : ' + erreur + ' (statut ' + xhr.status + ')');
    \$('#etat').css('color', 'red');
  }
});''',
                explanation: 'success affiche les données, error affiche un message d\'erreur explicite.',
              ),
              const ParagraphBlock(
                  'Un **loader** donne aussi un retour visuel pendant l\'attente :'),
              const CodeBlock(
                '''\$('#loader').show();  // avant la requête
\$.get(url, function (data) {
  \$('#loader').hide();
  afficher(data);
}).fail(function () {
  \$('#loader').hide();
  \$('#erreur').show();
});''',
                explanation: 'On montre le loader, puis on le cache dans TOUS les cas (succès comme échec).',
              ),
              const WarningBlock(
                  'Oublier de cacher le loader dans le cas d\'erreur est une erreur très fréquente : '
                  'l\'écran reste bloqué sur « chargement… ».'),
              const ExerciseLinkBlock('ex-ajax-3'),
            ],
          ),
          CourseSection(
            id: 'ajax-8-6',
            moduleId: 'ajax',
            order: 6,
            title: 'Cas pratique : une liste d\'utilisateurs',
            blocks: [
              const ParagraphBlock('Assemblons tout ce que nous savons : un bouton charge des utilisateurs '
                  'depuis une API publique, puis les affiche.'),
              const CodeBlock(
                '''<!-- HTML -->
<button id="charger">Charger les utilisateurs</button>
<ul id="liste"></ul>
<p id="etat"></p>''',
                language: 'html',
                explanation: 'Le bouton déclenche, la liste reçoit, l\'état informe.',
              ),
              const CodeBlock(
                '''// JavaScript / jQuery
\$('#charger').on('click', function () {
  \$('#etat').text('Chargement…');
  \$.ajax({
    url: 'https://jsonplaceholder.typicode.com/users',
    method: 'GET',
    dataType: 'json',
    success: function (users) {
      \$('#liste').empty();
      users.forEach(function (user) {
        \$('<li>')
          .attr('data-id', user.id)
          .text(user.name + ' — ' + user.email)
          .appendTo('#liste');
      });
      \$('#etat').text(users.length + ' utilisateurs affichés');
    },
    error: function () {
      \$('#liste').empty();
      \$('#etat').text('Impossible de charger les données.');
    }
  });
});''',
                explanation: 'Le callback success construit les <li> ; error affiche un message. '
                    'C\'est le cœur du mini-projet « Liste dynamique d\'utilisateurs ».',
              ),
              const ParagraphBlock('À tester dans le laboratoire : copiez le HTML puis le JavaScript, '
                  'cliquez sur Exécuter, puis sur le bouton.'),
              const TipBlock(
                  'jsonplaceholder.typicode.com est une API publique gratuite parfaite pour apprendre : '
                  'aucune clé n\'est nécessaire.'),
            ],
          ),
          CourseSection(
            id: 'ajax-8-7',
            moduleId: 'ajax',
            order: 7,
            title: r"Raccourcis utiles : .serialize(), $.getJSON() et .load()",
            blocks: [
              const ParagraphBlock(
                  r"**.serialize()** rassemble les champs d'un formulaire en une seule ligne prête à envoyer."),
              const CodeBlock(
                r'''$('#form').on('submit', function (e) {
  e.preventDefault();
  $.post('/api/contact', $(this).serialize(), function () {
    $('#etat').text('Message envoyé');
  });
});''',
                explanation: r"On obtient par exemple nom=Alice&ville=Paris.",
              ),
              const WarningBlock(
                  r"Un champ sans attribut name est ignoré par serialize(), même s'il a un id."),
              const ParagraphBlock(
                  r"**$.getJSON()** est un $.get() qui attend du JSON. **.load()** insère du HTML reçu directement dans un élément."),
              const CodeBlock(
                r'''$.getJSON('/api/users', function (users) {
  console.log(users.length);
});

$('#contenu').load('/aide.html');
$('#contenu').load('/aide.html #intro'); // seulement #intro''',
                explanation: r"Avec un sélecteur après l'URL, load() n'insère que cette partie.",
              ),
              const WarningBlock(
                  r".load() insère du HTML tel quel : ne l'utilisez qu'avec votre propre serveur."),
              const ExerciseLinkBlock('ex-ajax-4'),
            ],
          ),
          CourseSection(
            id: 'ajax-8-8',
            moduleId: 'ajax',
            order: 8,
            title: r"Plusieurs requêtes : $.when() et abort()",
            blocks: [
              const ParagraphBlock(
                  r"Deux requêtes indépendantes peuvent partir **en même temps**. **$.when()** attend qu'elles soient toutes terminées."),
              const CodeBlock(
                r'''$.when($.get('/api/users'), $.get('/api/todos'))
  .done(function (users, todos) {
    console.log(users[0].length, todos[0].length);
  })
  .fail(function () {
    console.log('Au moins une requête a échoué');
  });''',
                explanation: r"Chaque résultat est un tableau [données, statut, xhr] : les données sont en [0].",
              ),
              const ParagraphBlock(
                  r"Une requête devenue inutile peut être **annulée**. C'est le cas d'une recherche, où seule la dernière frappe compte."),
              const CodeBlock(
                r'''let requete = null;

$('#recherche').on('input', function () {
  if (requete) {
    requete.abort(); // annule la précédente
  }
  requete = $.get('/api/search', { q: $(this).val() }, function (data) {
    console.log(data);
  });
});''',
                explanation: r"$.get() renvoie un objet xhr, qui possède la méthode abort().",
              ),
              const InfoBlock(
                  r"Une requête annulée passe par .fail() avec le statut « abort » : ne l'affichez pas comme une erreur."),
              const ExerciseLinkBlock('ex-ajax-5'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'http',
        number: 9,
        title: 'HTTP',
        subtitle: 'Les verbes, l\'URL, les en-têtes et les codes.',
        icon: Icons.http,
        sections: [
          CourseSection(
            id: 'http-9-1',
            moduleId: 'http',
            order: 1,
            title: 'Les verbes HTTP',
            blocks: [
              const ParagraphBlock(
                  'La **méthode** (ou verbe) HTTP indique l\'action souhaitée sur la ressource :'),
              const TableBlock(
                headers: ['Verbe', 'Action', 'Exemple d\'usage'],
                rows: [
                  ['GET', 'Lire', 'Récupérer la liste des utilisateurs'],
                  ['POST', 'Créer', 'Créer un nouvel utilisateur'],
                  ['PUT', 'Remplacer', 'Mettre à jour entièrement (ou créer)'],
                  ['PATCH', 'Modifier partiellement', 'Changer seulement l\'email'],
                  ['DELETE', 'Supprimer', 'Effacer un utilisateur'],
                ],
              ),
              const CodeBlock(
                '''// GET : je demande, je ne change rien
\$.get('https://api.exemple.com/users');

// POST : je crée
\$.post('https://api.exemple.com/users', { name: 'Alice' });

// PUT / PATCH / DELETE : via \$.ajax
\$.ajax({ url: '.../users/1', method: 'PUT', data: { name: 'Alice', email: 'a@b.fr' } });
\$.ajax({ url: '.../users/1', method: 'PATCH', data: { email: 'a@b.fr' } });
\$.ajax({ url: '.../users/1', method: 'DELETE' });''',
                explanation: 'Le verbe est passé à method dans \$.ajax().',
              ),
              const InfoBlock(
                  'GET ne doit jamais avoir d\'effet de bord (création, modification). C\'est la première '
                  'règle d\'hygiène d\'une API bien construite.'),
              const ExerciseLinkBlock('ex-http-1'),
            ],
          ),
          CourseSection(
            id: 'http-9-2',
            moduleId: 'http',
            order: 2,
            title: 'URL, endpoint et query parameters',
            blocks: [
              const ParagraphBlock(
                  'Une **URL** découpe en plusieurs parties :'),
              const CodeBlock(
                '''https://example.com:443/api/users?page=2&limit=10
|--------|---------------|------|-----------|---------------|
 schéma      domaine/hôte    port    chemin       requête (query)

https        : protocole sécurisé
example.com  : le serveur
/api/users   : le chemin (l'endpoint)
?page=2&limit=10 : les query parameters''',
                language: 'text',
                explanation: 'Chaque partie a un rôle précis dans la requête.',
              ),
              const ParagraphBlock(
                  'Un **endpoint** est une URL précise du serveur qui expose une ressource ou une action. '
                  'Exemples d\'endpoints REST :'),
              const BulletsBlock([
                'GET    /api/users → la liste des utilisateurs',
                'POST   /api/users → créer un utilisateur',
                'GET    /api/users/7 → l\'utilisateur n° 7',
                'DELETE /api/users/7 → le supprimer',
              ]),
              const ParagraphBlock('Les **query parameters** filtrent ou paramètrent la requête :'),
              const CodeBlock(
                '''\$.get('https://example.com/api/users?page=2&limit=10', function (data) {
  console.log(data);
});

// Ou bien avec \$.param()
\$.get('https://example.com/api/users', { page: 2, limit: 10 }, function (data) {
  console.log(data);
});''',
                explanation: 'jQuery construit la chaîne de requête à partir d\'un objet.',
              ),
              const TipBlock(
                  'Les query parameters sont surtout utilisés avec GET. Pour les données à créer ou '
                  'modifier, on utilise le corps de la requête.'),
            ],
          ),
          CourseSection(
            id: 'http-9-3',
            moduleId: 'http',
            order: 3,
            title: 'Headers, body et JSON',
            blocks: [
              const ParagraphBlock(
                  'Les **headers** (en-têtes) sont des métadonnées envoyées avec la requête : '
                  'type de contenu, autorisation, langue, etc.'),
              const TableBlock(
                headers: ['Header', 'Rôle'],
                rows: [
                  ['Content-Type', 'Type du corps envoyé (ex. application/json)'],
                  ['Accept', 'Type de réponse souhaité'],
                  ['Authorization', 'Jeton d\'authentification'],
                  ['User-Agent', 'Identifie le client'],
                ],
              ),
              const ParagraphBlock('Le **body** est le contenu transporté : souvent du JSON pour POST/PUT/PATCH.'),
              const CodeBlock(
                '''\$.ajax({
  url: 'https://api.exemple.com/users',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  data: JSON.stringify({
    name: 'Alice',
    email: 'alice@example.com'
  }),
  success: function (reponse) { console.log(reponse); }
});''',
                explanation: 'Le corps est un objet converti en JSON avec JSON.stringify().',
              ),
              const WarningBlock(
                  'Quand vous envoyez du JSON, pensez toujours à JSON.stringify() sur l\'objet ET à '
                  'Content-Type: application/json. Sans cela, le serveur peut ne pas lire votre corps.'),
              const ExerciseLinkBlock('ex-http-2'),
            ],
          ),
          CourseSection(
            id: 'http-9-4',
            moduleId: 'http',
            order: 4,
            title: 'Authentification et token',
            blocks: [
              const ParagraphBlock(
                  'De nombreuses API exigent une **authentification**. La méthode la plus répandue est le '
                  '**token** (ou Bearer token) envoyé dans un header Authorization.'),
              const CodeBlock(
                '''\$.ajax({
  url: 'https://api.exemple.com/me',
  method: 'GET',
  headers: {
    'Authorization': 'Bearer VOTRE_TOKEN'
  },
  success: function (data) { console.log(data); }
});''',
                explanation: 'Le serveur vérifie le token et identifie l\'utilisateur.',
              ),
              const ParagraphBlock(
                  'Le serveur renvoie généralement un token après une connexion réussie, puis le client '
                  'le renvoie à chaque requête.'),
              const WarningBlock(
                  'NE mettez JAMAIS une clé API ou un token en dur dans le code source d\'une application '
                  'cliente : n\'importe qui peut décompiler l\'application et lire la clé. Les secrets '
                  'doivent vivre côté serveur.',
              ),
              const InfoBlock(
                  'Pour apprendre, privilégiez les API publiques sans secret : c\'est le cas de toutes '
                  'les démonstrations de cette application.'),
              const ExerciseLinkBlock('ex-http-3'),
              const ExerciseLinkBlock('ex-http-6'),
            ],
          ),
          CourseSection(
            id: 'http-9-5',
            moduleId: 'http',
            order: 5,
            title: 'Timeout et erreurs réseau',
            blocks: [
              const ParagraphBlock(
                  'Un **timeout** est le délai maximum accordé à une requête. Au-delà, on abandonne et '
                  'on prévient l\'utilisateur.'),
              const CodeBlock(
                '''\$.ajax({
  url: 'https://api.lente.exemple.com/data',
  method: 'GET',
  timeout: 5000, // 5 secondes maximum
  success: function (data) { console.log(data); },
  error: function (xhr, statut) {
    if (statut === 'timeout') {
      console.log('La requête a dépassé le délai.');
    } else {
      console.log('Erreur réseau :', statut);
    }
  }
});''',
                explanation: 'timeout: 5000 coupe la requête au bout de 5 s et déclenche error.',
              ),
              const BulletsBlock([
                '**Pas de connexion** : statut « error » immédiat.',
                '**Délai dépassé** : statut « timeout ».',
                '**Serveur injoignable** : statut « error », parfois 502/503 côté serveur.',
                '**URL invalide** : la requête échoue dès le départ.',
              ]),
              const ParagraphBlock(
                  'La gestion des erreurs réseau fait partie de la qualité d\'une application : '
                  'testez systématiquement le mode hors connexion de vos interfaces.'),
              const TipBlock(
                  'L\'explorateur AJAX de cette application traduit chaque échec en message pédagogique : '
                  'vous y verrez ces cas en conditions réelles.'),
            ],
          ),
          CourseSection(
            id: 'http-9-6',
            moduleId: 'http',
            order: 6,
            title: 'Les codes HTTP essentiels',
            blocks: [
              const ParagraphBlock(
                  'La réponse HTTP commence par un **code de statut** sur 3 chiffres, qui résume '
                  'l\'issue de la requête.'),
              const TableBlock(
                headers: ['Code', 'Signification', 'Quand'],
                rows: [
                  ['200', 'OK', 'Tout s\'est bien passé'],
                  ['201', 'Créé', 'Ressource créée (POST)'],
                  ['204', 'Sans contenu', 'Action réussie sans corps (DELETE)'],
                  ['400', 'Requête invalide', 'Le client a envoyé quelque chose d\'incorrect'],
                  ['401', 'Non authentifié', 'Il faut se connecter / fournir un token'],
                  ['403', 'Interdit', 'Authentifié mais pas le droit'],
                  ['404', 'Introuvable', 'La ressource n\'existe pas'],
                  ['409', 'Conflit', 'Conflit (ex. email déjà utilisé)'],
                  ['429', 'Trop de requêtes', 'Limite de débit dépassée'],
                  ['500', 'Erreur serveur', 'Le serveur a planté'],
                  ['502', 'Passerelle invalide', 'Un intermédiaire ne répond pas'],
                  ['503', 'Service indisponible', 'Serveur surchargé / en maintenance'],
                ],
              ),
              const ParagraphBlock(
                  'Repérez la famille par le premier chiffre : 2xx = succès, 3xx = redirection, '
                  '4xx = erreur du client, 5xx = erreur du serveur.'),
              const CodeBlock(
                '''\$.ajax({
  url: 'https://jsonplaceholder.typicode.com/users/999',
  method: 'GET',
  error: function (xhr) {
    // 404 ici
    console.log('Code', xhr.status, ':', xhr.statusText);
  }
});''',
                explanation: 'Un identifiant inexistant renvoie 404 : à vous d\'afficher un message clair.',
              ),
              const ExerciseLinkBlock('ex-http-4'),
            ],
          ),
          CourseSection(
            id: 'http-9-7',
            moduleId: 'http',
            order: 7,
            title: r"CORS : pourquoi ma requête est-elle bloquée ?",
            blocks: [
              const ParagraphBlock(
                  r"Par sécurité, une page ne peut lire la réponse d'un **autre domaine** que si ce serveur l'autorise. Ce mécanisme s'appelle **CORS**."),
              const CodeBlock(
                r'''HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://monsite.fr''',
                language: 'http',
                explanation: r"Le serveur autorise les pages de monsite.fr à lire sa réponse. Une étoile (*) autorise tous les sites.",
              ),
              const ParagraphBlock(
                  r"Sans cet en-tête, la console affiche une erreur CORS et jQuery appelle error avec un statut 0."),
              const CodeBlock(
                r'''$.get('https://api.exemple.com/data').fail(function (xhr) {
  if (xhr.status === 0) {
    console.log('Réseau coupé, ou requête bloquée (CORS)');
  }
});''',
                explanation: r"Le code ne peut pas distinguer les deux cas : regardez la console du navigateur.",
              ),
              const ParagraphBlock(
                  r"Pour certaines requêtes (PUT, DELETE, corps JSON, en-tête Authorization…), le navigateur envoie d'abord une requête **OPTIONS** de vérification."),
              const WarningBlock(
                  r"CORS se règle sur le serveur. Aucun code jQuery ne peut l'autoriser à sa place."),
              const InfoBlock(
                  r"L'explorateur AJAX de l'application n'est pas un navigateur : il n'est pas soumis à CORS. Le laboratoire, lui, l'est."),
              const ExerciseLinkBlock('ex-http-6'),
            ],
          ),
          CourseSection(
            id: 'http-9-8',
            moduleId: 'http',
            order: 8,
            title: r"Encoder une URL : encodeURIComponent()",
            blocks: [
              const ParagraphBlock(
                  r"Dans une URL, certains caractères ont un **rôle spécial** : & sépare les paramètres, ? commence la requête, # désigne une ancre. Un texte libre doit donc être encodé."),
              const CodeBlock(
                r'''const texte = 'café & thé';

// Incorrect : le & coupe le paramètre en deux
$.get('/api/search?q=' + texte);

// Correct
$.get('/api/search?q=' + encodeURIComponent(texte));
// → /api/search?q=caf%C3%A9%20%26%20th%C3%A9''',
                explanation: r"Chaque caractère spécial devient un code précédé de %.",
              ),
              const ParagraphBlock(
                  r"Avec un objet de paramètres, jQuery encode **pour vous** :"),
              const CodeBlock(
                r'''$.get('/api/search', { q: texte, page: 2 });''',
                explanation: r"C'est la forme la plus simple et la plus sûre.",
              ),
              const TipBlock(
                  r"decodeURIComponent() fait l'opération inverse."),
              const ExerciseLinkBlock('ex-http-5'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'json',
        number: 10,
        title: 'JSON',
        subtitle: 'Le format universel d\'échange de données.',
        icon: Icons.data_object,
        sections: [
          CourseSection(
            id: 'json-10-1',
            moduleId: 'json',
            order: 1,
            title: 'Le format JSON',
            blocks: [
              const ParagraphBlock(
                  '**JSON** (JavaScript Object Notation) est un format de texte qui décrit des données '
                  'de façon universelle : presque tous les langages savent le lire et l\'écrire.'),
              const CodeBlock(
                '''{
  "id": 1,
  "name": "Alice",
  "email": "alice@example.com"
}''',
                language: 'json',
                explanation: 'Un objet JSON : des paires clé-valeur entre accolades.',
              ),
              const BulletsBlock([
                'Les **clés** sont toujours entre guillemets doubles.',
                'Les **valeurs** peuvent être : chaîne, nombre, booléen, null, tableau ou objet.',
                'Un fichier JSON est du simple texte : facile à échanger, à lire, à déboguer.',
              ]),
              const ParagraphBlock(
                  'En jQuery, la réponse d\'une requête AJAX est automatiquement convertie en objet '
                  'JavaScript si le serveur envoie du JSON.'),
              const TipBlock(
                  'JSON ressemble à un objet JavaScript, mais il est toujours représenté sous forme de '
                  'texte pendant le transport. C\'est ce texte que l\'on convertit.'),
            ],
          ),
          CourseSection(
            id: 'json-10-2',
            moduleId: 'json',
            order: 2,
            title: 'Objets et tableaux',
            blocks: [
              const ParagraphBlock('Un **objet** décrit une chose ; un **tableau** liste plusieurs choses.'),
              const CodeBlock(
                '''// Un objet : une personne
{
  "name": "Alice",
  "age": 30
}

// Un tableau : plusieurs personnes
[
  { "name": "Alice", "age": 30 },
  { "name": "Bob", "age": 25 }
]''',
                language: 'json',
                explanation: 'Un objet entre {}, un tableau entre []. Les deux se combinent librement.',
              ),
              const ParagraphBlock(
                  'Le format le plus courant des API : un **tableau d\'objets**, c\'est-à-dire une liste '
                  'de ressources.'),
              const CodeBlock(
                '''[
  { "id": 1, "title": "Apprendre JSON" },
  { "id": 2, "title": "Apprendre AJAX" }
]''',
                language: 'json',
                explanation: 'Chaque élément du tableau est un objet avec des clés communes.',
              ),
              const TipBlock(
                  'Lisez un tableau comme une ligne de bus : chaque siège est un objet. La même structure '
                  'se répète d\'un élément à l\'autre.'),
              const ExerciseLinkBlock('ex-json-1'),
            ],
          ),
          CourseSection(
            id: 'json-10-3',
            moduleId: 'json',
            order: 3,
            title: 'Clés, valeurs et types',
            blocks: [
              const ParagraphBlock('Chaque paire **clé : valeur** suit une règle simple.'),
              const CodeBlock(
                '''{
  "name": "Alice",          // chaîne (string)
  "age": 30,                // nombre (number)
  "admin": true,            // booléen (boolean)
  "adresse": null,          // null
  "tags": ["js", "web"],    // tableau
  "profil": {               // objet imbriqué
    "bio": "Développeuse"
  }
}''',
                language: 'json',
                explanation: 'Les six types JSON possibles, dans un seul objet.',
              ),
              const TableBlock(
                headers: ['Type', 'Exemple', 'Note'],
                rows: [
                  ['chaîne', '"Alice"', 'Toujours entre guillemets doubles'],
                  ['nombre', '30', 'Pas de guillemets'],
                  ['booléen', 'true', 'Pas de guillemets'],
                  ['null', 'null', 'Absence de valeur'],
                  ['tableau', '[1, 2, 3]', 'Liste entre crochets'],
                  ['objet', '{…}', 'Sous-structure entre accolades'],
                ],
              ),
              const WarningBlock(
                  'Une virgule en trop après le dernier élément, ou une clé sans guillemets : le JSON '
                  'devient invalide et la réponse ne pourra pas être lue.'),
              const ExerciseLinkBlock('ex-json-2'),
            ],
          ),
          CourseSection(
            id: 'json-10-4',
            moduleId: 'json',
            order: 4,
            title: 'Objets imbriqués et tableaux d\'objets',
            blocks: [
              const ParagraphBlock('La vraie vie des API : les structures s\'emboîtent. Apprenons à lire '
                  'une réponse typique.'),
              const CodeBlock(
                '''{
  "user": {
    "id": 7,
    "name": "Bob",
    "company": { "name": "Acme" }
  },
  "posts": [
    { "id": 1, "title": "Premier post" },
    { "id": 2, "title": "Second post" }
  ],
  "totalPosts": 2
}''',
                language: 'json',
                explanation: 'user est un objet, company est un objet dans user, posts est un tableau d\'objets.',
              ),
              const ParagraphBlock('En JavaScript, on descend dans la structure avec des points ou des crochets :'),
              const CodeBlock(
                '''// À l'intérieur du callback success, data est l'objet ci-dessus :
data.user.name              // → "Bob"
data.user.company.name      // → "Acme"
data.posts[0].title         // → "Premier post"
data.posts[1].id            // → 2
data.totalPosts             // → 2

// Parcourir un tableau :
data.posts.forEach(function (post) {
  console.log(post.id, post.title);
});''',
                explanation: 'Chaque point descend d\'un niveau dans la structure.',
              ),
              const ConceptCardBlock(
                icon: Icons.account_tree,
                title: 'La lecture de droite à gauche',
                text: 'data.posts[0].title se lit : « la variable data, son champ posts, son premier '
                    'élément, son champ title ».',
              ),
              const ExerciseLinkBlock('ex-json-3'),
            ],
          ),
          CourseSection(
            id: 'json-10-5',
            moduleId: 'json',
            order: 5,
            title: 'parse() et stringify()',
            blocks: [
              const ParagraphBlock(
                  'Deux fonctions JavaScript convertissent entre texte JSON et objet :'),
              const CodeBlock(
                '''// Texte → objet : JSON.parse
const texte = '{"name":"Alice","age":30}';
const objet = JSON.parse(texte);
console.log(objet.name); // → "Alice"

// Objet → texte : JSON.stringify
const texte2 = JSON.stringify(objet);
console.log(texte2); // → {"name":"Alice","age":30}''',
                explanation: 'parse lit du texte, stringify écrit du texte.',
              ),
              const ParagraphBlock(
                  'Ces deux fonctions sont les seuls « traducteurs » entre le monde du transport (texte) '
                  'et celui du code (objets) :'),
              const StepsBlock(
                title: 'Le voyage d\'un objet',
                steps: [
                  'Un objet vit dans votre code',
                  'JSON.stringify() le transforme en texte pour la requête',
                  'Le serveur le traite et renvoie du texte JSON',
                  'JSON.parse() (ou jQuery automatiquement) le retransforme en objet',
                ],
              ),
              const TipBlock(
                  'Avec \$.ajax(), jQuery appelle JSON.parse() pour vous quand le serveur annonce du JSON. '
                  'Avec fetch(), c\'est vous qui appelez response.json().'),
              const ExerciseLinkBlock('ex-json-4'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'rest',
        number: 11,
        title: 'API REST',
        subtitle: 'Comment les serveurs exposent leurs ressources.',
        icon: Icons.account_tree,
        sections: [
          CourseSection(
            id: 'rest-11-1',
            moduleId: 'rest',
            order: 1,
            title: 'API : qu\'est-ce qu\'une interface ?',
            blocks: [
              const ParagraphBlock(
                  'Une **API** (Application Programming Interface) est un **contrat** qui définit comment '
                  'des programmes échangent des données. Elle dit : « pour obtenir telle chose, fais telle '
                  'requête ».'),
              const ConceptCardBlock(
                icon: Icons.architecture,
                title: 'La métaphore du restaurant',
                text: 'Vous (le client) parlez à la carte (l\'API) ; le serveur n\'est pas la cuisine, '
                    'mais le garçon qui traduit vos demandes. L\'API protège la cuisine (les données internes).',
              ),
              const ParagraphBlock('Une API web est un ensemble d\'**endpoints** accessibles par HTTP. '
                  'Chaque endpoint attend un verbe, des paramètres, et renvoie une réponse structurée.'),
              const CodeBlock(
                '''// Exemple d'API : jsonplaceholder.typicode.com
// GET https://jsonplaceholder.typicode.com/users → liste des utilisateurs
// GET https://jsonplaceholder.typicode.com/users/1 → l'utilisateur n° 1''',
                language: 'text',
                explanation: 'Le chemin décrit la ressource ; l\'URL entière est l\'endpoint.',
              ),
            ],
          ),
          CourseSection(
            id: 'rest-11-2',
            moduleId: 'rest',
            order: 2,
            title: 'REST et les resources',
            blocks: [
              const ParagraphBlock(
                  '**REST** (Representational State Transfer) est une **architecture** qui organise une API '
                  'autour de **ressources** identifiées par des URL, manipulées avec les verbes HTTP.'),
              const ParagraphBlock('Une **ressource** est un objet métier : un utilisateur, un article, '
                  'une commande… Chaque ressource possède son endpoint.'),
              const TableBlock(
                headers: ['Ressource', 'Endpoint', 'Verbes utiles'],
                rows: [
                  ['Utilisateurs', '/api/users', 'GET, POST'],
                  ['Un utilisateur', '/api/users/{id}', 'GET, PUT, PATCH, DELETE'],
                  ['Articles', '/api/posts', 'GET, POST'],
                  ['Un article', '/api/posts/{id}', 'GET, PUT, PATCH, DELETE'],
                ],
              ),
              const ParagraphBlock(
                  'Le nom de la ressource est un **nom au pluriel** en général, et l\'identifiant est un '
                  'segment de l\'URL. C\'est une convention, mais elle est très répandue.'),
              const TipBlock(
                  'Si vous voyez /api/users et /api/users/7, pensez « la collection » et « un élément de '
                  'la collection ». Toute la suite est mécanique.'),
              const ExerciseLinkBlock('ex-rest-1'),
            ],
          ),
          CourseSection(
            id: 'rest-11-3',
            moduleId: 'rest',
            order: 3,
            title: 'CRUD et les verbes HTTP',
            blocks: [
              const ParagraphBlock(
                  'La grande majorité des API REST couvrent les quatre opérations de base sur une '
                  'ressource : le **CRUD**.'),
              const TableBlock(
                headers: ['Opération', 'Verbe HTTP', 'Endpoint', 'Exemple'],
                rows: [
                  ['CREATE (créer)', 'POST', '/api/users', 'Créer un utilisateur'],
                  ['READ (lire)', 'GET', '/api/users ou /api/users/7', 'Lire la liste ou un élément'],
                  ['UPDATE (mettre à jour)', 'PUT / PATCH', '/api/users/7', 'Remplacer / modifier'],
                  ['DELETE (supprimer)', 'DELETE', '/api/users/7', 'Effacer'],
                ],
              ),
              const CodeBlock(
                '''// CREATE
\$.post('/api/users', { name: 'Alice' });

// READ
\$.get('/api/users');
\$.get('/api/users/7');

// UPDATE
\$.ajax({ url: '/api/users/7', method: 'PUT', data: { name: 'Alice', email: 'a@b.fr' } });
\$.ajax({ url: '/api/users/7', method: 'PATCH', data: { email: 'a@b.fr' } });

// DELETE
\$.ajax({ url: '/api/users/7', method: 'DELETE' });''',
                explanation: 'Les quatre opérations CRUD correspondent aux quatre familles de verbes.',
              ),
              const ConceptCardBlock(
                icon: Icons.track_changes,
                title: 'La correspondance à retenir',
                text: 'CREATE → POST · READ → GET · UPDATE → PUT/PATCH · DELETE → DELETE.',
              ),
              const ExerciseLinkBlock('ex-rest-2'),
            ],
          ),
          CourseSection(
            id: 'rest-11-4',
            moduleId: 'rest',
            order: 4,
            title: 'Bonnes pratiques d\'une API REST',
            blocks: [
              const ParagraphBlock('Voici les réflexes d\'un bon consommateur d\'API :'),
              const BulletsBlock([
                'Utiliser le verbe adapté : GET pour lire, jamais pour modifier.',
                'Lire la **documentation** : endpoints, formats attendus, codes d\'erreur.',
                'Toujours gérer les **erreurs** (4xx, 5xx) avec un message clair.',
                'Afficher un **loader** pendant les requêtes.',
                'Ne jamais stocker de **clé secrète** dans le code client.',
                'Respecter les **limites de débit** (429) et les délais.',
              ]),
              const CodeBlock(
                '''// Un appel propre : loader + succès + erreur + état final
\$('#btn').on('click', function () {
  \$('#loader').show();
  \$.get('/api/users')
    .done(function (data) {
      afficher(data);
    })
    .fail(function (xhr) {
      \$('#erreur').text('Erreur ' + xhr.status).show();
    })
    .always(function () {
      \$('#loader').hide(); // dans TOUS les cas
    });
});''',
                explanation: 'done/fail/always couvrent succès, échec et fin — le trio gagnant.',
              ),
              const TipBlock(
                  'Un bon consommateur d\'API écrit d\'abord la gestion d\'erreur, ensuite le succès : '
                  'c\'est l\'ordre qui protège l\'utilisateur.'),
              const ExerciseLinkBlock('ex-rest-4'),
            ],
          ),
          CourseSection(
            id: 'rest-11-5',
            moduleId: 'rest',
            order: 5,
            title: 'Le cycle CRUD complet : une to-do list',
            blocks: [
              const ParagraphBlock('Assemblons CRUD + AJAX dans l\'exemple le plus pédagogique : une '
                  'to-do list connectée à une API.'),
              const CodeBlock(
                '''// 1. LIRE les tâches (GET)
function chargerTaches() {
  \$.get('/api/todos', function (todos) {
    \$('#liste').empty();
    todos.forEach(function (t) {
      \$('<li>').attr('data-id', t.id).text(t.title).appendTo('#liste');
    });
  });
}

// 2. CRÉER (POST)
\$('#form').on('submit', function (e) {
  e.preventDefault();
  \$.post('/api/todos', { title: \$('#titre').val(), done: false }, chargerTaches);
});

// 3. METTRE À JOUR (PATCH)
\$('#liste').on('click', 'li', function () {
  var id = \$(this).data('id');
  \$.ajax({ url: '/api/todos/' + id, method: 'PATCH', data: { done: true } });
});

// 4. SUPPRIMER (DELETE)
\$('#liste').on('click', '.supprimer', function () {
  var id = \$(this).closest('li').data('id');
  \$.ajax({ url: '/api/todos/' + id, method: 'DELETE', success: chargerTaches });
});''',
                explanation: 'Les quatre opérations CRUD, chacune avec le verbe HTTP approprié.',
              ),
              const ParagraphBlock(
                  'Vous venez de dessiner le plan d\'une application complète. Le mini-projet « To-do '
                  'list jQuery » et le projet final reprendront exactement ce schéma.'),
              const ExerciseLinkBlock('ex-rest-3'),
              const ExerciseLinkBlock('ex-rest-5'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'modern',
        number: 12,
        title: 'jQuery vs JavaScript moderne',
        subtitle: 'Promises, Fetch, async/await : la suite logique.',
        icon: Icons.rocket_launch,
        sections: [
          CourseSection(
            id: 'modern-12-1',
            moduleId: 'modern',
            order: 1,
            title: 'Les Promises',
            blocks: [
              const ParagraphBlock(
                  'Une **Promise** est un objet qui représente le résultat **futur** d\'une opération '
                  'asynchrone. Elle promet de donner soit une valeur, soit une erreur, plus tard.'),
              const CodeBlock(
                '''// Créer une Promise
const maPromesse = new Promise(function (resoudre, rejeter) {
  setTimeout(function () {
    resoudre('Données prêtes !'); // ou rejeter('Une erreur')
  }, 1000);
});

// L'utiliser
maPromesse.then(function (valeur) {
  console.log(valeur);
}).catch(function (erreur) {
  console.error(erreur);
});''',
                explanation: 'resoudre appelle then, rejeter appelle catch. C\'est un contrat en 3 états : '
                    'en attente, réussie, échouée.',
              ),
              const ParagraphBlock(
                  'jQuery (avant ses versions récentes) utilisait des callbacks. JavaScript moderne '
                  'standardise tout autour des Promises : c\'est plus uniforme et composable.'),
              const ConceptCardBlock(
                icon: Icons.hourglass_top,
                title: 'L\'essentiel',
                text: 'Une Promise évite les callbacks imbriqués : on enchaîne avec .then() et on gère '
                    'l\'échec avec .catch().',
              ),
            ],
          ),
          CourseSection(
            id: 'modern-12-2',
            moduleId: 'modern',
            order: 2,
            title: 'La Fetch API',
            blocks: [
              const ParagraphBlock(
                  '**fetch()** est la fonction native du navigateur pour effectuer des requêtes HTTP. '
                  'Elle remplace \$.ajax() dans le JavaScript moderne.'),
              const CodeBlock(
                '''// La même requête qu'avec \$.get()
fetch('https://jsonplaceholder.typicode.com/users')
  .then(function (response) {
    return response.json(); // extrait le corps JSON
  })
  .then(function (data) {
    console.log(data); // les utilisateurs
  });''',
                explanation: 'fetch renvoie une Promise. Le premier then récupère la réponse, le second les données.',
              ),
              const ParagraphBlock('Pour envoyer des données avec un autre verbe :'),
              const CodeBlock(
                '''fetch('https://jsonplaceholder.typicode.com/posts', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ title: 'Mon post', body: 'Contenu' })
}).then(function (response) {
  return response.json();
}).then(function (post) {
  console.log('Créé :', post.id);
});''',
                explanation: 'La configuration de la requête passe dans le second argument de fetch().',
              ),
              const ComparisonBlock(
                title: 'GET : la comparaison directe',
                jquery: '''\$.get('/api/users', function (data) {
  console.log(data);
});''',
                modern: '''fetch('/api/users')
  .then(response => response.json())
  .then(data => console.log(data));''',
                note: 'jQuery résout la conversion JSON automatiquement ; avec fetch, on l\'écrit soi-même.',
              ),
              const WarningBlock(
                  'fetch() ne rejette la promesse que pour les erreurs réseau. Un code HTTP 404 est '
                  'considéré comme une « réponse » : il faut vérifier response.ok. Vous le verrez au '
                  'module suivant.'),
            ],
          ),
          CourseSection(
            id: 'modern-12-3',
            moduleId: 'modern',
            order: 3,
            title: 'then() et catch()',
            blocks: [
              const ParagraphBlock(
                  'La chaîne .then() transforme les résultats étape par étape, et .catch() intercepte '
                  'n\'importe quelle erreur rencontrée en chemin.'),
              const CodeBlock(
                '''fetch('https://api.exemple.com/users')
  .then(function (response) {
    if (!response.ok) {
      throw new Error('Erreur HTTP ' + response.status);
    }
    return response.json();
  })
  .then(function (data) {
    afficher(data);
  })
  .catch(function (erreur) {
    console.error('Quelque chose a échoué :', erreur.message);
  });''',
                explanation: 'throw dans un then saute directement dans catch : une seule gestion d\'erreur pour toute la chaîne.',
              ),
              const ParagraphBlock(
                  'L\'équivalent jQuery utilise success/error ; l\'équivalent moderne utilise then/catch. '
                  'La logique est identique, seule la syntaxe change.'),
              const ExerciseLinkBlock('ex-modern-1'),
            ],
          ),
          CourseSection(
            id: 'modern-12-4',
            moduleId: 'modern',
            order: 4,
            title: 'async et await : du code synchrone qui respire',
            blocks: [
              const ParagraphBlock(
                  '**async** marque une fonction comme asynchrone. **await** met la lecture en pause '
                  'jusqu\'au résultat d\'une Promise. Le code devient linéaire, plus facile à lire.'),
              const CodeBlock(
                '''async function chargerUtilisateurs() {
  const response = await fetch('/api/users');
  const data = await response.json();
  console.log(data);
}

chargerUtilisateurs();''',
                explanation: 'await attend le résultat de fetch, puis du json() : l\'ordre de lecture '
                    'suit l\'ordre d\'exécution.',
              ),
              const ComparisonBlock(
                title: 'Le même code : callbacks vs await',
                jquery: '''\$.get('/api/users', function (data) {
  console.log(data);
});''',
                modern: '''const response = await fetch('/api/users');
const data = await response.json();
console.log(data);''',
                note: 'Les deux lignes du dessous s\'exécutent dans l\'ordre, sans imbrication.',
              ),
              const TipBlock(
                  'await ne fonctionne que dans une fonction déclarée async. Si vous oubliez async, '
                  'vous obtenez une erreur de syntaxe.'),
              const ExerciseLinkBlock('ex-modern-2'),
            ],
          ),
          CourseSection(
            id: 'modern-12-5',
            moduleId: 'modern',
            order: 5,
            title: 'try / catch avec await',
            blocks: [
              const ParagraphBlock(
                  'Comme dans tout langage, **try/catch** attrape les erreurs autour de code qui peut '
                  'échouer. Avec await, c\'est le modèle à retenir :'),
              const CodeBlock(
                '''async function charger() {
  try {
    const response = await fetch('https://api.exemple.com/users');
    if (!response.ok) {
      throw new Error('Erreur HTTP ' + response.status);
    }
    const data = await response.json();
    afficher(data);
  } catch (erreur) {
    console.error('Échec du chargement :', erreur.message);
    afficherErreur(erreur.message);
  }
}''',
                explanation: 'Tout ce qui échoue (réseau, HTTP non-OK, JSON invalide) est attrapé par catch.',
              ),
              const ParagraphBlock(
                  'Cette fonction fait exactement ce que \$.ajax() faisait avec success et error : '
                  'tentative, vérification, succès, erreur — mais avec un code linéaire.'),
              const ComparisonBlock(
                title: 'Gestion d\'erreur : jQuery vs moderne',
                jquery: '''\$.ajax({
  url: '/api/users',
  success: function (d) { afficher(d); },
  error: function () { afficherErreur(); }
});''',
                modern: '''try {
  const r = await fetch('/api/users');
  if (!r.ok) throw new Error('HTTP ' + r.status);
  afficher(await r.json());
} catch (e) {
  afficherErreur(e.message);
}''',
                note: 'try/catch regroupe tous les cas d\'échec en un seul endroit.',
              ),
              const ExerciseLinkBlock('ex-modern-3'),
            ],
          ),
          CourseSection(
            id: 'modern-12-6',
            moduleId: 'modern',
            order: 6,
            title: 'Tableau de correspondance jQuery ↔ moderne',
            blocks: [
              const ParagraphBlock('Votre aide-mémoire pour migrer de jQuery vers le JavaScript moderne :'),
              const TableBlock(
                headers: ['Besoin', 'jQuery', 'JavaScript moderne'],
                rows: [
                  ['Sélectionner un élément', '\$("#x")', 'document.querySelector("#x")'],
                  ['Sélectionner plusieurs', '\$(".x")', 'document.querySelectorAll(".x")'],
                  ['Changer le texte', '\$("#x").text("hi")', 'el.textContent = "hi"'],
                  ['Changer le HTML', '\$("#x").html("…")', 'el.innerHTML = "…"'],
                  ['Lire une valeur', '\$("#x").val()', 'el.value'],
                  ['Ajouter une classe', '\$("#x").addClass("a")', 'el.classList.add("a")'],
                  ['Retirer une classe', '\$("#x").removeClass("a")', 'el.classList.remove("a")'],
                  ['Cacher un élément', '\$("#x").hide()', 'el.style.display = "none"'],
                  ['Écouter un clic', '\$("#x").on("click", f)', 'el.addEventListener("click", f)'],
                  ['Requête GET', '\$.get(url, cb)', 'fetch(url).then(r => r.json())'],
                  ['Requête complète', '\$.ajax({…})', 'fetch(url, {method, headers, body})'],
                ],
              ),
              const ParagraphBlock(
                  'La bonne nouvelle : vous n\'apprenez pas deux mondes différents. Vous apprenez les '
                  '**mêmes concepts** (sélection, événements, requêtes), sous deux syntaxes. Les concepts '
                  'du DOM, d\'AJAX, de JSON et de REST que vous avez appris ici vous servent dans les deux.'),
              const ConceptCardBlock(
                icon: Icons.emoji_objects,
                title: 'Que retenir',
                text: 'jQuery = concision historique. Moderne = standard du navigateur. Maîtrisez les '
                    'concepts, et les deux syntaxes ne seront plus que des détails.',
              ),
            ],
          ),
          CourseSection(
            id: 'modern-12-7',
            moduleId: 'modern',
            order: 7,
            title: r"Promise.all() et FormData",
            blocks: [
              const ParagraphBlock(
                  r"**Promise.all()** lance plusieurs opérations en parallèle et attend qu'elles aient **toutes** réussi."),
              const CodeBlock(
                r'''async function charger() {
  const [r1, r2] = await Promise.all([
    fetch('/api/users'),
    fetch('/api/todos')
  ]);
  const users = await r1.json();
  const todos = await r2.json();
  console.log(users.length, todos.length);
}''',
                explanation: r"Les résultats arrivent dans l'ordre du tableau, quelle que soit la requête la plus rapide.",
              ),
              const WarningBlock(
                  r"Si une seule Promise échoue, Promise.all() échoue aussi : entourez-le de try / catch."),
              const ParagraphBlock(
                  r"**FormData** regroupe les champs d'un formulaire, **fichiers compris**."),
              const CodeBlock(
                r'''const form = document.querySelector('#form');
const donnees = new FormData(form);

fetch('/api/contact', { method: 'POST', body: donnees });''',
                explanation: r"Ne fixez pas Content-Type : le navigateur le choisit lui-même pour un FormData.",
              ),
              const InfoBlock(
                  r"Équivalents jQuery : $.when() pour Promise.all(), et .serialize() pour un formulaire sans fichier."),
              const ExerciseLinkBlock('ex-modern-4'),
            ],
          ),
        ],
      ),
    ];
