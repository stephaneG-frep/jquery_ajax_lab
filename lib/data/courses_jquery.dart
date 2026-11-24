import 'package:flutter/material.dart';

import '../models/content_block.dart';
import '../models/course.dart';

/// MODULES 4 à 7 : jQuery, manipulation du DOM, événements, animations.
List<CourseModule> jqueryModules() => [
      CourseModule(
        id: 'jquery',
        number: 4,
        title: 'Découvrir jQuery',
        subtitle: 'Pourquoi la bibliothèque a été créée, et comment l\'utiliser.',
        icon: Icons.bolt,
        sections: [
          CourseSection(
            id: 'jquery-4-1',
            moduleId: 'jquery',
            order: 1,
            title: 'Pourquoi jQuery a été créé',
            blocks: [
              const ParagraphBlock(
                  'jQuery est une **bibliothèque JavaScript** créée par John Resig en 2006. '
                  'À l\'époque, les navigateurs ne se comportaient pas tous de la même manière : '
                  'un même code fonctionnait sur un navigateur et cassait sur un autre.'),
              const BulletsBlock([
                'jQuery unifie le comportement entre navigateurs.',
                'jQuery raccourcit la syntaxe : moins de code pour le même résultat.',
                'jQuery sélectionne facilement les éléments du DOM avec la fonction \$.',
                'jQuery gère simplement les événements, les animations et AJAX.',
              ]),
              const ConceptCardBlock(
                icon: Icons.history_edu,
                title: 'Un contexte historique',
                text: 'Dans les années 2010, jQuery équipait l\'immense majorité des sites web. '
                    'Elle a profondément influencé les standards qui ont suivi.',
              ),
              const ParagraphBlock(
                  'Aujourd\'hui, JavaScript moderne (querySelector, fetch, addEventListener…) permet de faire '
                  'quasiment tout ce que jQuery faisait, sans bibliothèque. Mais comprendre jQuery reste '
                  'excellent pour lire l\'ancien code, et les concepts (sélecteurs, callbacks, AJAX) sont '
                  'les mêmes partout.'),
              const TipBlock(
                  'Ce parcours vous fait voir le même geste « à l\'ancienne » (jQuery) puis « moderne » : '
                  'à la fin, vous saurez lire et écrire les deux.'),
            ],
          ),
          CourseSection(
            id: 'jquery-4-2',
            moduleId: 'jquery',
            order: 2,
            title: 'Le document prêt : \$(document).ready()',
            blocks: [
              const ParagraphBlock(
                  'Le JavaScript d\'une page ne doit agir sur le DOM que lorsque le DOM est **construit**. '
                  'jQuery propose un bloc standard qui attend que la page soit prête :'),
              const CodeBlock(
                '''\$(document).ready(function () {
  // Ce code s'exécute quand la page est prête
  console.log('La page est prête !');
});''',
                explanation: 'Le callback s\'exécute dès que le DOM est disponible, avant même le chargement des images.',
                lineByLine: true,
              ),
              const ParagraphBlock('Il existe une version raccourcie, identique :'),
              const CodeBlock(
                '''\$(function () {
  console.log('La page est prête !');
});''',
                explanation: '\$(function(){}) est l\'équivalent exact de \$(document).ready().',
              ),
              const InfoBlock(
                  'Dans le laboratoire de cette application, le bloc ready est automatiquement respecté : '
                  'votre code est exécuté une fois jQuery chargé et le document prêt.'),
              const WarningBlock(
                  'Sans ce bloc, votre code peut chercher un élément pas encore créé et ne rien trouver. '
                  'C\'est l\'erreur n°1 des débutants.'),
            ],
          ),
          CourseSection(
            id: 'jquery-4-3',
            moduleId: 'jquery',
            order: 3,
            title: 'La fonction \$ et les sélecteurs',
            blocks: [
              const ParagraphBlock(
                  '**\$** est le nom de la fonction principale de jQuery. Elle sert d\'abord à **sélectionner** '
                  'des éléments. Le résultat est un « objet jQuery » qui expose toutes les méthodes utiles.'),
              const TableBlock(
                headers: ['Sélecteur', 'Cible', 'Exemple'],
                rows: [
                  ['\$( "p" )', 'Tous les paragraphes', '\$("p").css("color", "red")'],
                  ['\$( "#titre" )', 'L\'élément avec id="titre"', '\$("#titre").text("Coucou")'],
                  ['\$( ".card" )', 'Tous les éléments class="card"', '\$(".card").hide()'],
                  ['\$( "input" )', 'Tous les champs input', '\$("input").val()'],
                ],
              ),
              const CodeBlock(
                '''// Sélectionner et agir
\$('p').css('color', 'blue');        // tous les <p>
\$('#titre').text('Nouveau titre');  // l'élément id="titre"
\$('.card').addClass('active');      // tous les .card
\$('input').attr('placeholder', '…'); // tous les champs''',
                explanation: 'Chaque sélecteur renvoie un objet jQuery sur lequel on enchaîne des actions.',
              ),
              const ParagraphBlock(
                  'Le sélecteur est celui du **CSS** : # pour un id, . pour une classe, le nom de balise '
                  'pour les balises. Tout ce que vous savez en CSS vous sert directement ici.'),
              const TipBlock(
                  'Dans le laboratoire, essayez : HTML avec <p id="demo">, puis la ligne '
                  '\$("#demo").text("Modifié !") — le paragraphe change aussitôt.'),
              const ExerciseLinkBlock('ex-jquery-1'),
            ],
          ),
          CourseSection(
            id: 'jquery-4-4',
            moduleId: 'jquery',
            order: 4,
            title: 'Sélecteurs avancés',
            blocks: [
              const ParagraphBlock('Comme en CSS, jQuery accepte des sélecteurs combinés :'),
              const CodeBlock(
                '''// Combinaisons
\$('.card.active')        // éléments avec les DEUX classes
\$('ul li')               // tous les <li> dans un <ul>
\$('#liste > li')         // enfants directs uniquement
\$('p:first')             // premier paragraphe
\$('li:even')             // éléments pairs (index pair)
\$('input[type="text"]')  // champs de type texte
\$('input:checked')       // cases cochées''',
                explanation: 'Les sélecteurs CSS s\'utilisent tels quels dans \$().',
              ),
              const ParagraphBlock('On peut aussi **filtrer** un résultat :'),
              const CodeBlock(
                '''\$('li').first()   // premier élément
\$('li').last()    // dernier élément
\$('li').eq(2)     // élément d'index 2 (le troisième)
\$('li').filter(':hidden') // seulement les cachés''',
                explanation: 'first, last, eq et filter affinent une sélection.',
              ),
              const InfoBlock(
                  'Ces sélecteurs sont utilisés partout dans les exercices : prenez l\'habitude de lire '
                  'une sélection comme on lit un sélecteur CSS.'),
            ],
          ),
          CourseSection(
            id: 'jquery-4-5',
            moduleId: 'jquery',
            order: 5,
            title: 'Traverser le DOM : find, parent, children, closest',
            blocks: [
              const ParagraphBlock(
                  'Sélectionner, c\'est bien. **Naviguer** dans l\'arbre autour d\'une sélection, c\'est souvent '
                  'nécessaire : les méthodes de traversée parcourent parents, enfants et voisins.'),
              const CodeBlock(
                '''// Partons de l'élément #btn
\$('#btn').parent()           // son parent direct
\$('#btn').parents('.zone')   // tous les parents qui ont la classe .zone
\$('#btn').closest('.zone')   // le plus proche parent .zone (lui-même compris)
\$('#zone').children('p')     // les enfants <p> directs
\$('#zone').find('.item')     // tous les descendants .item
\$('#btn').siblings('button') // les frères et sœurs <button>''',
                explanation: 'parent, parents, closest, children, find et siblings couvrent les parcours essentiels.',
              ),
              const CodeBlock(
                '''<div class="zone">
  <div class="carte">
    <button id="suppr" class="supprimer">Supprimer</button>
  </div>
</div>

// Depuis le bouton, remonter à la carte :
\$('#suppr').closest('.carte').remove();''',
                explanation: 'closest() remonte jusqu\'au parent .carte, puis remove() le supprime : '
                    'c\'est la technique classique des boutons de suppression.',
              ),
              const ConceptCardBlock(
                icon: Icons.account_tree,
                title: 'La bonne mentalité',
                text: 'Lisez de l\'intérieur vers l\'extérieur : « je pars du bouton, je remonte à la carte, '
                    'je la supprime ». Chaque méthode transforme la sélection.',
              ),
              const ExerciseLinkBlock('ex-jquery-2'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'dom',
        number: 5,
        title: 'Manipulation du DOM',
        subtitle: 'Lire, écrire, ajouter et retirer des éléments.',
        icon: Icons.dashboard_customize,
        sections: [
          CourseSection(
            id: 'dom-5-1',
            moduleId: 'dom',
            order: 1,
            title: '.text() et .html() : lire et écrire du contenu',
            blocks: [
              const ParagraphBlock(
                  '**.text()** lit ou remplace le texte d\'un élément. **.html()** lit ou remplace son HTML '
                  'interne (les balises comprises).'),
              const CodeBlock(
                '''// Sans argument : on lit
const contenu = \$('#zone').text();

// Avec argument : on écrit
\$('#titre').text('Bonjour');
\$('#zone').html('<p>Nouveau <b>paragraphe</b></p>');''',
                explanation: 'text() traite le contenu comme du texte brut ; html() comme du HTML.',
              ),
              const ParagraphBlock('Différence essentielle :'),
              const CodeBlock(
                '''// text() : la balise est écrite telle quelle (sans danger)
\$('#out').text('<b>gras ?</b>');   // affiche : <b>gras ?</b>

// html() : la balise est interprétée
\$('#out').html('<b>gras ?</b>');   // affiche : gras ? (en gras)''',
                explanation: 'text() est plus sûr quand le contenu vient de l\'utilisateur.',
              ),
              const WarningBlock(
                  'N\'insérez jamais de contenu utilisateur avec .html() sans l\'assainir : c\'est une '
                  'faille XSS. Préférez .text() quand le contenu n\'est pas sûr.'),
              const ExerciseLinkBlock('ex-dom-1'),
            ],
          ),
          CourseSection(
            id: 'dom-5-2',
            moduleId: 'dom',
            order: 2,
            title: '.val() : la valeur des champs de formulaire',
            blocks: [
              const ParagraphBlock(
                  '**.val()** lit ou définit la **valeur** d\'un champ de formulaire (input, select, textarea).'),
              const CodeBlock(
                '''// Lire la valeur saisie
const nom = \$('#nom').val();

// Définir une valeur
\$('#nom').val('Alice');''',
                explanation: 'val() sans argument lit, avec argument écrit.',
              ),
              const CodeBlock(
                '''<input type="text" id="prenom" value="Bob">

<script>
  console.log(\$('#prenom').val());   // → Bob (valeur initiale)
  \$('#prenom').val('Chloé');         // remplace la valeur
</script>''',
                explanation: 'val() reflète ce que l\'utilisateur voit et tape dans le champ.',
              ),
              const TipBlock(
                  'La valeur lue est toujours une chaîne. Convertissez-la avec Number() avant un calcul : '
                  'Number(\$(\'#age\').val()).'),
              const ExerciseLinkBlock('ex-dom-2'),
            ],
          ),
          CourseSection(
            id: 'dom-5-3',
            moduleId: 'dom',
            order: 3,
            title: '.attr() et .css()',
            blocks: [
              const ParagraphBlock(
                  '**.attr()** lit ou modifie un **attribut** (id, href, src, data-*…). '
                  '**.css()** lit ou modifie le **style** en ligne d\'un élément.'),
              const CodeBlock(
                '''// Attributs
\$('#lien').attr('href', 'https://example.com');
\$('#btn').attr('disabled', true);
const type = \$('#champ').attr('type'); // → text

// Style
\$('#carte').css('background', '#eef');
\$('#carte').css({
  color: 'white',
  padding: '16px',
  borderRadius: '8px'
});''',
                explanation: 'attr() agit sur les attributs, css() sur les styles en ligne.',
              ),
              const ParagraphBlock('jQuery préfère gérer le style par les **classes** :'),
              const CodeBlock(
                '''\$('#carte').addClass('active');
\$('#carte').removeClass('active');
\$('#carte').toggleClass('active');
\$('#carte').hasClass('active'); // → true/false''',
                explanation: 'addClass, removeClass, toggleClass et hasClass manipulent les classes.',
              ),
              const TipBlock(
                  'Écrivez le style dans votre CSS et utilisez les classes pour l\'activer : c\'est plus '
                  'performant et plus maintenable que les styles en ligne.'),
              const ExerciseLinkBlock('ex-dom-3'),
            ],
          ),
          CourseSection(
            id: 'dom-5-4',
            moduleId: 'dom',
            order: 4,
            title: 'Ajouter : append, prepend, before, after',
            blocks: [
              const ParagraphBlock(
                  'Quatre méthodes ajoutent du contenu autour d\'un élément :'),
              const CodeBlock(
                '''\$('#liste').append('<li>À la fin</li>');    // dernier enfant
\$('#liste').prepend('<li>Au début</li>');   // premier enfant
\$('#element').before('<p>Avant</p>');       // avant l'élément
\$('#element').after('<p>Après</p>');        // après l'élément''',
                explanation: 'append/prepend ajoutent à l\'intérieur ; before/after ajoutent autour.',
              ),
              const ParagraphBlock(
                  'On peut aussi **créer** un élément jQuery puis l\'insérer, ou insérer un élément existant '
                  '(ce qui le **déplace**) :'),
              const CodeBlock(
                '''// Créer puis insérer
const li = \$('<li>').text('Nouvel item').addClass('item');
\$('#liste').append(li);

// Déplacer un élément existant
\$('#liste').append(\$('#item-courant'));''',
                explanation: 'Ajouter un élément déjà présent le déplace à son nouvel emplacement.',
              ),
              const ConceptCardBlock(
                icon: Icons.drag_handle,
                title: 'Pour les listes dynamiques',
                text: 'append() est la méthode reine des to-do list : à chaque ajout, on fabrique un <li> '
                    'et on le colle à la liste.',
              ),
              const ExerciseLinkBlock('ex-dom-4'),
            ],
          ),
          CourseSection(
            id: 'dom-5-5',
            moduleId: 'dom',
            order: 5,
            title: 'Retirer : remove() et empty()',
            blocks: [
              const ParagraphBlock(
                  '**.remove()** supprime l\'élément (et ses enfants) **du DOM**. '
                  '**.empty()** supprime seulement les **enfants**, en gardant l\'élément.'),
              const CodeBlock(
                '''\$('#zone').remove();  // #zone disparaît complètement
\$('#zone').empty();    // #zone reste, vide''',
                explanation: 'remove jette l\'élément, empty le vide.',
              ),
              const CodeBlock(
                '''// Retirer tous les <li> d'une liste
\$('#liste li').remove();

// Vider une zone puis remplir
\$('#resultats').empty().append('<p>Prêt</p>');''',
                explanation: 'Le chaînage empty().append() est un idiome très courant.',
              ),
              const ComparisonBlock(
                title: 'remove() moderne',
                jquery: '''\$('#zone').remove();''',
                modern: '''document.querySelector('#zone').remove();''',
                note: 'Le moderne est presque identique : c\'est une des méthodes que les standards ont reprises de jQuery.',
              ),
              const ExerciseLinkBlock('ex-dom-5'),
            ],
          ),
          CourseSection(
            id: 'dom-5-6',
            moduleId: 'dom',
            order: 6,
            title: 'Le chaînage des méthodes',
            blocks: [
              const ParagraphBlock(
                  'La plupart des méthodes jQuery renvoient l\'objet jQuery lui-même : on peut donc **enchaîner** '
                  'les appels sur une seule ligne.'),
              const CodeBlock(
                '''\$('#btn')
  .addClass('active')
  .text('Activé')
  .css('background', 'green')
  .on('click', function () {
    alert('Prêt !');
  });''',
                explanation: 'Chaque méthode retourne la sélection, la suivante agit dessus.',
              ),
              const ParagraphBlock('Le chaînage rend le code dense mais lisible, une ligne par action.'),
              const TipBlock(
                  'Si une méthode doit renvoyer une valeur (comme .text() sans argument), elle rompt le '
                  'chaînage — logique : on lit, on n\'écrit plus.'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'events',
        number: 6,
        title: 'Événements',
        subtitle: 'Réagir aux clics, saisies, envois de formulaire…',
        icon: Icons.touch_app,
        sections: [
          CourseSection(
            id: 'events-6-1',
            moduleId: 'events',
            order: 1,
            title: 'click(), change() et submit()',
            blocks: [
              const ParagraphBlock(
                  'Les méthodes raccourcies installent un gestionnaire d\'événement. Le callback reçoit un '
                  'objet **event** (souvent abrégé e) avec des informations utiles.'),
              const CodeBlock(
                '''\$('#btn').click(function () {
  alert('Clic reçu !');
});

\$('#select-ville').change(function () {
  console.log('Ville choisie :', \$(this).val());
});

\$('#formulaire').submit(function (e) {
  e.preventDefault(); // empêche le rechargement de la page
  console.log('Formulaire envoyé');
});''',
                explanation: 'click au clic, change quand la valeur change, submit à l\'envoi du formulaire.',
              ),
              const ParagraphBlock(
                  '**preventDefault()** est crucial pour submit : sans lui, le navigateur recharge la page '
                  'et votre code AJAX serait interrompu.'),
              const WarningBlock(
                  'Un submit sans e.preventDefault() est la cause classique des « mon AJAX ne marche pas » : '
                  'la page se recharge avant la fin de la requête.'),
              const ExerciseLinkBlock('ex-events-1'),
            ],
          ),
          CourseSection(
            id: 'events-6-2',
            moduleId: 'events',
            order: 2,
            title: 'hover() et keyup()',
            blocks: [
              const ParagraphBlock(
                  '**.hover()** gère l\'entrée et la sortie de la souris en un seul appel. '
                  '**.keyup()** se déclenche à chaque fois qu\'une touche est relâchée dans un champ.'),
              const CodeBlock(
                '''\$('#carte').hover(
  function () { \$(this).addClass('survole'); }, // entrée
  function () { \$(this).removeClass('survole'); } // sortie
);''',
                explanation: 'Deux callbacks : entrée de souris, puis sortie.',
              ),
              const CodeBlock(
                '''\$('#recherche').keyup(function () {
  const valeur = \$(this).val();
  console.log('Vous tapez :', valeur);
});''',
                explanation: 'À chaque frappe, on lit la valeur du champ. Base de la recherche instantanée.',
              ),
              const TipBlock(
                  'keyup() est le point de départ de la « recherche instantanée » : à chaque frappe, on '
                  'filtre une liste ou on interroge une API. Vous le retrouverez dans les mini-projets.'),
              const ExerciseLinkBlock('ex-events-2'),
            ],
          ),
          CourseSection(
            id: 'events-6-3',
            moduleId: 'events',
            order: 3,
            title: 'La méthode .on() : la plus importante',
            blocks: [
              const ParagraphBlock(
                  'Depuis jQuery 1.7, la méthode **.on()** est la façon recommandée d\'attacher TOUS les '
                  'événements. Les raccourcis (.click(), .hover()…) ne sont que des déguisements de .on().'),
              const CodeBlock(
                '''// .on() : le nom de l'événement en premier argument
\$('#bouton').on('click', function () {
  \$('#message').text('Bonjour !');
});''',
                explanation: 'Premier argument : l\'événement. Second : le callback.',
              ),
              const ParagraphBlock('On peut écouter plusieurs événements à la fois :'),
              const CodeBlock(
                '''\$('#champ').on('focus blur', function () {
  console.log('focus ou blur');
});

\$('#btn').on('mouseenter mouseleave', function () {
  \$(this).toggleClass('active');
});''',
                explanation: 'Plusieurs événements, un callback : listez-les séparés par un espace.',
              ),
              const ParagraphBlock('On peut aussi passer un objet d\'événements vers callbacks :'),
              const CodeBlock(
                '''\$('#btn').on({
  click: function () { console.log('clic'); },
  mouseenter: function () { console.log('entrée'); }
});''',
                explanation: 'La forme objet associe chaque événement à sa fonction.',
              ),
              const InfoBlock(
                  'Règle simple : utilisez toujours .on(). Vous saurez alors lire n\'importe quel code jQuery, '
                  'et le passage à JavaScript moderne (addEventListener) sera naturel.'),
              const ExerciseLinkBlock('ex-events-3'),
            ],
          ),
          CourseSection(
            id: 'events-6-4',
            moduleId: 'events',
            order: 4,
            title: '\$(this) : l\'élément concerné',
            blocks: [
              const ParagraphBlock(
                  'À l\'intérieur d\'un callback, **\$(this)** représente l\'élément qui a déclenché l\'événement. '
                  'Cela évite de resélectionner par un id : on agit sur l\'élément cliqué, quel qu\'il soit.'),
              const CodeBlock(
                '''// Plusieurs boutons, un seul gestionnaire
<button class="bouton">Un</button>
<button class="bouton">Deux</button>
<button class="bouton">Trois</button>

<script>
  \$('.bouton').on('click', function () {
    \$(this).text('Cliqué !'); // agit sur le bouton cliqué
    \$(this).css('background', 'green');
  });
</script>''',
                explanation: 'Chaque clic agit sur le bouton précis qui a été cliqué.',
              ),
              const ParagraphBlock(
                  'Sans \$(this), il faudrait deviner quel bouton : c\'est le mécanisme le plus utile '
                  'pour les listes de boutons identiques.'),
              const TipBlock(
                  'Souvenez-vous : dans un callback d\'événement jQuery, \$(this) vaut l\'élément déclencheur '
                  '(ou sa version jQuery). Utilisez-le systématiquement.'),
              const ExerciseLinkBlock('ex-events-4'),
            ],
          ),
          CourseSection(
            id: 'events-6-5',
            moduleId: 'events',
            order: 5,
            title: 'La délégation d\'événements',
            blocks: [
              const ParagraphBlock(
                  'Imaginons une liste à laquelle on ajoute des éléments dynamiquement avec .append(). '
                  'Un simple .on() sur les <li> ne fonctionnera pas pour les nouveaux éléments, car ils '
                  'n\'existaient pas encore.'),
              const ParagraphBlock(
                  'La **délégation** consiste à écouter sur un ancêtre stable (ex. la liste), en précisant '
                  'un sélecteur cible : jQuery écoute les clics qui « remontent » jusqu\'à l\'ancêtre.'),
              const CodeBlock(
                '''// DÉLÉGUÉ : fonctionne même pour les <li> ajoutés plus tard
\$('#liste').on('click', 'li', function () {
  \$(this).toggleClass('fait');
});

// NON délégué : échoue pour les <li> ajoutés après coup
\$('#liste li').on('click', function () {
  \$(this).toggleClass('fait');
});''',
                explanation: 'Le second argument de .on() est le sélecteur cible : c\'est la délégation.',
              ),
              const ParagraphBlock(
                  'La délégation est aussi la clé des boutons « supprimer » dans une liste dynamique :'),
              const CodeBlock(
                '''\$('#liste').on('click', '.supprimer', function () {
  \$(this).closest('li').remove();
});''',
                explanation: 'Le clic est capté par la liste, qui vérifie si la cible est .supprimer, puis '
                    'supprime le <li> parent.',
              ),
              const ConceptCardBlock(
                icon: Icons.alt_route,
                title: 'La règle d\'or',
                text: 'Tout élément créé APRÈS le chargement doit recevoir ses événements par délégation '
                    'sur un ancêtre stable, avec .on(événement, cible, callback).',
              ),
              const ExerciseLinkBlock('ex-events-5'),
            ],
          ),
        ],
      ),
      CourseModule(
        id: 'anim',
        number: 7,
        title: 'Animations jQuery',
        subtitle: 'Montrer, cacher, fondre, glisser et animer.',
        icon: Icons.animation,
        sections: [
          CourseSection(
            id: 'anim-7-1',
            moduleId: 'anim',
            order: 1,
            title: 'show(), hide() et toggle()',
            blocks: [
              const ParagraphBlock(
                  'Les méthodes de base affichent et masquent les éléments, avec une **durée** optionnelle '
                  'en millisecondes (400 par défaut).'),
              const CodeBlock(
                '''\$('#zone').hide();            // masque aussitôt
\$('#zone').show();            // affiche aussitôt
\$('#zone').toggle();          // bascule visible/caché

\$('#zone').hide(600);         // masque en 600 ms (fondu)
\$('#zone').show(600);         // affiche en 600 ms
\$('#zone').toggle(300);       // bascule en 300 ms''',
                explanation: 'hide/show/toggle acceptent une durée pour un effet progressif.',
              ),
              const CodeBlock(
                '''\$('#bouton').on('click', function () {
  \$('#zone').toggle(300);
});''',
                explanation: 'Le bouton affiche/masque la zone à chaque clic : le petit frère du mini-projet 1.',
              ),
              const TipBlock(
                  'Testez tout cela dans le laboratoire : un bouton + une zone, et toggle() fera le reste.'),
              const ExerciseLinkBlock('ex-anim-1'),
            ],
          ),
          CourseSection(
            id: 'anim-7-2',
            moduleId: 'anim',
            order: 2,
            title: 'fadeIn(), fadeOut(), fadeToggle()',
            blocks: [
              const ParagraphBlock(
                  'Les fondus jouent sur l\'**opacité**. Le résultat est élégant et très utilisé dans les '
                  'interfaces.'),
              const CodeBlock(
                '''\$('#zone').fadeIn(600);      // apparaît en fondu
\$('#zone').fadeOut(600);     // disparaît en fondu
\$('#zone').fadeToggle(400);  // bascule avec fondu
\$('#zone').fadeTo(500, 0.5); // opacité ciblée : 50 %''',
                explanation: 'fade* joue sur l\'opacité ; fadeTo fixe une opacité précise.',
              ),
              const CodeBlock(
                '''// Enchaîner : masquer en fondu puis retirer du DOM
\$('#banner').fadeOut(500, function () {
  \$(this).remove();
});''',
                explanation: 'Le callback s\'exécute à la fin de l\'animation : idéal pour nettoyer le DOM.',
              ),
              const TipBlock(
                  'Passez toujours une durée explicite : sans durée, fadeOut est instantané et l\'effet '
                  'perd tout son intérêt.'),
              const ExerciseLinkBlock('ex-anim-2'),
            ],
          ),
          CourseSection(
            id: 'anim-7-3',
            moduleId: 'anim',
            order: 3,
            title: 'slideUp(), slideDown(), slideToggle()',
            blocks: [
              const ParagraphBlock(
                  'Les glissements jouent sur la **hauteur** : l\'élément se replie comme un store. '
                  'Parfait pour les menus et les accordéons.'),
              const CodeBlock(
                '''\$('#panneau').slideDown(400); // se déplie
\$('#panneau').slideUp(400);   // se replie
\$('#panneau').slideToggle(300); // bascule en glissant''',
                explanation: 'slide* joue sur la hauteur de l\'élément.',
              ),
              const CodeBlock(
                '''// Menu accordéon : un seul panneau ouvert
\$('.titre-menu').on('click', function () {
  \$('.panneau').slideUp(300);        // ferme tout
  \$(this).next().slideDown(300);     // ouvre celui cliqué
});''',
                explanation: 'next() va au panneau suivant le titre cliqué : le geste de l\'accordéon.',
              ),
              const ExerciseLinkBlock('ex-anim-3'),
            ],
          ),
          CourseSection(
            id: 'anim-7-4',
            moduleId: 'anim',
            order: 4,
            title: 'animate() : animer n\'importe quelle propriété',
            blocks: [
              const ParagraphBlock(
                  '**.animate()** est le couteau suisse : il anime n\'importe quelle propriété CSS numérique '
                  '(position, taille, opacité…).'),
              const CodeBlock(
                '''\$('#boite').animate({
  left: '+=100px',
  opacity: 0.5,
  width: '200px'
}, 1000);''',
                explanation: 'En 1 seconde, la boîte se déplace de 100 px, devient semi-transparente et s\'élargit.',
              ),
              const ParagraphBlock('On peut enchaîner des animations :'),
              const CodeBlock(
                '''\$('#balle')
  .animate({ left: '+=200px' }, 500)
  .animate({ top: '+=100px' }, 500)
  .animate({ opacity: 0.2 }, 300);''',
                explanation: 'Chaque animate() attend la fin du précédent avant de démarrer.',
              ),
              const ParagraphBlock('animate() ne fonctionne que sur les propriétés **numériques** (pas de color, par exemple).'),
              const WarningBlock(
                  'Si vous devez animer des couleurs ou des transformations complexes, le moderne préférera '
                  'les CSS transitions ou l\'API Web Animations : jQuery reste parfait pour le basique.'),
              const ExerciseLinkBlock('ex-anim-4'),
            ],
          ),
          CourseSection(
            id: 'anim-7-5',
            moduleId: 'anim',
            order: 5,
            title: 'Les callbacks de fin d\'animation',
            blocks: [
              const ParagraphBlock(
                  'Toutes les animations acceptent un **callback** exécuté une fois l\'effet terminé. '
                  'C\'est le moyen propre d\'enchaîner une action « après ».'),
              const CodeBlock(
                '''\$('#zone').fadeOut(500, function () {
  console.log('L'animation est terminée');
  \$('#zone').remove();
});''',
                explanation: 'Le callback s\'exécute à la fin du fondu.',
              ),
              const ParagraphBlock(
                  'C\'est le même modèle de **callback** que les événements et AJAX : un bloc de code '
                  '« pour plus tard ». Vous êtes maintenant à l\'aise avec ce concept — AJAX va l\'utiliser '
                  'intensivement.'),
              const TipBlock(
                  'Règle : ne placez PAS la suite du programme juste après l\'appel d\'animation — elle '
                  's\'exécuterait avant la fin. Utilisez le callback.'),
            ],
          ),
        ],
      ),
    ];
