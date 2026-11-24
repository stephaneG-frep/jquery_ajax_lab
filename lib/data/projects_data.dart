import 'package:flutter/material.dart';

import '../models/project.dart';

/// Les 10 mini-projets plus le projet final « AJAX Dashboard ».
List<MiniProject> allProjects() => [
      MiniProject(
        id: 'p1-afficher-masquer',
        title: 'Afficher / masquer des éléments',
        category: 'Animations',
        icon: Icons.visibility,
        intro: 'Apprenez à faire apparaître et disparaître des éléments avec jQuery, '
            'avec un effet de fondu élégant.',
        objectives: [
          'Écouter un clic avec .on()',
          'Basculer la visibilité avec .toggle() / .fadeToggle()',
          'Changer le texte d\'un bouton selon l\'état',
        ],
        tasks: [
          ProjectTask(
            title: 'Préparer la page',
            instruction: 'Créez un bouton #btn et une zone #zone contenant un paragraphe de texte.',
            hint: 'Le bouton doit être placé avant ou après la zone, peu importe : les deux ont un id.',
            solution: r'''<button id="btn">Afficher / masquer</button>
<div id="zone">
  <p>Ce contenu peut être affiché ou masqué.</p>
</div>''',
          ),
          ProjectTask(
            title: 'Basculer la visibilité',
            instruction: 'Au clic sur #btn, basculez la zone #zone avec fadeToggle(300).',
            hint: 'fadeToggle combine fadeIn et fadeOut : un seul appel suffit.',
            solution: r'''$('#btn').on('click', function () {
  $('#zone').fadeToggle(300);
});''',
          ),
          ProjectTask(
            title: 'Changer le libellé du bouton',
            instruction: 'Changez le texte du bouton en « Masquer » ou « Afficher » selon l\'état de la zone.',
            hint: 'Pendant le fondu, la zone est encore visible : testez .is(":visible") dans le '
                'callback de fin de fadeToggle().',
            solution: r'''$('#btn').on('click', function () {
  $('#zone').fadeToggle(300, function () {
    // Ici, l'animation est finie : $(this) est la zone.
    $('#btn').text($(this).is(':visible') ? 'Masquer' : 'Afficher');
  });
});''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<button id="btn">Afficher / masquer</button>
<div id="zone">
  <p>Ce contenu peut être affiché ou masqué.</p>
</div>''',
        finalCode: r'''<button id="btn">Afficher / masquer</button>
<div id="zone">
  <p>Ce contenu peut être affiché ou masqué.</p>
</div>

<script>
$('#btn').on('click', function () {
  $('#zone').fadeToggle(300, function () {
    // Ici, l'animation est finie : $(this) est la zone.
    $('#btn').text($(this).is(':visible') ? 'Masquer' : 'Afficher');
  });
});
</script>''',
      ),
      MiniProject(
        id: 'p2-galerie',
        title: 'Galerie interactive',
        category: 'jQuery',
        icon: Icons.photo_library,
        intro: 'Construisez une petite galerie : les vignettes changent l\'image principale '
            'et des boutons la parcourent.',
        objectives: [
          'Parcourir un tableau avec each()',
          'Changer la source d\'une image avec .attr()',
          'Gérer le précédent / suivant',
        ],
        tasks: [
          ProjectTask(
            title: 'La structure',
            instruction: 'Créez une image #grande, une liste de vignettes .mini (img), et deux '
                'boutons #prev et #next.',
            hint: 'Utilisez des URLs d\'images publiques (ex. picsum.photos).',
            solution: r'''<img id="grande" src="https://picsum.photos/400/250?1" alt="Photo">
<div>
  <button id="prev">◀ Précédent</button>
  <button id="next">Suivant ▶</button>
</div>
<div id="vignettes">
  <img class="mini" src="https://picsum.photos/400/250?1">
  <img class="mini" src="https://picsum.photos/400/250?2">
  <img class="mini" src="https://picsum.photos/400/250?3">
</div>''',
          ),
          ProjectTask(
            title: 'Cliquer une vignette',
            instruction: 'Au clic sur une vignette, mettez sa source dans l\'image #grande.',
            hint: 'Sur la vignette cliquée, lisez son attribut src avec .attr("src").',
            solution: r'''$('.mini').on('click', function () {
  $('#grande').attr('src', $(this).attr('src'));
});''',
          ),
          ProjectTask(
            title: 'Boutons précédent / suivant',
            instruction: 'Faites avancer et reculer dans la liste des vignettes avec #next et #prev, '
                'en bouclant à la fin.',
            hint: 'Gardez un index dans une variable, et utilisez .eq(index) sur la sélection des vignettes.',
            solution: r'''var index = 0;
var total = $('.mini').length;

function afficher(i) {
  index = (i + total) % total; // boucle
  $('#grande').attr('src', $('.mini').eq(index).attr('src'));
}

$('#next').on('click', function () { afficher(index + 1); });
$('#prev').on('click', function () { afficher(index - 1); });''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<img id="grande" src="https://picsum.photos/400/250?1" alt="Photo">
<div>
  <button id="prev">◀ Précédent</button>
  <button id="next">Suivant ▶</button>
</div>
<div id="vignettes">
  <img class="mini" src="https://picsum.photos/400/250?1">
  <img class="mini" src="https://picsum.photos/400/250?2">
  <img class="mini" src="https://picsum.photos/400/250?3">
</div>''',
        finalCode: r'''<img id="grande" src="https://picsum.photos/400/250?1" alt="Photo">
<div>
  <button id="prev">◀ Précédent</button>
  <button id="next">Suivant ▶</button>
</div>
<div id="vignettes">
  <img class="mini" src="https://picsum.photos/400/250?1">
  <img class="mini" src="https://picsum.photos/400/250?2">
  <img class="mini" src="https://picsum.photos/400/250?3">
</div>

<script>
var index = 0;
var total = $('.mini').length;

function afficher(i) {
  index = (i + total) % total;
  $('#grande').attr('src', $('.mini').eq(index).attr('src'));
}

$('.mini').on('click', function () {
  $('#grande').attr('src', $(this).attr('src'));
});
$('#next').on('click', function () { afficher(index + 1); });
$('#prev').on('click', function () { afficher(index - 1); });
</script>''',
      ),
      MiniProject(
        id: 'p3-menu',
        title: 'Menu dynamique',
        category: 'jQuery',
        icon: Icons.menu,
        intro: 'Créez un menu qui se construit depuis un tableau de données et qui ouvre des '
            'sous-panneaux en glissant.',
        objectives: [
          'Construire le DOM à partir de données',
          'Appliquer slideToggle pour un menu accordéon',
          'Utiliser la délégation d\'événements',
        ],
        tasks: [
          ProjectTask(
            title: 'Les données du menu',
            instruction: 'Définissez un tableau menus contenant des objets { titre, contenu }.',
            hint: 'La structure du tableau servira à construire le menu.',
            solution: r'''var menus = [
  { titre: 'Accueil', contenu: 'Bienvenue sur le site.' },
  { titre: 'Services', contenu: 'Création, formation, conseil.' },
  { titre: 'Contact', contenu: 'contact@exemple.com' }
];''',
          ),
          ProjectTask(
            title: 'Construire le menu',
            instruction: 'Générez dans #menu un élément .titre-menu et un .panneau par entrée du tableau.',
            hint: 'Parcourez avec \$.each() ou forEach et utilisez .append().',
            solution: r'''menus.forEach(function (m) {
  $('#menu').append(
    '<div class="titre-menu">' + m.titre + '</div>' +
    '<div class="panneau">' + m.contenu + '</div>'
  );
});''',
          ),
          ProjectTask(
            title: 'Le comportement accordéon',
            instruction: 'Au clic sur un .titre-menu, fermez tous les panneaux puis ouvrez le '
                'panneau suivant, avec slideToggle(300).',
            hint: 'next() atteint le panneau qui suit le titre ; déléguez l\'événement sur #menu.',
            solution: r'''$('#menu').on('click', '.titre-menu', function () {
  $('#menu .panneau').slideUp(300);
  $(this).next('.panneau').slideToggle(300);
});''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<div id="menu"></div>''',
        finalCode: r'''<div id="menu"></div>

<script>
var menus = [
  { titre: 'Accueil', contenu: 'Bienvenue sur le site.' },
  { titre: 'Services', contenu: 'Création, formation, conseil.' },
  { titre: 'Contact', contenu: 'contact@exemple.com' }
];

menus.forEach(function (m) {
  $('#menu').append(
    '<div class="titre-menu">' + m.titre + '</div>' +
    '<div class="panneau">' + m.contenu + '</div>'
  );
});

$('#menu').on('click', '.titre-menu', function () {
  $('#menu .panneau').slideUp(300);
  $(this).next('.panneau').slideToggle(300);
});
</script>''',
      ),
      MiniProject(
        id: 'p4-formulaire',
        title: 'Formulaire interactif',
        category: 'Événements',
        icon: Icons.edit_note,
        intro: 'Un formulaire qui valide ses champs en direct et affiche un résumé, sans recharger '
            'la page.',
        objectives: [
          'Bloquer le rechargement avec preventDefault()',
          'Valider des champs et afficher des erreurs',
          'Afficher un résumé des saisies',
        ],
        tasks: [
          ProjectTask(
            title: 'La structure du formulaire',
            instruction: 'Créez un formulaire #form avec un champ nom (#nom), un champ email (#email) '
                'et un bouton d\'envoi.',
            hint: 'Ajoutez un <p id="erreur"> et une <div id="resume"> vides pour les messages.',
            solution: r'''<form id="form">
  <input type="text" id="nom" placeholder="Nom">
  <input type="email" id="email" placeholder="Email">
  <button type="submit">Envoyer</button>
</form>
<p id="erreur"></p>
<div id="resume"></div>''',
          ),
          ProjectTask(
            title: 'Bloquer et valider',
            instruction: 'À la soumission, empêchez le rechargement puis vérifiez que nom et email '
                'ne sont pas vides ; affichez une erreur sinon.',
            hint: 'e.preventDefault() puis condition sur .val().',
            solution: r'''$('#form').on('submit', function (e) {
  e.preventDefault();
  if ($('#nom').val() === '' || $('#email').val() === '') {
    $('#erreur').text('Veuillez remplir tous les champs.').css('color', 'red');
    return;
  }
  $('#erreur').text('');
  $('#resume').html(
    '<b>' + $('#nom').val() + '</b> — ' + $('#email').val()
  );
});''',
          ),
          ProjectTask(
            title: 'Validation en direct',
            instruction: 'Effacez le message d\'erreur dès que l\'utilisateur retape dans un champ.',
            hint: 'Écoutez keyup sur les champs.',
            solution: r'''$('#form input').on('keyup', function () {
  $('#erreur').text('');
});''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<form id="form">
  <input type="text" id="nom" placeholder="Nom">
  <input type="email" id="email" placeholder="Email">
  <button type="submit">Envoyer</button>
</form>
<p id="erreur"></p>
<div id="resume"></div>''',
        finalCode: r'''<form id="form">
  <input type="text" id="nom" placeholder="Nom">
  <input type="email" id="email" placeholder="Email">
  <button type="submit">Envoyer</button>
</form>
<p id="erreur"></p>
<div id="resume"></div>

<script>
$('#form').on('submit', function (e) {
  e.preventDefault();
  if ($('#nom').val() === '' || $('#email').val() === '') {
    $('#erreur').text('Veuillez remplir tous les champs.').css('color', 'red');
    return;
  }
  $('#erreur').text('');
  $('#resume').html(
    '<b>' + $('#nom').val() + '</b> — ' + $('#email').val()
  );
});

$('#form input').on('keyup', function () {
  $('#erreur').text('');
});
</script>''',
      ),
      MiniProject(
        id: 'p5-todolist',
        title: 'To-do list jQuery',
        category: 'Événements',
        icon: Icons.checklist,
        intro: 'La to-do list : ajouter, cocher et supprimer des tâches, avec délégation '
            'd\'événements pour les éléments créés dynamiquement.',
        objectives: [
          'Ajouter des éléments avec .append()',
          'Déléguer les événements avec .on()',
          'Cocher et supprimer des tâches',
        ],
        tasks: [
          ProjectTask(
            title: 'Structure de base',
            instruction: 'Créez un champ #tache, un bouton #ajouter, et une liste #liste vide.',
            hint: 'Le formulaire doit être dans un <form id="form"> pour utiliser la touche Entrée.',
            solution: r'''<form id="form">
  <input id="tache" placeholder="Nouvelle tâche">
  <button type="submit" id="ajouter">Ajouter</button>
</form>
<ul id="liste"></ul>''',
          ),
          ProjectTask(
            title: 'Ajouter une tâche',
            instruction: 'À la soumission, ajoutez un <li> avec le texte de la tâche et un bouton '
                '.supprimer. Effacez le champ après ajout.',
            hint: 'e.preventDefault() ; créez le <li> avec append() et un bouton en interne.',
            solution: r'''$('#form').on('submit', function (e) {
  e.preventDefault();
  var texte = $('#tache').val().trim();
  if (texte === '') return;
  $('#liste').append(
    '<li><span class="texte">' + texte + '</span> ' +
    '<button class="supprimer">✕</button></li>'
  );
  $('#tache').val('');
});''',
          ),
          ProjectTask(
            title: 'Cocher une tâche',
            instruction: 'Au clic sur le texte d\'un <li>, ajoutez la classe .fait (barré).',
            hint: 'Déléguez : écoutez sur #liste avec le sélecteur cible "li .texte".',
            solution: r'''$('#liste').on('click', '.texte', function () {
  $(this).toggleClass('fait');
});''',
          ),
          ProjectTask(
            title: 'Supprimer une tâche',
            instruction: 'Au clic sur .supprimer, retirez le <li> parent.',
            hint: 'closest("li").remove() depuis le bouton cliqué.',
            solution: r'''$('#liste').on('click', '.supprimer', function () {
  $(this).closest('li').remove();
});''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<form id="form">
  <input id="tache" placeholder="Nouvelle tâche">
  <button type="submit" id="ajouter">Ajouter</button>
</form>
<ul id="liste"></ul>''',
        finalCode: r'''<form id="form">
  <input id="tache" placeholder="Nouvelle tâche">
  <button type="submit" id="ajouter">Ajouter</button>
</form>
<ul id="liste"></ul>

<script>
$('#form').on('submit', function (e) {
  e.preventDefault();
  var texte = $('#tache').val().trim();
  if (texte === '') return;
  $('#liste').append(
    '<li><span class="texte">' + texte + '</span> ' +
    '<button class="supprimer">✕</button></li>'
  );
  $('#tache').val('');
});

$('#liste').on('click', '.texte', function () {
  $(this).toggleClass('fait');
});

$('#liste').on('click', '.supprimer', function () {
  $(this).closest('li').remove();
});
</script>''',
      ),
      MiniProject(
        id: 'p6-recherche',
        title: 'Recherche instantanée',
        category: 'Événements',
        icon: Icons.search,
        intro: 'Filtrez une liste en direct à chaque frappe : votre première recherche '
            'instantanée sans serveur.',
        objectives: [
          'Écouter keyup sur un champ',
          'Filtrer une liste avec un simple test',
          'Afficher / masquer les résultats',
        ],
        tasks: [
          ProjectTask(
            title: 'La liste de données',
            instruction: 'Créez un champ #recherche et une liste #liste de plusieurs <li>.',
            hint: 'Choisissez un thème (fruits, pays, langages…) avec des noms simples.',
            solution: r'''<input id="recherche" placeholder="Rechercher…">
<ul id="liste">
  <li>JavaScript</li>
  <li>jQuery</li>
  <li>HTML</li>
  <li>CSS</li>
  <li>Python</li>
  <li>PHP</li>
</ul>''',
          ),
          ProjectTask(
            title: 'Filtrer à la frappe',
            instruction: 'À chaque keyup, parcourez les <li> et masquez ceux dont le texte ne '
                'contient pas la saisie (insensible à la casse).',
            hint: 'Mettez la saisie en minuscules avec toLowerCase(), et testez indexOf() != -1.',
            solution: r'''$('#recherche').on('keyup', function () {
  var filtre = $(this).val().toLowerCase();
  $('#liste li').each(function () {
    var texte = $(this).text().toLowerCase();
    if (texte.indexOf(filtre) !== -1) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
});''',
          ),
          ProjectTask(
            title: 'Bonus : compter les résultats',
            instruction: 'Affichez dans #compte le nombre d\'éléments visibles.',
            hint: 'La sélection ":visible" permet de compter : \$(\'#liste li:visible\').length.',
            solution: r'''$('#recherche').on('keyup', function () {
  var filtre = $(this).val().toLowerCase();
  $('#liste li').each(function () {
    $(this).toggle($(this).text().toLowerCase().indexOf(filtre) !== -1);
  });
  $('#compte').text($('#liste li:visible').length + ' résultat(s)');
});''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<input id="recherche" placeholder="Rechercher…">
<p id="compte"></p>
<ul id="liste">
  <li>JavaScript</li>
  <li>jQuery</li>
  <li>HTML</li>
  <li>CSS</li>
  <li>Python</li>
  <li>PHP</li>
</ul>''',
        finalCode: r'''<input id="recherche" placeholder="Rechercher…">
<p id="compte"></p>
<ul id="liste">
  <li>JavaScript</li>
  <li>jQuery</li>
  <li>HTML</li>
  <li>CSS</li>
  <li>Python</li>
  <li>PHP</li>
</ul>

<script>
$('#recherche').on('keyup', function () {
  var filtre = $(this).val().toLowerCase();
  $('#liste li').each(function () {
    $(this).toggle($(this).text().toLowerCase().indexOf(filtre) !== -1);
  });
  $('#compte').text($('#liste li:visible').length + ' résultat(s)');
});
</script>''',
      ),
      MiniProject(
        id: 'p7-liste-users',
        title: 'Liste dynamique d\'utilisateurs',
        category: 'AJAX',
        icon: Icons.group,
        intro: 'Chargez de vrais utilisateurs depuis une API publique et affichez-les '
            'dynamiquement, avec gestion d\'erreur.',
        objectives: [
          'Effectuer une requête GET réelle',
          'Afficher une liste depuis JSON',
          'Gérer le chargement et l\'échec',
        ],
        tasks: [
          ProjectTask(
            title: 'La structure',
            instruction: 'Créez un bouton #charger, une zone de statut #etat et une liste #liste.',
            hint: 'Le bouton déclenchera le chargement.',
            solution: r'''<button id="charger">Charger les utilisateurs</button>
<p id="etat"></p>
<ul id="liste"></ul>''',
          ),
          ProjectTask(
            title: 'La requête',
            instruction: 'Au clic, faites un \$.get vers '
                '"https://jsonplaceholder.typicode.com/users" et affichez "Chargement…" pendant.',
            hint: 'Affichez le message avant la requête, dans le callback.',
            solution: r'''$('#charger').on('click', function () {
  $('#etat').text('Chargement…');
  $.get('https://jsonplaceholder.typicode.com/users', function (users) {
    $('#liste').empty();
    users.forEach(function (u) {
      $('#liste').append('<li><b>' + u.name + '</b> — ' + u.email + '</li>');
    });
    $('#etat').text(users.length + ' utilisateurs affichés.');
  });
});''',
          ),
          ProjectTask(
            title: 'Gérer l\'échec',
            instruction: 'Ajoutez .fail() qui affiche un message d\'erreur dans #etat.',
            hint: '\$.get renvoie un objet jqXHR : enchaînez .fail(function(){ … }).',
            solution: r'''$.get('https://jsonplaceholder.typicode.com/users', function (users) {
  $('#liste').empty();
  users.forEach(function (u) {
    $('#liste').append('<li><b>' + u.name + '</b> — ' + u.email + '</li>');
  });
  $('#etat').text(users.length + ' utilisateurs affichés.');
}).fail(function () {
  $('#etat').text('Impossible de charger les données.');
});''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<button id="charger">Charger les utilisateurs</button>
<p id="etat"></p>
<ul id="liste"></ul>''',
        finalCode: r'''<button id="charger">Charger les utilisateurs</button>
<p id="etat"></p>
<ul id="liste"></ul>

<script>
$('#charger').on('click', function () {
  $('#etat').text('Chargement…');
  $.get('https://jsonplaceholder.typicode.com/users', function (users) {
    $('#liste').empty();
    users.forEach(function (u) {
      $('#liste').append('<li><b>' + u.name + '</b> — ' + u.email + '</li>');
    });
    $('#etat').text(users.length + ' utilisateurs affichés.');
  }).fail(function () {
    $('#etat').text('Impossible de charger les données.');
  });
});
</script>''',
      ),
      MiniProject(
        id: 'p8-meteo',
        title: 'Application météo',
        category: 'AJAX',
        icon: Icons.cloud,
        intro: 'Interrogez l\'API météo publique Open-Meteo (sans clé) et affichez la température '
            'd\'une ville.',
        objectives: [
          'Interroger une API publique réelle',
          'Lire un JSON imbriqué',
          'Gérer le chargement et les erreurs',
        ],
        tasks: [
          ProjectTask(
            title: 'La structure',
            instruction: 'Créez un bouton #meteo et une zone #resultat.',
            hint: 'Open-Meteo ne demande aucune clé : idéal pour apprendre.',
            solution: r'''<button id="meteo">Voir la météo</button>
<div id="resultat"></div>''',
          ),
          ProjectTask(
            title: 'La requête météo',
            instruction: 'Au clic, interrogez '
                '"https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.35&current_weather=true" '
                'et affichez le message dans #resultat.',
            hint: 'La réponse contient current_weather.temperature.',
            solution: r'''$('#meteo').on('click', function () {
  var url = 'https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.35&current_weather=true';
  $('#resultat').text('Chargement…');
  $.get(url, function (data) {
    var t = data.current_weather.temperature;
    $('#resultat').text('Température à Paris : ' + t + ' °C');
  }).fail(function () {
    $('#resultat').text('Météo indisponible pour le moment.');
  });
});''',
          ),
          ProjectTask(
            title: 'Bonus : afficher le vent',
            instruction: 'Ajoutez la vitesse du vent à l\'affichage.',
            hint: 'Le champ s\'appelle windspeed dans current_weather.',
            solution: r'''var w = data.current_weather.windspeed;
$('#resultat').text(
  'Paris : ' + t + ' °C, vent ' + w + ' km/h'
);''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<button id="meteo">Voir la météo</button>
<div id="resultat"></div>''',
        finalCode: r'''<button id="meteo">Voir la météo</button>
<div id="resultat"></div>

<script>
$('#meteo').on('click', function () {
  var url = 'https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.35&current_weather=true';
  $('#resultat').text('Chargement…');
  $.get(url, function (data) {
    var t = data.current_weather.temperature;
    var w = data.current_weather.windspeed;
    $('#resultat').text('Paris : ' + t + ' °C, vent ' + w + ' km/h');
  }).fail(function () {
    $('#resultat').text('Météo indisponible pour le moment.');
  });
});
</script>''',
      ),
      MiniProject(
        id: 'p9-api-explorer',
        title: 'Explorateur d\'API',
        category: 'REST',
        icon: Icons.travel_explore,
        intro: 'Un mini Postman : choisissez une ressource, un verbe, et affichez le JSON '
            'reçu avec son statut.',
        objectives: [
          'Combiner sélection et requête',
          'Gérer GET et POST',
          'Afficher du JSON brut',
        ],
        tasks: [
          ProjectTask(
            title: 'Les contrôles',
            instruction: 'Créez un select #ressource avec quelques endpoints, un bouton #envoyer '
                'et un <pre id="sortie">.',
            hint: 'Utilisez les endpoints de jsonplaceholder (users, posts, todos).',
            solution: r'''<select id="ressource">
  <option value="https://jsonplaceholder.typicode.com/users">Utilisateurs</option>
  <option value="https://jsonplaceholder.typicode.com/posts">Articles</option>
  <option value="https://jsonplaceholder.typicode.com/todos">Tâches</option>
</select>
<button id="envoyer">ENVOYER</button>
<pre id="sortie"></pre>''',
          ),
          ProjectTask(
            title: 'Envoyer la requête',
            instruction: 'Au clic, faites un GET sur l\'URL choisie et affichez le JSON formaté '
                'avec JSON.stringify(data, null, 2).',
            hint: 'Le second argument null, le troisième 2 indente le JSON.',
            solution: r'''$('#envoyer').on('click', function () {
  var url = $('#ressource').val();
  $('#sortie').text('Chargement…');
  $.get(url, function (data) {
    $('#sortie').text(JSON.stringify(data, null, 2));
  }).fail(function (xhr) {
    $('#sortie').text('Erreur ' + xhr.status);
  });
});''',
          ),
          ProjectTask(
            title: 'Bonus : choix du verbe',
            instruction: 'Ajoutez un select #verbe (GET / POST) et adaptez la requête : POST '
                'envoie un petit JSON.',
            hint: 'Avec POST, utilisez \$.ajax({ url, method: "POST", data: JSON.stringify({…}) }).',
            solution: r'''$('#envoyer').on('click', function () {
  var url = $('#ressource').val();
  var verbe = $('#verbe').val();
  $('#sortie').text('Chargement…');
  if (verbe === 'POST') {
    $.ajax({
      url: url,
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      data: JSON.stringify({ title: 'Nouveau', body: 'Contenu' }),
      success: function (data) { $('#sortie').text(JSON.stringify(data, null, 2)); },
      error: function (xhr) { $('#sortie').text('Erreur ' + xhr.status); }
    });
  } else {
    $.get(url, function (data) {
      $('#sortie').text(JSON.stringify(data, null, 2));
    }).fail(function (xhr) { $('#sortie').text('Erreur ' + xhr.status); });
  }
});''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<select id="ressource">
  <option value="https://jsonplaceholder.typicode.com/users">Utilisateurs</option>
  <option value="https://jsonplaceholder.typicode.com/posts">Articles</option>
  <option value="https://jsonplaceholder.typicode.com/todos">Tâches</option>
</select>
<button id="envoyer">ENVOYER</button>
<pre id="sortie"></pre>''',
        finalCode: r'''<select id="ressource">
  <option value="https://jsonplaceholder.typicode.com/users">Utilisateurs</option>
  <option value="https://jsonplaceholder.typicode.com/posts">Articles</option>
  <option value="https://jsonplaceholder.typicode.com/todos">Tâches</option>
</select>
<button id="envoyer">ENVOYER</button>
<pre id="sortie"></pre>

<script>
$('#envoyer').on('click', function () {
  var url = $('#ressource').val();
  $('#sortie').text('Chargement…');
  $.get(url, function (data) {
    $('#sortie').text(JSON.stringify(data, null, 2));
  }).fail(function (xhr) {
    $('#sortie').text('Erreur ' + xhr.status);
  });
});
</script>''',
      ),
      MiniProject(
        id: 'p10-dashboard-ajax',
        title: 'Dashboard AJAX',
        category: 'AJAX',
        icon: Icons.dashboard,
        intro: 'Un tableau de bord qui charge et combine deux ressources : des utilisateurs et '
            'des tâches.',
        objectives: [
          'Effectuer plusieurs requêtes',
          'Combiner des données',
          'Afficher des statistiques simples',
        ],
        tasks: [
          ProjectTask(
            title: 'Deux zones',
            instruction: 'Créez un bouton #charger, une zone #stats et une liste #activite.',
            hint: 'Les stats viendront d\'une combinaison des deux requêtes.',
            solution: r'''<button id="charger">Charger le tableau de bord</button>
<div id="stats"></div>
<ul id="activite"></ul>''',
          ),
          ProjectTask(
            title: 'Charger users et todos',
            instruction: 'Faites deux \$.get (users et todos) ; dans le callback des todos, utilisez '
                'les deux jeux de données pour afficher les stats.',
            hint: 'Stockez users dans une variable avant le second appel.',
            solution: r'''$('#charger').on('click', function () {
  $.get('https://jsonplaceholder.typicode.com/users', function (users) {
    $.get('https://jsonplaceholder.typicode.com/todos', function (todos) {
      var faites = todos.filter(function (t) { return t.completed; });
      $('#stats').html(
        '<b>' + users.length + '</b> utilisateurs · <b>' +
        todos.length + '</b> tâches · <b>' + faites.length + '</b> terminées'
      );
    });
  });
});''',
          ),
          ProjectTask(
            title: 'Lister les tâches en cours',
            instruction: 'Affichez dans #activite les 5 premières tâches non terminées.',
            hint: 'filter puis slice(0, 5), puis append d\'un <li> par tâche.',
            solution: r'''var enCours = todos.filter(function (t) { return !t.completed; }).slice(0, 5);
enCours.forEach(function (t) {
  $('#activite').append('<li>' + t.title + '</li>');
});''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<button id="charger">Charger le tableau de bord</button>
<div id="stats"></div>
<ul id="activite"></ul>''',
        finalCode: r'''<button id="charger">Charger le tableau de bord</button>
<div id="stats"></div>
<ul id="activite"></ul>

<script>
$('#charger').on('click', function () {
  $.get('https://jsonplaceholder.typicode.com/users', function (users) {
    $.get('https://jsonplaceholder.typicode.com/todos', function (todos) {
      var faites = todos.filter(function (t) { return t.completed; });
      var enCours = todos.filter(function (t) { return !t.completed; }).slice(0, 5);
      $('#stats').html(
        '<b>' + users.length + '</b> utilisateurs · <b>' +
        todos.length + '</b> tâches · <b>' + faites.length + '</b> terminées'
      );
      $('#activite').empty();
      enCours.forEach(function (t) {
        $('#activite').append('<li>' + t.title + '</li>');
      });
    });
  });
});
</script>''',
      ),
      MiniProject(
        id: 'projet-final-ajax-dashboard',
        title: 'Projet final : AJAX Dashboard',
        category: 'AJAX',
        icon: Icons.workspace_premium,
        isFinalProject: true,
        intro: 'Le grand final : assemblez tout ce que vous avez appris pour construire un tableau '
            'de bord AJAX complet — HTML, jQuery, DOM, événements, AJAX, JSON, API REST, '
            'gestion d\'erreurs, loaders et affichage dynamique.',
        objectives: [
          'Mobiliser TOUTES les compétences du parcours',
          'Construire une interface réactive et complète',
          'Gérer parfaitement chargement, succès et échec',
        ],
        tasks: [
          ProjectTask(
            title: 'La structure du tableau de bord',
            instruction: 'Créez le squelette : un titre, un bouton #actualiser, une zone de statut '
                '#etat (le loader), une zone #stats et une liste #liste.',
            hint: 'Le bouton actualisera tout le tableau de bord. Le statut affichera le chargement.',
            solution: r'''<h1>Tableau de bord AJAX</h1>
<button id="actualiser">Actualiser</button>
<p id="etat"></p>
<div id="stats"></div>
<ul id="liste"></ul>''',
          ),
          ProjectTask(
            title: 'Charger les utilisateurs',
            instruction: 'Écrivez une fonction chargerDashboard() qui affiche le loader, fait un '
                'GET vers les users et remplit #liste.',
            hint: 'Affichez "Chargement…" dans #etat avant la requête.',
            solution: r'''function chargerDashboard() {
  $('#etat').text('Chargement…');
  $('#liste').empty();
  $.get('https://jsonplaceholder.typicode.com/users', function (users) {
    users.forEach(function (u) {
      $('#liste').append(
        '<li data-id="' + u.id + '"><b>' + u.name + '</b> — ' + u.email +
        ' <button class="detail">Détail</button></li>'
      );
    });
    $('#etat').text(users.length + ' utilisateurs chargés.');
  }).fail(function () {
    $('#etat').text('Impossible de charger les données.');
  });
}
chargerDashboard();''',
          ),
          ProjectTask(
            title: 'Combiner une seconde ressource',
            instruction: 'Dans le même chargement, récupérez aussi les todos et affichez dans '
                '#stats le nombre de tâches terminées sur le total.',
            hint: 'N\'appelez le second GET qu\'après le succès du premier, puis calculez.',
            solution: r'''$.get('https://jsonplaceholder.typicode.com/users', function (users) {
  $.get('https://jsonplaceholder.typicode.com/todos', function (todos) {
    var faites = todos.filter(function (t) { return t.completed; }).length;
    $('#stats').html(
      '<b>' + users.length + '</b> utilisateurs · ' +
      '<b>' + faites + '</b> / <b>' + todos.length + '</b> tâches terminées'
    );
    users.forEach(function (u) { … });
    $('#etat').text('Tableau de bord à jour.');
  }).fail(function () { $('#etat').text('Erreur sur les tâches.'); });
}).fail(function () { $('#etat').text('Erreur sur les utilisateurs.'); });''',
          ),
          ProjectTask(
            title: 'Le bouton détail (délégation)',
            instruction: 'Au clic sur .detail, affichez une alerte avec le nom de l\'utilisateur '
                'du <li> concerné, par délégation sur #liste.',
            hint: 'closest("li") puis .find(".name") ou .data("nom").',
            solution: r'''$('#liste').on('click', '.detail', function () {
  var nom = $(this).closest('li').find('b').text();
  alert('Détail : ' + nom);
});''',
          ),
          ProjectTask(
            title: 'Relier le bouton actualiser',
            instruction: 'Branchez #actualiser sur chargerDashboard().',
            hint: 'Un simple .on("click", chargerDashboard).',
            solution: r'''$('#actualiser').on('click', chargerDashboard);''',
          ),
          ProjectTask(
            title: 'Le loader dans tous les cas',
            instruction: 'Assurez-vous que le loader est masqué en cas de succès ET d\'échec.',
            hint: 'Chaque .fail doit aussi remettre #etat dans un état final.',
            solution: r'''// Le loader n'est qu'un texte de statut : chaque branche (succès/échec)
// le remplace par un message final. Aucune branche ne l'oublie.
// Vérifiez : succès → « Tableau de bord à jour. »
//          échec    → « Erreur sur … »''',
          ),
        ],
        starterCode: r'''<!-- HTML -->
<h1>Tableau de bord AJAX</h1>
<button id="actualiser">Actualiser</button>
<p id="etat"></p>
<div id="stats"></div>
<ul id="liste"></ul>''',
        finalCode: r'''<h1>Tableau de bord AJAX</h1>
<button id="actualiser">Actualiser</button>
<p id="etat"></p>
<div id="stats"></div>
<ul id="liste"></ul>

<script>
function chargerDashboard() {
  $('#etat').text('Chargement…');
  $('#liste').empty();
  $.get('https://jsonplaceholder.typicode.com/users', function (users) {
    $.get('https://jsonplaceholder.typicode.com/todos', function (todos) {
      var faites = todos.filter(function (t) { return t.completed; }).length;
      $('#stats').html(
        '<b>' + users.length + '</b> utilisateurs · ' +
        '<b>' + faites + '</b> / <b>' + todos.length + '</b> tâches terminées'
      );
      users.forEach(function (u) {
        $('#liste').append(
          '<li data-id="' + u.id + '"><b>' + u.name + '</b> — ' + u.email +
          ' <button class="detail">Détail</button></li>'
        );
      });
      $('#etat').text('Tableau de bord à jour.');
    }).fail(function () {
      $('#etat').text('Erreur sur les tâches.');
    });
  }).fail(function () {
    $('#etat').text('Erreur sur les utilisateurs.');
  });
}

$('#actualiser').on('click', chargerDashboard);

$('#liste').on('click', '.detail', function () {
  var nom = $(this).closest('li').find('b').text();
  alert('Détail : ' + nom);
});

chargerDashboard();
</script>''',
      ),
    ];
