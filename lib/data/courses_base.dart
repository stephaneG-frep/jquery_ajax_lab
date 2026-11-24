import 'package:flutter/material.dart';

import '../models/content_block.dart';
import '../models/course.dart';

/// MODULES 1 à 3 : bases du Web, HTML et JavaScript.
List<CourseModule> baseModules() => [
      CourseModule(
        id: 'web',
        number: 1,
        title: 'Comprendre le Web',
        subtitle: 'Client, serveur, HTTP et DOM : les fondations.',
        icon: Icons.language,
        sections: [
          CourseSection(
            id: 'web-1-1',
            moduleId: 'web',
            order: 1,
            title: 'Le navigateur et le client',
            blocks: [
              const ParagraphBlock(
                  'Quand vous ouvrez un site web, votre appareil joue un rôle : celui de **client**. '
                  'Le client est un programme qui *demande* des ressources : une page, une image, des données. '
                  'Dans notre cas, le client est le **navigateur** (Chrome, Firefox, Safari…).'),
              const ParagraphBlock(
                  'Tout ce que vous tapez dans la barre d\'adresse, le navigateur le transforme en une demande '
                  'formulée très précisément. Cette demande s\'appelle une **requête HTTP**.'),
              const ConceptCardBlock(
                icon: Icons.smartphone,
                title: 'À retenir',
                text: 'Le client (navigateur) demande, le serveur répond. C\'est le point de départ de tout le Web.',
              ),
              const StepsBlock(
                title: 'Ce que fait le navigateur',
                steps: [
                  'Vous tapez une adresse (ex. https://example.com)',
                  'Le navigateur construit une requête HTTP',
                  'Il l\'envoie vers un serveur',
                  'Il attend la réponse',
                  'Il affiche la page reçue',
                ],
              ),
              const TipBlock(
                  'Dans ce laboratoire, vous allez apprendre à créer vous-même ces demandes et à lire les réponses, '
                  'd\'abord avec jQuery, puis avec JavaScript moderne.'),
            ],
          ),
          CourseSection(
            id: 'web-1-2',
            moduleId: 'web',
            order: 2,
            title: 'Le serveur et le modèle client-serveur',
            blocks: [
              const ParagraphBlock(
                  'Le **serveur** est un ordinateur toujours allumé qui attend les requêtes des clients. '
                  'Il renvoie des **réponses** : des pages HTML, des images, ou des données JSON.'),
              const ConceptCardBlock(
                icon: Icons.dns,
                title: 'Le modèle client-serveur',
                text: 'Un client ne parle jamais directement à un autre client. Tout passe par le serveur, '
                    'qui centralise les données et les règles.',
              ),
              const StepsBlock(
                steps: [
                  'Client → envoie une requête HTTP',
                  'Serveur → traite la demande',
                  'Serveur → renvoie une réponse (status + contenu)',
                  'Client → analyse et affiche la réponse',
                ],
              ),
              const ParagraphBlock(
                  'Une **API** est le « guichet » du serveur : un ensemble de règles définissant comment le client '
                  'peut demander des ressources. Vous en apprendrez beaucoup plus dans le module REST.'),
              const WarningBlock(
                  'Les cours de cette application fonctionnent hors connexion. Un serveur n\'est nécessaire '
                  'que lorsque vous exécutez de véritables requêtes AJAX.',
              ),
            ],
          ),
          CourseSection(
            id: 'web-1-3',
            moduleId: 'web',
            order: 3,
            title: 'HTML, CSS et JavaScript : les trois ingrédients',
            blocks: [
              const ParagraphBlock(
                  'Une page web se construit avec trois langages complémentaires :'),
              const BulletsBlock([
                '**HTML** : la structure (l\'ossature, les murs de la maison).',
                '**CSS** : le style (les couleurs, les peintures, les décorations).',
                '**JavaScript** : le comportement (l\'électricité, le chauffage, la logique).',
              ]),
              const CodeBlock(
                '''<!-- HTML : la structure -->
<button id="btn">Clique-moi</button>
<p id="message"></p>''',
                language: 'html',
                explanation: 'HTML définit un bouton et un paragraphe vide. Chaque élément a un identifiant unique.',
              ),
              const CodeBlock(
                '''/* CSS : le style */
#btn { background: #3D5AFE; color: white; padding: 10px 20px; }
#message { color: green; font-weight: bold; }''',
                language: 'css',
                explanation: 'CSS rend le bouton bleu avec du texte blanc, et le message en vert gras.',
              ),
              const CodeBlock(
                '''// JavaScript : le comportement
document.getElementById('btn').addEventListener('click', function () {
  document.getElementById('message').textContent = 'Bravo !';
});''',
                explanation: 'Quand on clique sur le bouton, le texte du paragraphe devient « Bravo ! ».',
              ),
              const ComparisonBlock(
                title: 'La même chose en jQuery',
                jquery: '''\$('#btn').on('click', function () {
  \$('#message').text('Bravo !');
});''',
                modern: '''document.querySelector('#btn').addEventListener('click', () => {
  document.querySelector('#message').textContent = 'Bravo !';
});''',
                note: 'jQuery raccourcit la syntaxe et unifie le code entre navigateurs. C\'est tout l\'intérêt de la bibliothèque.',
              ),
              const TipBlock(
                  'N\'apprenez pas JavaScript et jQuery « en parallèle » : commencez par HTML, puis JavaScript pur, '
                  'puis jQuery. Le module suivant vous donne l\'HTML nécessaire.'),
            ],
          ),
          CourseSection(
            id: 'web-1-4',
            moduleId: 'web',
            order: 4,
            title: 'La requête HTTP et la réponse HTTP',
            blocks: [
              const ParagraphBlock(
                  'L\'échange entre client et serveur suit un protocole nommé **HTTP** (HyperText Transfer Protocol). '
                  'Une **requête** contient : une méthode, une URL, des en-têtes, et parfois un corps.'),
              const CodeBlock(
                '''GET /api/users HTTP/1.1
Host: example.com
Accept: application/json''',
                language: 'http',
                explanation: 'Une requête GET demande la ressource /api/users. Les en-têtes donnent des informations au serveur.',
              ),
              const ParagraphBlock('Une **réponse** contient : un **code de statut**, des en-têtes, et un corps.'),
              const CodeBlock(
                '''HTTP/1.1 200 OK
Content-Type: application/json

[{"id":1,"name":"Alice"}]''',
                language: 'http',
                explanation: 'La réponse 200 OK transporte les données demandées, ici du JSON.',
              ),
              const TableBlock(
                headers: ['Élément', 'Requête', 'Réponse'],
                rows: [
                  ['Méthode', 'GET, POST, PUT…', '—'],
                  ['Statut', '—', '200, 404, 500…'],
                  ['URL', 'Oui', '—'],
                  ['En-têtes', 'Oui', 'Oui'],
                  ['Corps', 'Parfois', 'Souvent'],
                ],
              ),
              const InfoBlock(
                  'C\'est exactement ce que fait \$.ajax() ou fetch() : construire une requête et lire la réponse. '
                  'Vous verrez ces deux outils en détail dans les modules AJAX et HTTP.'),
            ],
          ),
          CourseSection(
            id: 'web-1-5',
            moduleId: 'web',
            order: 5,
            title: 'Le DOM : l\'arbre de la page',
            blocks: [
              const ParagraphBlock(
                  'Quand le navigateur charge une page HTML, il la transforme en un objet manipulable : le '
                  '**DOM** (Document Object Model). Le DOM est un **arbre** : la racine est le document, '
                  'puis html, head, body, et tous les éléments.'),
              const ConceptCardBlock(
                icon: Icons.account_tree,
                title: 'Le DOM, c\'est la page vue comme un arbre',
                text: 'Chaque balise devient un « nœud ». Chaque nœud a un parent, des enfants, des attributs, du texte.',
              ),
              const CodeBlock(
                '''<body>
  <div id="app">
    <button id="btn">Clique-moi</button>
  </div>
</body>''',
                language: 'html',
                explanation: 'body est le parent de #app, qui est le parent de #btn.',
              ),
              const StepsBlock(
                title: 'L\'arbre DOM correspondant',
                steps: [
                  'body',
                  '  └─ div#app',
                  '        └─ button#btn  « Clique-moi »',
                ],
              ),
              const ParagraphBlock(
                  'JavaScript et jQuery ne font qu\'une chose au fond : **naviguer dans cet arbre** et le modifier. '
                  'Sélectionner un élément, changer son texte, le déplacer, le supprimer… tout cela revient à '
                  'manipuler le DOM.'),
              const TipBlock(
                  'La méthode \$() de jQuery est un sélecteur : elle retrouve les nœuds du DOM qui correspondent '
                  'à votre demande. C\'est la porte d\'entrée de tout le reste.'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'html',
        number: 2,
        title: 'HTML utile à jQuery',
        subtitle: 'Les balises et attributs que jQuery manipule.',
        icon: Icons.code,
        sections: [
          CourseSection(
            id: 'html-2-1',
            moduleId: 'html',
            order: 1,
            title: 'Le squelette d\'une page',
            blocks: [
              const ParagraphBlock(
                  'Une page HTML est un fichier texte. Elle commence par une déclaration, puis une balise <html> '
                  'qui contient <head> (les informations) et <body> (le contenu visible).'),
              const CodeBlock(
                '''<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Ma page</title>
</head>
<body>
  <h1>Bonjour</h1>
</body>
</html>''',
                language: 'html',
                explanation: 'Le squelette minimal : doctype, html, head avec méta et titre, body avec le contenu.',
              ),
              const ParagraphBlock(
                  'Dans le laboratoire de cette application, vous n\'avez pas besoin d\'écrire le squelette : '
                  'il est ajouté automatiquement. Vous écrivez simplement le contenu du <body>, le CSS et le '
                  'JavaScript.'),
              const InfoBlock(
                  'Le <head> sert à donner des informations sur la page (titre, encodage, feuilles de style). '
                  'Le <body> contient tout ce qui est affiché.'),
            ],
          ),
          CourseSection(
            id: 'html-2-2',
            moduleId: 'html',
            order: 2,
            title: 'Les balises essentielles',
            blocks: [
              const ParagraphBlock('Voici les balises que vous manipulerez le plus souvent avec jQuery :'),
              const TableBlock(
                headers: ['Balise', 'Rôle'],
                rows: [
                  ['<div>', 'Conteneur générique (bloc)'],
                  ['<p>', 'Paragraphe de texte'],
                  ['<button>', 'Bouton cliquable'],
                  ['<input>', 'Champ de saisie'],
                  ['<form>', 'Formulaire (groupe de champs)'],
                  ['<ul> / <li>', 'Liste non ordonnée / élément de liste'],
                ],
              ),
              const CodeBlock(
                '''<div id="app">
  <p id="intro">Bienvenue !</p>
  <input type="text" id="nom" placeholder="Votre nom">
  <button id="valider">Valider</button>
  <ul id="liste"></ul>
</div>''',
                language: 'html',
                explanation: 'Un conteneur div, un paragraphe, un champ de saisie, un bouton et une liste vide. '
                    'C\'est le canevas typique des exercices de ce laboratoire.',
              ),
              const ParagraphBlock(
                  'Notez la forme du <input> : il s\'agit d\'une balise **auto-fermante**, sans </input>. '
                  'Le <ul> contiendra plus tard des <li>, ajoutés par jQuery.'),
              const TipBlock(
                  'Donnez toujours un id à ce que vous voulez manipuler : c\'est l\'adresse précise d\'un élément.'),
            ],
          ),
          CourseSection(
            id: 'html-2-3',
            moduleId: 'html',
            order: 3,
            title: 'id, class et data-*',
            blocks: [
              const ParagraphBlock('Les attributs permettent de décrire les éléments. Trois d\'entre eux comptent particulièrement pour JavaScript :'),
              const BulletsBlock([
                '**id** : identifiant unique dans la page (une seule fois).',
                '**class** : étiquette partagée par plusieurs éléments.',
                '**data-*** : données personnalisées, préfixées par data- (ex. data-id, data-prix).',
              ]),
              const CodeBlock(
                '''<button id="btn-payer" class="bouton-achat" data-id="42" data-prix="9.90">
  Acheter
</button>''',
                language: 'html',
                explanation: 'Un bouton avec un id unique, une classe pour le style, et des données personnalisées.',
              ),
              const TableBlock(
                headers: ['Attribut', 'Sélecteur jQuery', 'À quoi ça sert'],
                rows: [
                  ['id="x"', '\$("#x")', 'Cibler UN élément précis'],
                  ['class="y"', '\$(".y")', 'Cibler TOUS les éléments de la classe'],
                  ['data-id="5"', '\$("#b").data("id")', 'Stocker des données sur l\'élément'],
                ],
              ),
              const ParagraphBlock(
                  'Les données data-* sont un moyen propre de transporter de l\'information liée à un élément, '
                  'par exemple l\'identifiant d\'un utilisateur à supprimer.'),
              const WarningBlock(
                  'Un id doit être unique. Si vous répétez un id, jQuery ne sélectionnera que le premier '
                  'élément trouvé — source fréquente de bugs !'),
            ],
          ),
          CourseSection(
            id: 'html-2-4',
            moduleId: 'html',
            order: 4,
            title: 'Comment JavaScript retrouve les éléments',
            blocks: [
              const ParagraphBlock(
                  'Pour agir sur un élément, il faut d\'abord le **retrouver dans la page**. '
                  'Chaque langage a ses outils :'),
              const TableBlock(
                headers: ['Moyen', 'JavaScript pur', 'jQuery'],
                rows: [
                  ['Par id', 'document.getElementById("x")', '\$("#x")'],
                  ['Par classe', 'document.querySelectorAll(".y")', '\$(".y")'],
                  ['Par balise', 'document.querySelector("p")', '\$("p")'],
                  ['Premier résultat', 'querySelector("p")', '\$("p").first()'],
                ],
              ),
              const CodeBlock(
                '''// JavaScript pur : verbeux mais explicite
const titre = document.getElementById('titre');
titre.style.color = 'red';

// jQuery : court et lisible
\$('#titre').css('color', 'red');''',
                explanation: 'Les deux lignes font exactement la même chose. jQuery gagne en concision.',
              ),
              const ConceptCardBlock(
                icon: Icons.travel_explore,
                title: 'La logique commune',
                text: '1) Choisir une cible (sélecteur). 2) Appliquer une action. '
                    '3) Parfois, écouter un événement sur cette cible.',
              ),
              const ExerciseLinkBlock('ex-html-1'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'js',
        number: 3,
        title: 'Bases JavaScript',
        subtitle: 'Le minimum indispensable avant jQuery.',
        icon: Icons.javascript,
        sections: [
          CourseSection(
            id: 'js-3-1',
            moduleId: 'js',
            order: 1,
            title: 'Variables et types',
            blocks: [
              const ParagraphBlock(
                  'Une **variable** est une boîte étiquetée qui contient une valeur. '
                  'En JavaScript moderne, on déclare une variable avec **let** (modifiable) ou **const** (constante).'),
              const CodeBlock(
                '''let nom = 'Alice';
const age = 30;
nom = 'Bob';      // OK, let est modifiable
// age = 31;      // Erreur ! const ne se modifie pas

console.log(nom, age); // → Bob 30''',
                explanation: 'let permet de réassigner, const interdit la réassignation.',
              ),
              const ParagraphBlock('Les types principaux :'),
              const BulletsBlock([
                '**string** : texte, entre guillemets simples, doubles ou backticks.',
                '**number** : nombre entier ou décimal.',
                '**boolean** : true ou false.',
                '**array** : liste ordonnée, entre [ ].',
                '**object** : collection clé-valeur, entre { }.',
                '**null / undefined** : absence de valeur.',
              ]),
              const CodeBlock(
                '''const texte = 'Bonjour';
const chiffre = 42;
const decimal = 3.14;
const vrai = true;
const liste = [1, 2, 3];
const personne = { nom: 'Alice', age: 30 };

console.log(typeof chiffre); // → number''',
                explanation: 'typeof renvoie le type d\'une valeur.',
              ),
              const TipBlock(
                  'Quand jQuery est chargé, la variable \$ est globale. C\'est une fonction, donc un objet de '
                  'type function — vous l\'utiliserez sans réfléchir à sa nature.'),
            ],
          ),
          CourseSection(
            id: 'js-3-2',
            moduleId: 'js',
            order: 2,
            title: 'Chaînes et nombres',
            blocks: [
              const ParagraphBlock('Les **chaînes** se concatènent avec + ou s\'interpolent avec les backticks.'),
              const CodeBlock(
                '''const prenom = 'Alice';
const salutation = 'Bonjour ' + prenom + ' !'; // concaténation
const autre = `Bonjour \${prenom} !`;           // interpolation

console.log(salutation); // → Bonjour Alice !
console.log(autre);      // → Bonjour Alice !''',
                explanation: 'L\'interpolation avec \${} dans les backticks est plus lisible.',
              ),
              const ParagraphBlock('Les **nombres** se calculent avec + - * / et %.'),
              const CodeBlock(
                '''const total = 12 + 8;      // 20
const reduction = total * 0.9; // 18
const reste = 20 % 3;          // 2
console.log(`Prix : \${reduction} €`); // → Prix : 18 €''',
                explanation: 'Les opérations arithmétiques classiques fonctionnent nativement.',
              ),
              const CodeBlock(
                '''const texteNombre = '5';
console.log(texteNombre + 1);  // → '51' (concaténation !)
console.log(Number(texteNombre) + 1); // → 6 (conversion)
console.log(parseInt(texteNombre, 10) + 1); // → 6''',
                explanation: 'Un + avec une chaîne concatène. Pensez à convertir avec Number() ou parseInt().',
              ),
              const WarningBlock(
                  'Ce piège de conversion est un classique des formulaires : la valeur d\'un <input> est '
                  'toujours une chaîne, même si elle ressemble à un nombre.'),
            ],
          ),
          CourseSection(
            id: 'js-3-3',
            moduleId: 'js',
            order: 3,
            title: 'Tableaux et objets',
            blocks: [
              const ParagraphBlock('Un **tableau** est une liste ordonnée. Un **objet** est une collection clé-valeur.'),
              const CodeBlock(
                '''const fruits = ['pomme', 'poire', 'banane'];
console.log(fruits[0]);      // → pomme (index 0)
console.log(fruits.length);  // → 3
fruits.push('kiwi');         // ajoute à la fin
console.log(fruits);         // → ['pomme','poire','banane','kiwi']''',
                explanation: 'L\'index commence à 0. push() ajoute un élément à la fin.',
              ),
              const CodeBlock(
                '''const utilisateur = {
  nom: 'Alice',
  age: 30,
  admin: true
};
console.log(utilisateur.nom);  // → Alice (notation point)
console.log(utilisateur['age']); // → 30 (notation crochets)''',
                explanation: 'Un objet regroupe des informations sur une même chose, accessibles par leur clé.',
              ),
              const ParagraphBlock('Les tableaux et objets se combinent naturellement :'),
              const CodeBlock(
                '''const utilisateurs = [
  { nom: 'Alice', age: 30 },
  { nom: 'Bob', age: 25 }
];
console.log(utilisateurs[1].nom); // → Bob''',
                explanation: 'Un tableau d\'objets : c\'est exactement le format renvoyé par la plupart des API.',
              ),
              const TipBlock(
                  'Une réponse d\'API JSON est souvent un tableau d\'objets. Savoir lire cette structure '
                  'est la clé du module JSON.'),
            ],
          ),
          CourseSection(
            id: 'js-3-4',
            moduleId: 'js',
            order: 4,
            title: 'Conditions et comparaisons',
            blocks: [
              const ParagraphBlock(
                  'Les **conditions** permettent d\'exécuter du code selon un test : if / else if / else.'),
              const CodeBlock(
                '''const age = 18;
if (age >= 18) {
  console.log('Majeur');
} else {
  console.log('Mineur');
}''',
                explanation: 'si la condition est vraie, le premier bloc s\'exécute, sinon le second.',
              ),
              const TableBlock(
                headers: ['Opérateur', 'Signification', 'Exemple vrai'],
                rows: [
                  ['===', 'Égalité stricte (valeur ET type)', '1 === 1'],
                  ['!==', 'Inégalité stricte', '1 !== 2'],
                  ['>', 'Supérieur', '5 > 3'],
                  ['<', 'Inférieur', '3 < 5'],
                  ['>=', 'Supérieur ou égal', '5 >= 5'],
                  ['&&', 'ET logique', 'true && true'],
                  ['||', 'OU logique', 'true || false'],
                ],
              ),
              const CodeBlock(
                '''const nom = 'Alice';
const age = 30;
if (nom === 'Alice' && age > 18) {
  console.log('Alice est majeure');
}''',
                explanation: 'Les deux conditions doivent être vraies.',
              ),
              const WarningBlock(
                  'Préférez === à == en JavaScript. === compare la valeur ET le type, ce qui évite les '
                  'surprises comme 5 == "5".'),
            ],
          ),
          CourseSection(
            id: 'js-3-5',
            moduleId: 'js',
            order: 5,
            title: 'Fonctions et callbacks',
            blocks: [
              const ParagraphBlock(
                  'Une **fonction** est un bloc de code réutilisable, avec un nom et éventuellement des paramètres.'),
              const CodeBlock(
                '''function saluer(nom) {
  return 'Bonjour ' + nom + ' !';
}

// ou, en flèche :
const saluer2 = (nom) => 'Bonjour ' + nom + ' !';

console.log(saluer('Alice'));  // → Bonjour Alice !
console.log(saluer2('Bob'));   // → Bonjour Bob !''',
                explanation: 'return renvoie le résultat. La syntaxe flèche est une écriture raccourcie moderne.',
              ),
              const ParagraphBlock(
                  'Un **callback** est une fonction passée en argument à une autre fonction, '
                  'pour être appelée plus tard. C\'est le cœur des événements et d\'AJAX.'),
              const CodeBlock(
                '''// Passer une fonction anonyme en callback
\$('#btn').on('click', function () {
  alert('Cliqué !');
});

// jQuery appelle automatiquement le callback quand on clique''',
                explanation: 'On ne fait que décrire ce qui doit se passer : jQuery déclenchera le callback au bon moment.',
              ),
              const ConceptCardBlock(
                icon: Icons.sync_alt,
                title: 'Pourquoi des callbacks ?',
                text: 'Quand une action est longue (attendre un clic, attendre un serveur), on ne bloque pas '
                    'le programme : on fournit une fonction qui sera appelée quand l\'action sera finie.',
              ),
              const TipBlock(
                  'jQuery fonctionne entièrement avec des callbacks : événements, animations et AJAX '
                  'utilisent ce mécanisme que vous venez d\'apprendre.'),
            ],
          ),
          CourseSection(
            id: 'js-3-6',
            moduleId: 'js',
            order: 6,
            title: 'Événements et DOM en JavaScript pur',
            blocks: [
              const ParagraphBlock(
                  'Un **événement** est un signal émis par le navigateur : clic, saisie, envoi de formulaire… '
                  'On « écoute » un événement avec addEventListener.'),
              const CodeBlock(
                '''const bouton = document.getElementById('btn');
bouton.addEventListener('click', function () {
  document.getElementById('message').textContent = 'Bravo !';
});''',
                explanation: 'On sélectionne le bouton, on écoute le clic, et on modifie le texte du message.',
              ),
              const ParagraphBlock('Les principales façons de lire et modifier le DOM :'),
              const TableBlock(
                headers: ['Besoin', 'JavaScript pur'],
                rows: [
                  ['Texte d\'un élément', 'element.textContent'],
                  ['HTML d\'un élément', 'element.innerHTML'],
                  ['Valeur d\'un champ', 'element.value'],
                  ['Attribut', 'element.getAttribute("id")'],
                  ['Style', 'element.style.color = "red"'],
                  ['Ajouter un enfant', 'element.appendChild(noeud)'],
                  ['Supprimer', 'element.remove()'],
                ],
              ),
              const CodeBlock(
                '''const liste = document.getElementById('liste');
const li = document.createElement('li');
li.textContent = 'Nouvel élément';
liste.appendChild(li);''',
                explanation: 'On crée un <li>, on lui donne du texte, puis on l\'ajoute à la liste.',
              ),
              const ComparisonBlock(
                title: 'DOM en pur vs jQuery',
                jquery: '''\$('#liste').append('<li>Nouvel élément</li>');''',
                modern: '''const liste = document.querySelector('#liste');
const li = document.createElement('li');
li.textContent = 'Nouvel élément';
liste.appendChild(li);''',
                note: 'jQuery réduit plusieurs lignes à une seule. Vous comprenez maintenant la valeur de la bibliothèque.',
              ),
            ],
          ),
        ],
      ),
    ];
