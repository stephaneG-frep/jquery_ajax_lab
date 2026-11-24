/// Exemples préchargés du laboratoire.
class LabPreset {
  final String id;
  final String label;
  final String html;
  final String css;
  final String js;

  const LabPreset({
    required this.id,
    required this.label,
    required this.html,
    required this.css,
    required this.js,
  });
}

const List<LabPreset> labPresets = [
  LabPreset(
    id: 'preset-click',
    label: 'Exemple : clic simple',
    html: '''<button id="btn">Clique-moi</button>
<p id="message"></p>''',
    css: '''button {
  background: #3D5AFE;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 10px 18px;
  font-size: 15px;
  cursor: pointer;
}
#message { font-weight: bold; }''',
    js: '''\$("#btn").on("click", function () {
  \$("#message").text("Bravo !");
});''',
  ),
  LabPreset(
    id: 'preset-dom',
    label: 'Manipulation .text() et .html()',
    html: '''<button id="btn">Agir</button>
<p id="sortie">Texte initial</p>''',
    css: 'body { font-family: sans-serif; }',
    js: '''\$("#btn").on("click", function () {
  \$("#sortie").text("Remplacé par .text()");
  \$("#sortie").append(" <b>puis</b> un peu de HTML");
});''',
  ),
  LabPreset(
    id: 'preset-toggle',
    label: 'Afficher / masquer',
    html: '''<button id="btn">Afficher / masquer</button>
<div id="zone">
  <p>Je peux disparaître en fondu !</p>
</div>''',
    css: '''#zone {
  background: #eef2ff;
  padding: 16px;
  border-radius: 10px;
}''',
    js: '''\$("#btn").on("click", function () {
  \$("#zone").fadeToggle(300);
});''',
  ),
  LabPreset(
    id: 'preset-anim',
    label: 'Animation animate()',
    html: '''<button id="btn">Animer</button>
<div id="boite" style="width:80px;height:40px;background:#3D5AFE;border-radius:8px;position:relative;"></div>''',
    css: 'body { padding: 16px; }',
    js: '''\$("#btn").on("click", function () {
  \$("#boite").animate({ left: "+=150px", opacity: 0.4 }, 800)
    .animate({ left: "-=150px", opacity: 1 }, 800);
});''',
  ),
  LabPreset(
    id: 'preset-todolist',
    label: 'To-do list jQuery',
    html: '''<form id="form">
  <input id="tache" placeholder="Nouvelle tâche">
  <button type="submit">Ajouter</button>
</form>
<ul id="liste"></ul>''',
    css: '''body { font-family: sans-serif; }
.fait { text-decoration: line-through; color: #888; }''',
    js: '''\$("#form").on("submit", function (e) {
  e.preventDefault();
  var texte = \$("#tache").val().trim();
  if (texte === "") return;
  // .text() : la saisie n'est jamais interprétée comme du HTML
  var \$li = \$("<li>");
  \$li.append(\$('<span class="texte">').text(texte));
  \$li.append(' <button class="supprimer">✕</button>');
  \$("#liste").append(\$li);
  \$("#tache").val("");
});

\$("#liste").on("click", ".texte", function () {
  \$(this).toggleClass("fait");
});

\$("#liste").on("click", ".supprimer", function () {
  \$(this).closest("li").remove();
});''',
  ),
  LabPreset(
    id: 'preset-ajax',
    label: 'AJAX : liste d\'utilisateurs',
    html: '''<button id="charger">Charger les utilisateurs</button>
<p id="etat"></p>
<ul id="liste"></ul>''',
    css: 'body { font-family: sans-serif; }',
    js: '''\$("#charger").on("click", function () {
  \$("#etat").text("Chargement…");
  \$.ajax({
    url: "https://jsonplaceholder.typicode.com/users",
    method: "GET",
    dataType: "json",
    success: function (users) {
      \$("#liste").empty();
      users.forEach(function (user) {
        \$("#liste").append("<li><b>" + user.name + "</b> — " + user.email + "</li>");
      });
      \$("#etat").text(users.length + " utilisateurs chargés.");
    },
    error: function () {
      \$("#etat").text("Impossible de charger les données.");
    }
  });
});''',
  ),
  LabPreset(
    id: 'preset-fetch',
    label: 'JavaScript moderne : fetch',
    html: '''<button id="charger">Charger avec fetch</button>
<pre id="sortie"></pre>''',
    css: 'body { font-family: sans-serif; }',
    js: '''\$("#charger").on("click", async function () {
  \$("#sortie").text("Chargement…");
  try {
    const response = await fetch("https://jsonplaceholder.typicode.com/users/1");
    if (!response.ok) throw new Error("HTTP " + response.status);
    const user = await response.json();
    \$("#sortie").text(JSON.stringify(user, null, 2));
  } catch (e) {
    \$("#sortie").text("Erreur : " + e.message);
  }
});''',
  ),
  LabPreset(
    id: 'preset-fetch-native',
    label: 'fetch pur (sans jQuery)',
    html: '''<button id="charger">Charger avec fetch</button>
<pre id="sortie"></pre>''',
    css: 'body { font-family: sans-serif; }',
    js: '''document.getElementById("charger").addEventListener("click", async () => {
  try {
    const response = await fetch("https://jsonplaceholder.typicode.com/users/1");
    if (!response.ok) throw new Error("HTTP " + response.status);
    const user = await response.json();
    document.getElementById("sortie").textContent = JSON.stringify(user, null, 2);
  } catch (e) {
    document.getElementById("sortie").textContent = "Erreur : " + e.message;
  }
});''',
  ),
];
