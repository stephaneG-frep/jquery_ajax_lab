import '../models/exercise.dart';

/// Tous les exercices pédagogiques, classés par niveau et par catégorie.
List<Exercise> allExercises() => [
      // ============================= HTML =============================
      Exercise(
        id: 'ex-html-1',
        title: 'Retrouver un élément',
        moduleId: 'html',
        category: 'HTML',
        level: ExerciseLevel.guided,
        type: ExerciseType.choice,
        objective: 'Choisir la bonne façon de cibler un élément grâce à son id.',
        instructions: 'Le bouton ci-dessous possède l\'id "btn". Pour agir sur lui avec jQuery, '
            'quelle expression utilise-t-on ?',
        hints: [
          'Un id se sélectionne avec un caractère spécial, exactement comme en CSS.',
          'Ce caractère est le dièse (#).',
        ],
        solution: '\$("#btn")',
        solutionExplanation: 'Le # désigne un id, comme en CSS. \'#btn\' cherche l\'élément dont l\'id '
            'vaut btn.',
        choices: ['\$(".btn")', '\$("#btn")', '\$("btn")', '\$("button#classe")'],
        correctChoiceIndex: 1,
      ),
      Exercise(
        id: 'ex-html-2',
        title: 'Les attributs data-*',
        moduleId: 'html',
        category: 'HTML',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.choice,
        objective: 'Comprendre l\'utilité des attributs data-*.',
        instructions: 'On a : <button data-id="7">. Quelle est la bonne affirmation ?',
        hints: [
          'data-* sert à stocker de l\'information directement sur l\'élément.',
          'Cette information est récupérable en JavaScript.',
        ],
        solution: 'data-id stocke une donnée personnalisée sur l\'élément, lisible en JavaScript.',
        solutionExplanation: 'Les attributs data-* sont des zones de stockage personnalisées : '
            'data-id="7" signifie que l\'élément transporte la valeur 7.',
        choices: [
          'data-id est un attribut standard qui affiche le chiffre 7 sur la page.',
          'data-id stocke une donnée personnalisée sur l\'élément, lisible en JavaScript.',
          'data-id force l\'élément à avoir l\'id 7.',
          'data-id est réservé aux éléments <li>.',
        ],
        correctChoiceIndex: 1,
      ),
      // ============================= JAVASCRIPT =============================
      Exercise(
        id: 'ex-js-1',
        title: 'Fonction et retour',
        moduleId: 'js',
        category: 'JavaScript',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Écrire une fonction qui renvoie une salutation.',
        instructions: 'Complétez la fonction pour qu\'elle renvoie la chaîne "Bonjour Alice !". '
            'La fonction s\'appelle saluer et prend un paramètre nom.',
        hints: [
          'Une fonction se déclare avec le mot-clé function.',
          'On renvoie une valeur avec return.',
        ],
        solution: r'''function saluer(nom) {
  return 'Bonjour ' + nom + ' !';
}''',
        solutionExplanation: 'function déclare la fonction, return renvoie le résultat. '
            'Le paramètre nom est utilisé dans la concaténation.',
        rule: const ValidationRule(
          patterns: [
            r"function saluer\(\w+\)\{|saluer=function ?\w*\(\w+\)\{|saluer=\(?\w+\)?=>",
            r"'Bonjour (?:'\+\w+\+' ?!'|\$\{\s*\w+\s*\} ?!')",
            r"\breturn\b|=>",
          ],
          feedback: 'Il manque le mot-clé function ou return. Pensez : function saluer(nom) { … return …; }',
        ),
      ),
      Exercise(
        id: 'ex-js-2',
        title: 'typeof',
        moduleId: 'js',
        category: 'JavaScript',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.choice,
        objective: 'Identifier le type d\'une valeur.',
        instructions: 'Quel est le type de la valeur 42 (sans guillemets) ?',
        hints: [
          '42 n\'est pas entre guillemets.',
          'Le mot-clé est en anglais.',
        ],
        solution: 'number',
        solutionExplanation: '42 est un nombre : en JavaScript, typeof 42 donne "number".',
        choices: ['string', 'number', 'boolean', 'object'],
        correctChoiceIndex: 1,
      ),
      // ============================= JQUERY =============================
      Exercise(
        id: 'ex-jquery-1',
        title: 'Première sélection jQuery',
        moduleId: 'jquery',
        category: 'jQuery',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Changer le texte d\'un paragraphe avec jQuery.',
        instructions: 'La page contient <p id="demo">Texte</p>. Écrivez la ligne jQuery qui remplace '
            'son texte par "Modifié !".',
        hints: [
          'Sélectionnez d\'abord avec \$( "#demo" ).',
          'Ensuite appliquez la méthode .text("Modifié !").',
        ],
        solution: r'''$('#demo').text('Modifié !');''',
        solutionExplanation: '\$( "#demo" ) sélectionne l\'élément par son id, .text("Modifié !") '
            'remplace son contenu textuel.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#demo'\)\.text\('Modifié ?!'\)",
          ],
          feedback: 'Rappel : \$( "#demo" ).text( "Modifié !" ). Le sélecteur cible l\'id, .text() '
              'écrit le texte.',
        ),
      ),
      Exercise(
        id: 'ex-jquery-2',
        title: 'Remonter au parent',
        moduleId: 'jquery',
        category: 'jQuery',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Supprimer la carte parente d\'un bouton.',
        instructions: 'Depuis un bouton cliqué (représeté par \$(this)), remontez au parent .carte '
            'et supprimez-le. Écrivez la ligne jQuery complète.',
        hints: [
          'Une méthode cherche le parent le plus proche d\'un sélecteur.',
          'Cette méthode s\'appelle closest().',
        ],
        solution: r'''$(this).closest('.carte').remove();''',
        solutionExplanation: 'closest(".carte") remonte jusqu\'au parent qui a la classe carte, '
            'remove() le supprime du DOM.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\(this\)\.(?:closest\('\w*\.carte'\)|parents\('\w*\.carte'\)\.(?:first\(\)|eq\(0\)))\.remove\(\)",
          ],
          feedback: 'Il faut utiliser closest() : \$(this).closest(".carte").remove().',
        ),
      ),
      Exercise(
        id: 'ex-jquery-3',
        title: 'Attendre la page',
        moduleId: 'jquery',
        category: 'jQuery',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Envelopper du code dans le bloc « document prêt ».',
        instructions: 'Écrivez le bloc jQuery qui s\'exécute uniquement quand le document est prêt, '
            'et qui affiche "Prêt" dans la console.',
        hints: [
          'La forme complète est \$(document).ready(function(){ … });',
          'Affichez avec console.log("Prêt");',
        ],
        solution: r'''$(document).ready(function () {
  console.log('Prêt');
});''',
        solutionExplanation: 'Le callback de .ready() s\'exécute quand le DOM est construit, '
            'donc quand la page est prête.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\(document\)\.ready\(<fn>|<jq>\(<fn>",
            r"console\.log\('Prêt'\)",
          ],
          feedback: 'Rappel : \$(document).ready(function () { … }); permet d\'attendre que la page '
              'soit prête.',
        ),
      ),
      // ============================= DOM =============================
      Exercise(
        id: 'ex-dom-1',
        title: 'text() ou html() ?',
        moduleId: 'dom',
        category: 'DOM',
        level: ExerciseLevel.guided,
        type: ExerciseType.choice,
        objective: 'Choisir la méthode adaptée.',
        instructions: 'On veut afficher dans une zone le texte "<b>gras</b>" tel quel, sans que la '
            'balise soit interprétée. Quelle méthode utiliser ?',
        hints: [
          'L\'une des deux méthodes interprète les balises.',
          'L\'autre les affiche comme du texte brut.',
        ],
        solution: 'text()',
        solutionExplanation: 'text() traite le contenu comme du texte brut, donc la balise '
            '<b> ne sera pas interprétée. C\'est aussi la méthode sûre.',
        choices: ['html()', 'text()', 'append()', 'val()'],
        correctChoiceIndex: 1,
      ),
      Exercise(
        id: 'ex-dom-2',
        title: 'Calculer un âge',
        moduleId: 'dom',
        category: 'DOM',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.code,
        objective: 'Lire un champ, convertir en nombre, afficher le double.',
        instructions: 'Le champ a l\'id "age". Affichez dans #resultat le double de la valeur saisie, '
            'convertie en nombre.',
        hints: [
          'Lisez la valeur avec \$("#age").val().',
          'Convertissez avec Number() avant de multiplier.',
        ],
        solution: r'''$('#resultat').text(Number($('#age').val()) * 2);''',
        solutionExplanation: 'val() renvoie une chaîne : Number() la convertit, puis on multiplie par '
            '2 et on écrit le résultat avec text().',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#resultat'\)\.(?:text|html)\(",
            r"<jq>\('\w*#age'\)\.val\(\)",
            r"\b(?:Number|parseInt|parseFloat)\(|\+<jq>\('\w*#age'",
            r"\*2\b|\b2\*",
          ],
          feedback: 'Rappel : la valeur d\'un champ est une chaîne. Utilisez Number(...) avant de '
              'faire un calcul.',
        ),
      ),
      Exercise(
        id: 'ex-dom-3',
        title: 'Classes et style',
        moduleId: 'dom',
        category: 'DOM',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Ajouter et retirer une classe.',
        instructions: 'Sur l\'élément #carte, ajoutez la classe "active" puis retouvez-la (toggle). '
            'Écrivez une ligne jQuery qui bascule la classe.',
        hints: [
          'Une seule méthode jQuery fait ce travail.',
          'Elle s\'appelle toggleClass().',
        ],
        solution: r'''$('#carte').toggleClass('active');''',
        solutionExplanation: 'toggleClass("active") ajoute la classe si elle est absente, et la '
            'retire si elle est présente.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#carte'\)\.toggleClass\('active'\)",
          ],
          feedback: 'Rappel : \$( "#carte" ).toggleClass( "active" ) bascule la classe à chaque appel.',
        ),
      ),
      Exercise(
        id: 'ex-dom-4',
        title: 'Ajouter à une liste',
        moduleId: 'dom',
        category: 'DOM',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Ajouter un élément à une liste.',
        instructions: 'La liste a l\'id "liste". Ajoutez-y un <li> contenant le texte "Nouveau" à la '
            'fin de la liste.',
        hints: [
          'Utilisez .append() pour ajouter à la fin.',
          'Le contenu à ajouter est une chaîne HTML : "<li>Nouveau</li>".',
        ],
        solution: r'''$('#liste').append('<li>Nouveau</li>');''',
        solutionExplanation: 'append() insère le <li> en dernier enfant de #liste.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#liste'\)\.append\(|\.appendTo\((?:<jq>\()?'\w*#liste'",
            r"<li>Nouveau</li>|<jq>\('<li ?/?>(?:</li>)?'(?:\)\.text\('Nouveau'|,\{text:'Nouveau')",
          ],
          feedback: 'Rappel : \$( "#liste" ).append( "<li>Nouveau</li>" ) ajoute un <li> à la fin.',
        ),
      ),
      Exercise(
        id: 'ex-dom-5',
        title: 'remove() ou empty() ?',
        moduleId: 'dom',
        category: 'DOM',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.choice,
        objective: 'Distinguer remove() et empty().',
        instructions: 'On veut que la zone #zone disparaisse complètement de la page. '
            'Quelle méthode utiliser ?',
        hints: [
          'L\'une supprime les enfants en gardant l\'élément.',
          'L\'autre supprime l\'élément lui-même.',
        ],
        solution: 'remove()',
        solutionExplanation: 'remove() supprime l\'élément et ses enfants du DOM. empty() ne '
            'supprime que les enfants.',
        choices: ['remove()', 'empty()', 'append()', 'detach()'],
        correctChoiceIndex: 0,
      ),
      // ============================= ÉVÉNEMENTS =============================
      Exercise(
        id: 'ex-events-1',
        title: 'Bloquer le rechargement',
        moduleId: 'events',
        category: 'Événements',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Empêcher le rechargement d\'un formulaire.',
        instructions: 'Dans le callback de .submit() du formulaire #form, écrivez l\'appel qui empêche '
            'le comportement par défaut (le rechargement de la page).',
        hints: [
          'Le callback reçoit un objet event en paramètre.',
          'La méthode s\'appelle preventDefault().',
        ],
        solution: r'''$('#form').on('submit', function (e) {
  e.preventDefault();
});''',
        solutionExplanation: 'preventDefault() annule le rechargement : indispensable avant toute '
            'requête AJAX depuis un formulaire.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#form'\)\.(?:on\('submit',|submit\()<fn>.*\.preventDefault\(\)|^\w+\.preventDefault\(\);?$",
          ],
          feedback: 'Rappel : dans le callback de submit, appelez e.preventDefault() avec l\'objet '
              'event en paramètre.',
        ),
      ),
      Exercise(
        id: 'ex-events-2',
        title: 'Frappe au clavier',
        moduleId: 'events',
        category: 'Événements',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Réagir à chaque frappe dans un champ.',
        instructions: 'Dans le champ #recherche, à chaque frappe (keyup), affichez la valeur du champ '
            'dans la console.',
        hints: [
          'Le gestionnaire s\'appelle .keyup() ou .on("keyup", …).',
          'Lisez la valeur avec \$(this).val().',
        ],
        solution: r'''$('#recherche').on('keyup', function () {
  console.log($(this).val());
});''',
        solutionExplanation: 'keyup se déclenche à chaque relâchement de touche. \$(this) est le '
            'champ, val() sa valeur.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#recherche'\)\.(?:on\('keyup',|keyup\()<cb>",
            r"console\.log\(",
            r"<jq>\((?:this|'\w*#recherche'|\w+\.(?:target|currentTarget))\)\.val\(\)|(?:this|target)\.value",
          ],
          forbidden: [r"=>(?:(?!function).)*<jq>\(this\)"],
          feedback: 'Rappel : \$( "#recherche" ).on( "keyup", function () { … } ) avec \$(this).val().',
        ),
      ),
      Exercise(
        id: 'ex-events-3',
        title: 'La méthode .on()',
        moduleId: 'events',
        category: 'Événements',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Écrire un gestionnaire de clic moderne.',
        instructions: 'Sur #bouton, avec .on(), écoutez le clic et affichez "Bonjour !" dans #message.',
        hints: [
          'Syntaxe : \$( "#bouton" ).on( "click", function () { … } )',
          'Écrivez le texte avec \$( "#message" ).text( "Bonjour !" ).',
        ],
        solution: r'''$('#bouton').on('click', function () {
  $('#message').text('Bonjour !');
});''',
        solutionExplanation: '.on("click", callback) attache le gestionnaire. Le callback modifie '
            'le texte du message.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#bouton'\)\.on\('click',<cb>",
            r"<jq>\('\w*#message'\)\.(?:text|html)\('Bonjour ?!'\)",
          ],
          feedback: 'Rappel : \$( "#bouton" ).on( "click", function () { \$( "#message" ).text( "Bonjour !" ); } )',
        ),
      ),
      Exercise(
        id: 'ex-events-4',
        title: '\$(this) en action',
        moduleId: 'events',
        category: 'Événements',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Agir sur l\'élément cliqué.',
        instructions: 'Les boutons .bouton sont nombreux. Écrivez le gestionnaire de clic qui masque '
            'le bouton cliqué.',
        hints: [
          'Dans un callback d\'événement, \$(this) est l\'élément cliqué.',
          'Masquer avec .hide().',
        ],
        solution: r'''$('.bouton').on('click', function () {
  $(this).hide();
});''',
        solutionExplanation: 'Le clic agit sur le bouton précis : \$(this) est l\'élément déclencheur.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*\.bouton'\)\.(?:on\('click',|click\()<cb>",
            r"<jq>\((?:this|\w+\.(?:target|currentTarget))\)\.(?:hide|fadeOut|slideUp)\(",
          ],
          forbidden: [r"=>(?:(?!function).)*<jq>\(this\)"],
          feedback: 'Rappel : \$(this) représente l\'élément qui a déclenché l\'événement.',
        ),
      ),
      Exercise(
        id: 'ex-events-5',
        title: 'Délégation d\'événements',
        moduleId: 'events',
        category: 'Événements',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.code,
        objective: 'Gérer les éléments créés dynamiquement.',
        instructions: 'Des <li> sont ajoutés dans #liste après le chargement. Écrivez le gestionnaire '
            'délégué qui ajoute la classe "fait" quand on clique sur un <li> (y compris les futurs).',
        hints: [
          'Un .on() simple sur les <li> ne capte pas les éléments ajoutés plus tard.',
          'Placez l\'écouteur sur #liste et passez "li" en sélecteur cible.',
        ],
        solution: r'''$('#liste').on('click', 'li', function () {
  $(this).toggleClass('fait');
});''',
        solutionExplanation: 'Le sélecteur "li" en second argument délègue : jQuery écoute le clic '
            'sur la liste mais n\'agit que si la cible est un <li>.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#liste'\)\.on\('click','li',<cb>",
            r"<jq>\((?:this|\w+\.(?:target|currentTarget))\)\.(?:addClass|toggleClass)\('fait'\)",
          ],
          forbidden: [r"=>(?:(?!function).)*<jq>\(this\)"],
          feedback: 'Rappel : \$( "#liste" ).on( "click", "li", function(){ … } ) pour les éléments '
              'créés après le chargement.',
        ),
      ),
      // ============================= ANIMATIONS =============================
      Exercise(
        id: 'ex-anim-1',
        title: 'Afficher / masquer',
        moduleId: 'anim',
        category: 'Animations',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Basculer la visibilité d\'une zone.',
        instructions: 'Le bouton #btn doit afficher/masquer la zone #zone à chaque clic, en 300 ms.',
        hints: [
          'La méthode toggle() fait exactement cette bascule.',
          'Passez la durée en argument : .toggle(300).',
        ],
        solution: r'''$('#btn').on('click', function () {
  $('#zone').toggle(300);
});''',
        solutionExplanation: 'toggle() bascule la visibilité ; 300 est la durée en millisecondes.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#btn'\)\.(?:on\('click',|click\()<cb>",
            r"<jq>\('\w*#zone'\)\.(?:toggle|fadeToggle|slideToggle)\((?:300\b|\{duration:300\b)",
          ],
          feedback: 'Rappel : \$( "#zone" ).toggle( 300 ) bascule la visibilité avec une durée.',
        ),
      ),
      Exercise(
        id: 'ex-anim-2',
        title: 'Fondu puis suppression',
        moduleId: 'anim',
        category: 'Animations',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.code,
        objective: 'Faire disparaître un élément en fondu puis le supprimer.',
        instructions: 'Sur #banner, appliquez un fadeOut de 500 ms, puis une fois le fondu terminé, '
            'supprimez l\'élément avec \$(this).remove().',
        hints: [
          'fadeOut accepte une durée puis un callback de fin.',
          'Le callback s\'exécute quand l\'animation est terminée.',
        ],
        solution: r'''$('#banner').fadeOut(500, function () {
  $(this).remove();
});''',
        solutionExplanation: 'Le callback de fadeOut s\'exécute après l\'animation : c\'est le bon '
            'moment pour retirer l\'élément.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#banner'\)\.fadeOut\(500,<cb>",
            r"<jq>\((?:this|'\w*#banner')\)\.remove\(\)|\bthis\.remove\(\)",
          ],
          forbidden: [r"=>(?:(?!function).)*<jq>\(this\)"],
          feedback: 'Rappel : \$( "#banner" ).fadeOut( 500, function () { \$(this).remove(); } ).',
        ),
      ),
      Exercise(
        id: 'ex-anim-3',
        title: 'Accordéon',
        moduleId: 'anim',
        category: 'Animations',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Ouvrir un panneau en glissant.',
        instructions: 'Le bouton #btn doit faire glisser le panneau #panneau pour l\'ouvrir ou le '
            'fermer en 300 ms.',
        hints: [
          'La famille slide* joue sur la hauteur.',
          'slideToggle() est la méthode de bascule.',
        ],
        solution: r'''$('#btn').on('click', function () {
  $('#panneau').slideToggle(300);
});''',
        solutionExplanation: 'slideToggle déplie/replie le panneau en 300 ms.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#btn'\)\.(?:on\('click',|click\()<cb>",
            r"<jq>\('\w*#panneau'\)\.slideToggle\((?:300\b|\{duration:300\b)",
          ],
          feedback: 'Rappel : \$( "#panneau" ).slideToggle( 300 ) ouvre/ferme en glissant.',
        ),
      ),
      Exercise(
        id: 'ex-anim-4',
        title: 'animate()',
        moduleId: 'anim',
        category: 'Animations',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.code,
        objective: 'Déplacer une boîte avec animate().',
        instructions: 'Sur #boite, animez la propriété "left" en la déplaçant de +=150px sur 800 ms.',
        hints: [
          'animate() prend un objet de propriétés puis une durée.',
          'Syntaxe : \$( "#boite" ).animate( { left: "+=150px" }, 800 ).',
        ],
        solution: r'''$('#boite').animate({ left: '+=150px' }, 800);''',
        solutionExplanation: 'animate anime la propriété numérique left de 150 px en 800 ms.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\('\w*#boite'\)\.animate\(\{'?left'?:'\+=150(?:px)?',?\},(?:800\b|\{duration:800\b)",
          ],
          feedback: 'Rappel : \$( "#boite" ).animate( { left: "+=150px" }, 800 ).',
        ),
      ),
      // ============================= AJAX =============================
      Exercise(
        id: 'ex-ajax-1',
        title: 'Première requête \$.ajax()',
        moduleId: 'ajax',
        category: 'AJAX',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Écrire une requête GET complète.',
        instructions: 'Écrivez un \$.ajax({ … }) avec url "https://jsonplaceholder.typicode.com/users", '
            'method "GET", et un success qui affiche les données dans la console.',
        hints: [
          'L\'objet d\'options : url, method, success.',
          'success: function (data) { console.log(data); }',
        ],
        solution: r'''$.ajax({
  url: 'https://jsonplaceholder.typicode.com/users',
  method: 'GET',
  success: function (data) {
    console.log(data);
  }
});''',
        solutionExplanation: 'L\'objet d\'options décrit toute la requête ; success est appelé avec '
            'les données parsées.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\.ajax\(",
            r"'https://jsonplaceholder\.typicode\.com/users/?'",
            r"'?\b(?:method|type)'?:'(?:GET|get)'",
            r"\bsuccess'?(?::<cb>|:[\w.]+|\()|\.(?:done|then)\(",
            r"console\.log\b",
          ],
          feedback: 'Rappel : \$.ajax( { url: "…", method: "GET", success: function (data) { … } } ).',
        ),
      ),
      Exercise(
        id: 'ex-ajax-2',
        title: 'Le raccourci \$.get()',
        moduleId: 'ajax',
        category: 'AJAX',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Charger des données avec \$.get().',
        instructions: 'Chargez "https://jsonplaceholder.typicode.com/posts/1" avec \$.get() et affichez '
            'le titre du post dans #titre.',
        hints: [
          'Premier argument : l\'URL. Second : le callback.',
          'Le post reçu a une propriété .title.',
        ],
        solution: r'''$.get('https://jsonplaceholder.typicode.com/posts/1', function (post) {
  $('#titre').text(post.title);
});''',
        solutionExplanation: '\$.get(url, callback) reçoit directement les données JSON transformées '
            'en objet.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\.get\('https://jsonplaceholder\.typicode\.com/posts/1'",
            r"<jq>\('\w*#titre'\)\.(?:text|html)\(\w+(?:\.title\b|\['title'\])",
          ],
          feedback: 'Rappel : \$.get( "https://jsonplaceholder.typicode.com/posts/1", function (post) '
              '{ \$( "#titre" ).text( post.title ); } ).',
        ),
      ),
      Exercise(
        id: 'ex-ajax-3',
        title: 'Gérer l\'échec',
        moduleId: 'ajax',
        category: 'AJAX',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.code,
        objective: 'Ajouter une gestion d\'erreur à une requête.',
        instructions: 'Dans un \$.ajax({ url, method: "GET", success }), ajoutez une option error qui '
            'affiche "Erreur" dans la console.',
        hints: [
          'La clé de l\'option est error.',
          'Le callback error reçoit par exemple un objet xhr.',
        ],
        solution: r'''$.ajax({
  url: 'https://jsonplaceholder.typicode.com/users',
  method: 'GET',
  success: function (data) { console.log(data); },
  error: function (xhr) { console.log('Erreur', xhr.status); }
});''',
        solutionExplanation: 'L\'option error est appelée si la requête échoue : c\'est la moitié '
            'pédagogique de toute requête.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\.(?:ajax|get)\(",
            r"\berror'?(?::<cb>|:\w+|\(\w*[^)]*\)\{)|\.(?:fail|catch)\(<cb>",
            r"console\.(?:log|error|warn)\('Erreur",
          ],
          feedback: 'Rappel : ajoutez error: function (xhr) { console.log("Erreur"); } à votre objet '
              'd\'options.',
        ),
      ),
      // ============================= HTTP =============================
      Exercise(
        id: 'ex-http-1',
        title: 'Quel verbe pour quelle action ?',
        moduleId: 'http',
        category: 'HTTP',
        level: ExerciseLevel.guided,
        type: ExerciseType.choice,
        objective: 'Associer les actions aux verbes HTTP.',
        instructions: 'Quel verbe HTTP utilise-t-on pour CRÉER une ressource ?',
        hints: [
          'La création correspond au mot « poster » un message.',
          'Lire = GET, modifier = PUT/PATCH, supprimer = DELETE.',
        ],
        solution: 'POST',
        solutionExplanation: 'POST crée une ressource. C\'est le verbe par défaut pour la création.',
        choices: ['GET', 'POST', 'DELETE', 'PATCH'],
        correctChoiceIndex: 1,
      ),
      Exercise(
        id: 'ex-http-2',
        title: 'Envoyer du JSON',
        moduleId: 'http',
        category: 'HTTP',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Envoyer un corps JSON en POST.',
        instructions: 'Complétez la requête POST vers "https://jsonplaceholder.typicode.com/posts" : '
            'headers avec Content-Type application/json, et data = JSON.stringify({ title: "Mon post" }).',
        hints: [
          'L\'objet à envoyer doit être transformé en texte JSON.',
          'JSON.stringify() fait la conversion.',
        ],
        solution: r'''$.ajax({
  url: 'https://jsonplaceholder.typicode.com/posts',
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  data: JSON.stringify({ title: 'Mon post' })
});''',
        solutionExplanation: 'Content-Type annonce du JSON au serveur, JSON.stringify convertit '
            'l\'objet en texte.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\.ajax\(",
            r"'https://jsonplaceholder\.typicode\.com/posts/?'",
            r"\b(?:method|type)'?:'(?:POST|post)'",
            r"(?:'Content-Type'|contentType'?):'application/json",
            r"JSON\.stringify\(",
          ],
          feedback: 'Rappel : n\'oubliez pas JSON.stringify( … ) pour transformer l\'objet en corps JSON.',
        ),
      ),
      Exercise(
        id: 'ex-http-3',
        title: 'Le header Authorization',
        moduleId: 'http',
        category: 'HTTP',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.choice,
        objective: 'Comprendre l\'authentification par token.',
        instructions: 'Où place-t-on généralement le token d\'authentification dans une requête ?',
        hints: [
          'C\'est une métadonnée de la requête.',
          'Il commence par "Bearer " en général.',
        ],
        solution: 'Dans le header Authorization',
        solutionExplanation: 'Le jeton va dans le header Authorization, souvent sous la forme '
            '"Bearer TOKEN".',
        choices: [
          'Dans le header Authorization',
          'Dans le nom du domaine',
          'Dans la balise <title>',
          'Dans le port de l\'URL',
        ],
        correctChoiceIndex: 0,
      ),
      Exercise(
        id: 'ex-http-4',
        title: 'Lire un code HTTP',
        moduleId: 'http',
        category: 'HTTP',
        level: ExerciseLevel.guided,
        type: ExerciseType.choice,
        objective: 'Interpréter les codes de statut.',
        instructions: 'Vous demandez une ressource qui n\'existe pas. Quel code HTTP le serveur '
            'renvoie-t-il ?',
        hints: [
          'C\'est un code de la famille 4xx.',
          'Il signifie littéralement « pas trouvé ».',
        ],
        solution: '404',
        solutionExplanation: '404 Not Found indique que la ressource demandée n\'existe pas.',
        choices: ['200', '401', '404', '500'],
        correctChoiceIndex: 2,
      ),
      // ============================= JSON =============================
      Exercise(
        id: 'ex-json-1',
        title: 'Lire un objet JSON',
        moduleId: 'json',
        category: 'JSON',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Accéder aux valeurs d\'un objet.',
        instructions: 'Dans le callback success, data est l\'objet {"id": 1, "name": "Alice"}. '
            'Écrivez la ligne qui affiche "Alice" dans la console.',
        hints: [
          'On accède à une clé avec la notation point.',
          'La clé s\'appelle name.',
        ],
        solution: r'''console.log(data.name);''',
        solutionExplanation: 'data.name lit la valeur de la clé name de l\'objet data.',
        rule: const ValidationRule(
          patterns: [
            r"console\.log\(data(?:\.name\b|\['name'\])",
          ],
          feedback: 'Rappel : la notation point donne data.name.',
        ),
      ),
      Exercise(
        id: 'ex-json-2',
        title: 'Tableau d\'objets',
        moduleId: 'json',
        category: 'JSON',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.choice,
        objective: 'Naviguer dans un tableau d\'objets.',
        instructions: 'data est [{"nom": "Alice"}, {"nom": "Bob"}]. Comment afficher "Bob" ?',
        hints: [
          'Le premier élément a l\'index 0.',
          'Bob est le deuxième élément : index 1.',
        ],
        solution: 'data[1].nom',
        solutionExplanation: 'data[1] est le deuxième objet, .nom lit sa clé.',
        choices: ['data[1].nom', 'data[0].nom', 'data.nom[1]', 'data.1.nom'],
        correctChoiceIndex: 0,
      ),
      Exercise(
        id: 'ex-json-3',
        title: 'Structure imbriquée',
        moduleId: 'json',
        category: 'JSON',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.choice,
        objective: 'Descendre dans une structure imbriquée.',
        instructions: 'data = {"user": {"company": {"name": "Acme"}}}. Comment accéder à "Acme" ?',
        hints: [
          'Chaque niveau est une clé à atteindre.',
          'user contient company, qui contient name.',
        ],
        solution: 'data.user.company.name',
        solutionExplanation: 'On descend niveau par niveau : user, puis company, puis name.',
        choices: [
          'data.user.company.name',
          'data.company.name',
          'data.user.name',
          'data["user"]["company"]',
        ],
        correctChoiceIndex: 0,
      ),
      Exercise(
        id: 'ex-json-4',
        title: 'parse et stringify',
        moduleId: 'json',
        category: 'JSON',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Choisir la bonne conversion.',
        instructions: 'Vous avez un texte JSON dans la variable texte. Écrivez la ligne qui le '
            'convertit en objet JavaScript.',
        hints: [
          'Le texte devient objet.',
          'La fonction s\'appelle JSON.parse().',
        ],
        solution: r'''const objet = JSON.parse(texte);''',
        solutionExplanation: 'JSON.parse() lit le texte JSON et renvoie l\'objet correspondant.',
        rule: const ValidationRule(
          patterns: [
            r"(?:JSON\.parse|<jq>\.parseJSON)\(texte\)",
          ],
          feedback: 'Rappel : JSON.parse( texte ) convertit un texte JSON en objet.',
        ),
      ),
      // ============================= REST =============================
      Exercise(
        id: 'ex-rest-1',
        title: 'Identifier un endpoint',
        moduleId: 'rest',
        category: 'REST',
        level: ExerciseLevel.guided,
        type: ExerciseType.choice,
        objective: 'Lire une URL d\'API.',
        instructions: 'GET /api/users/7 désigne quoi ?',
        hints: [
          'Le chemin décrit la ressource.',
          'Le chiffre 7 à la fin est un identifiant.',
        ],
        solution: 'L\'utilisateur n° 7',
        solutionExplanation: '/api/users/7 cible la ressource « utilisateur » avec l\'identifiant 7.',
        choices: [
          'La liste de tous les utilisateurs',
          'L\'utilisateur n° 7',
          'Sept utilisateurs au hasard',
          'Le serveur n° 7',
        ],
        correctChoiceIndex: 1,
      ),
      Exercise(
        id: 'ex-rest-2',
        title: 'CRUD et verbes',
        moduleId: 'rest',
        category: 'REST',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.choice,
        objective: 'Correspondance CRUD ↔ HTTP.',
        instructions: 'Quel couple (opération, verbe) est correct ?',
        hints: [
          'Créer correspond au verbe qui « poste ».',
          'Lire correspond à GET.',
        ],
        solution: 'CREATE → POST, READ → GET',
        solutionExplanation: 'CREATE utilise POST, READ utilise GET, UPDATE utilise PUT/PATCH, '
            'DELETE utilise DELETE.',
        choices: [
          'CREATE → GET, READ → POST',
          'CREATE → POST, READ → GET',
          'DELETE → GET, CREATE → DELETE',
          'UPDATE → DELETE, READ → PUT',
        ],
        correctChoiceIndex: 1,
      ),
      Exercise(
        id: 'ex-rest-3',
        title: 'Le CRUD en action',
        moduleId: 'rest',
        category: 'REST',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.code,
        objective: 'Écrire les 4 opérations CRUD.',
        instructions: 'Écrivez le code jQuery (4 requêtes) pour : lire la liste /api/todos, créer un '
            'todo avec title, mettre à jour le todo 1 avec done: true, et supprimer le todo 1.',
        hints: [
          'Lire : \$.get. Créer : \$.post. Mettre à jour : \$.ajax method PATCH. Supprimer : '
              '\$.ajax method DELETE.',
          'Chaque URL correspond à l\'endpoint de la ressource.',
        ],
        solution: r'''$.get('/api/todos');
$.post('/api/todos', { title: 'Faire les courses' });
$.ajax({ url: '/api/todos/1', method: 'PATCH', data: { done: true } });
$.ajax({ url: '/api/todos/1', method: 'DELETE' });''',
        solutionExplanation: 'GET lit, POST crée, PATCH modifie partiellement, DELETE supprime. '
            'L\'URL identifie la ressource.',
        rule: const ValidationRule(
          patterns: [
            r"<jq>\.(?:get|getJSON)\('/api/todos/?'|<jq>\.ajax\(\{(?=[^;]*'/api/todos/?')[^;]*'GET'",
            r"<jq>\.post\('/api/todos/?',[^;]*\btitle\b|<jq>\.ajax\(\{(?=[^;]*\btitle\b)(?=[^;]*'/api/todos/?')[^;]*'POST'",
            r"<jq>\.ajax\(\{(?=[^;]*'/api/todos/1')(?=[^;]*\bdone'?:true)[^;]*'(?:PATCH|PUT)'",
            r"<jq>\.ajax\(\{(?=[^;]*'/api/todos/1')[^;]*'DELETE'",
          ],
          feedback: 'Rappel : GET lit, POST crée, PATCH modifie, DELETE supprime — écrivez les '
              'quatre requêtes.',
        ),
      ),
      // ============================= MODERNE =============================
      Exercise(
        id: 'ex-modern-1',
        title: 'Charger avec fetch',
        moduleId: 'modern',
        category: 'AJAX',
        level: ExerciseLevel.guided,
        type: ExerciseType.code,
        objective: 'Premier fetch().',
        instructions: 'Écrivez fetch("https://jsonplaceholder.typicode.com/users") avec .then(response '
            '=> response.json()) puis .then(data => console.log(data)).',
        hints: [
          'fetch renvoie une Promise : on enchaîne avec .then().',
          'Le premier then extrait le JSON avec response.json().',
        ],
        solution: r'''fetch('https://jsonplaceholder.typicode.com/users')
  .then(response => response.json())
  .then(data => console.log(data));''',
        solutionExplanation: 'fetch récupère la réponse, le premier then l\'extrait en JSON, le '
            'second affiche les données.',
        rule: const ValidationRule(
          patterns: [
            r"\bfetch\('https://jsonplaceholder\.typicode\.com/users/?'\)",
            r"\.then\((?:\(?\w+\)?=>(?:\{return )?|function ?\w*\(\w+\)\{return )\w+\.json\(\)",
            r"\.then\(.*console\.log\b",
          ],
          feedback: 'Rappel : fetch( url ).then( response => response.json() ).then( data => … ).',
        ),
      ),
      Exercise(
        id: 'ex-modern-2',
        title: 'async / await',
        moduleId: 'modern',
        category: 'AJAX',
        level: ExerciseLevel.semiGuided,
        type: ExerciseType.code,
        objective: 'Réécrire avec async/await.',
        instructions: 'Écrivez une fonction async charger() qui fait const response = await '
            'fetch(url); const data = await response.json(); console.log(data);',
        hints: [
          'La fonction commence par async function charger() { … }',
          'await attend chaque étape avant la suivante.',
        ],
        solution: r'''async function charger() {
  const response = await fetch('https://jsonplaceholder.typicode.com/users');
  const data = await response.json();
  console.log(data);
}''',
        solutionExplanation: 'async marque la fonction, await suspend jusqu\'au résultat : le code '
            'se lit dans l\'ordre.',
        rule: const ValidationRule(
          patterns: [
            r"\basync function charger\(|\bcharger=async\b",
            r"\bawait fetch\(",
            r"\bawait \w+\.json\(\)|\bawait\(await fetch\(.*\)\)\.json\(\)",
            r"console\.log\(",
          ],
          feedback: 'Rappel : async function … et await pour chaque étape.',
        ),
      ),
      Exercise(
        id: 'ex-modern-3',
        title: 'try / catch',
        moduleId: 'modern',
        category: 'AJAX',
        level: ExerciseLevel.autonomous,
        type: ExerciseType.code,
        objective: 'Protéger une requête avec try/catch.',
        instructions: 'Dans une fonction async charger(), entourez le code await de try { … } et '
            'attrapez l\'erreur dans catch (erreur) { console.error(erreur); }.',
        hints: [
          'Le code qui peut échouer va dans le bloc try.',
          'Le bloc catch reçoit l\'erreur en paramètre.',
        ],
        solution: r'''async function charger() {
  try {
    const response = await fetch('https://jsonplaceholder.typicode.com/users');
    const data = await response.json();
    console.log(data);
  } catch (erreur) {
    console.error(erreur);
  }
}''',
        solutionExplanation: 'Toute erreur (réseau, HTTP, JSON) est capturée par catch et '
            'journalisée.',
        rule: const ValidationRule(
          patterns: [
            r"\basync function charger\(|\bcharger=async\b",
            r"\btry\{.*\bawait\b.*\}catch\(\w+\)\{.*console\.(?:error|log)\(",
          ],
          feedback: 'Rappel : try { … } catch (erreur) { … } protège le code asynchrone.',
        ),
      ),
    ];
