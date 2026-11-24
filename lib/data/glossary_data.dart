import '../models/snippet.dart';

/// Glossaire des termes essentiels.
List<GlossaryEntry> allGlossary() => const [
      GlossaryEntry(
        term: 'AJAX',
        definition: 'Asynchronous JavaScript And XML : technique d\'échange de données avec un serveur '
            'sans recharger la page. Les données modernes sont au format JSON.',
        example: '\$.get(url, callback) ou fetch(url)',
      ),
      GlossaryEntry(
        term: 'API',
        definition: 'Application Programming Interface : contrat qui définit comment des programmes '
            'échangent des données, souvent par des endpoints HTTP.',
        example: 'jsonplaceholder.typicode.com',
      ),
      GlossaryEntry(
        term: 'Callback',
        definition: 'Fonction passée en argument à une autre fonction, appelée plus tard '
            '(fin d\'un événement, d\'une requête, d\'une animation).',
        example: '\$("#btn").on("click", function(){ … })',
      ),
      GlossaryEntry(
        term: 'Client',
        definition: 'Programme qui demande des ressources : le navigateur (ou une application) '
            'quand il parle à un serveur.',
        example: 'Votre navigateur',
      ),
      GlossaryEntry(
        term: 'DOM',
        definition: 'Document Object Model : représentation en arbre de la page HTML, '
            'manipulable par JavaScript et jQuery.',
        example: 'document.querySelector("#x")',
      ),
      GlossaryEntry(
        term: 'Endpoint',
        definition: 'URL précise d\'une API qui expose une ressource ou une action.',
        example: 'GET /api/users/7',
      ),
      GlossaryEntry(
        term: 'Fetch',
        definition: 'API native du navigateur pour effectuer des requêtes HTTP, alternative moderne '
            'à \$.ajax(). Retourne une Promise.',
        example: 'fetch(url).then(r => r.json())',
      ),
      GlossaryEntry(
        term: 'HTTP',
        definition: 'HyperText Transfer Protocol : protocole d\'échange entre client et serveur, '
            'basé sur des requêtes et des réponses.',
        example: 'GET / HTTP/1.1 → 200 OK',
      ),
      GlossaryEntry(
        term: 'JSON',
        definition: 'JavaScript Object Notation : format texte universel de représentation de données, '
            'à base de paires clé-valeur.',
        example: '{"name": "Alice"}',
      ),
      GlossaryEntry(
        term: 'Promise',
        definition: 'Objet représentant le résultat futur d\'une opération asynchrone : en attente, '
            'réussie ou échouée. Gérée avec then/catch ou async/await.',
        example: 'fetch(url) renvoie une Promise',
      ),
      GlossaryEntry(
        term: 'REST',
        definition: 'Representational State Transfer : architecture d\'API organisée autour de '
            'ressources manipulées avec les verbes HTTP.',
        example: 'CRUD : POST / GET / PUT-PATCH / DELETE',
      ),
      GlossaryEntry(
        term: 'Serveur',
        definition: 'Ordinateur qui attend les requêtes des clients et renvoie des réponses '
            '(pages, données).',
        example: 'Un hébergement web',
      ),
      GlossaryEntry(
        term: 'URL',
        definition: 'Uniform Resource Locator : adresse d\'une ressource sur le réseau, '
            'composée de schéma, hôte, port, chemin et requête.',
        example: 'https://example.com/api/users?page=2',
      ),
      GlossaryEntry(
        term: 'HTML',
        definition: 'HyperText Markup Language : langage de structure des pages web.',
        example: '<button id="btn">Cliquer</button>',
      ),
      GlossaryEntry(
        term: 'CSS',
        definition: 'Cascading Style Sheets : langage de style des pages web.',
        example: '#btn { color: white; }',
      ),
      GlossaryEntry(
        term: 'JavaScript',
        definition: 'Langage de programmation exécuté par le navigateur, qui rend les pages '
            'interactives.',
        example: 'document.getElementById("btn")',
      ),
      GlossaryEntry(
        term: 'jQuery',
        definition: 'Bibliothèque JavaScript créée en 2006 qui simplifie la sélection du DOM, '
            'les événements, les animations et AJAX.',
        example: '\$("#btn").on("click", …)',
      ),
      GlossaryEntry(
        term: 'Token',
        definition: 'Jeton d\'authentification envoyé dans le header Authorization pour prouver '
            'son identité auprès d\'une API.',
        example: 'Authorization: Bearer <token>',
      ),
      GlossaryEntry(
        term: 'CRUD',
        definition: 'Les quatre opérations de base sur une ressource : Create (POST), Read (GET), '
            'Update (PUT/PATCH), Delete (DELETE).',
        example: 'POST /api/users · GET /api/users',
      ),
      GlossaryEntry(
        term: 'XSS',
        definition: 'Cross-Site Scripting : faille de sécurité quand du contenu utilisateur est '
            'inséré sans contrôle. Préférez .text() à .html().',
        example: 'Eviter : \$.html(contenuUtilisateur)',
      ),
      GlossaryEntry(
        term: 'Header',
        definition: 'En-tête HTTP : métadonnée accompagnant requête ou réponse (type de contenu, '
            'autorisation…).',
        example: 'Content-Type: application/json',
      ),
      GlossaryEntry(
        term: 'Query parameters',
        definition: 'Paramètres ajoutés à l\'URL après le ?, pour filtrer ou configurer une requête.',
        example: '?page=2&limit=10',
      ),
      GlossaryEntry(
        term: 'Loader',
        definition: 'Indicateur visuel de chargement affiché pendant une requête AJAX, masqué '
            'dans tous les cas (succès comme échec).',
        example: 'Spinner ou « Chargement… »',
      ),
    ];
