import '../data/app_data.dart';
import '../models/snippet.dart';
import 'js_text.dart';

typedef _Rule = (RegExp, String Function(RegExpMatch));

/// Génère des explications ligne par ligne pour un extrait de code.
///
/// Utilise les explications rédigées lorsqu'elles existent, sinon une
/// explication déduite du langage et du contenu de chaque ligne.
class ExplainService {
  /// Renvoie l'explication ligne par ligne du code donné.
  static List<CodeLineExplanation> explain(String code, {String language = 'javascript'}) {
    final key = JsText.canonical(code);
    for (final known in AppData.explainableCodes) {
      if (JsText.canonical(known.code) == key) return known.lines;
    }

    final result = <CodeLineExplanation>[];
    var inScript = false; // bloc <script> dans du HTML
    for (final raw in code.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('</script')) inScript = false;
      result.add(CodeLineExplanation(
        line: line,
        explanation: _explainLine(line, inScript ? 'javascript' : language),
      ));
      if (line.startsWith('<script') && !line.contains('</script')) inScript = true;
    }
    return result;
  }

  static String _explainLine(String line, String language) {
    if (RegExp(r'^(//|/\*|<!--)').hasMatch(line)) {
      return 'commentaire : ignoré à l\'exécution, il guide le lecteur.';
    }
    return switch (language) {
      'html' => _html(line),
      'css' => _css(line),
      'json' => _json(line),
      'http' => _http(line),
      'text' => 'ligne d\'illustration : lisez-la avec le texte de la leçon.',
      // Certains extraits JavaScript contiennent aussi du HTML.
      _ => line.startsWith('<') ? _html(line) : _js(line),
    };
  }

  // ----- HTML -----

  static const Map<String, String> _tags = {
    'html': 'la racine du document',
    'head': 'l\'en-tête, invisible dans la page',
    'body': 'le contenu visible de la page',
    'meta': 'une information sur la page',
    'title': 'le titre affiché dans l\'onglet',
    'h1': 'un titre principal',
    'p': 'un paragraphe',
    'div': 'un conteneur',
    'ul': 'une liste à puces',
    'li': 'un élément de liste',
    'button': 'un bouton',
    'input': 'un champ de saisie',
    'form': 'un formulaire',
    'img': 'une image',
    'script': 'un bloc de code JavaScript',
  };

  static String _html(String line) {
    if (line.toLowerCase().startsWith('<!doctype')) {
      return 'annonce un document HTML5 au navigateur.';
    }
    final closing = RegExp(r'^</(\w+)>').firstMatch(line);
    if (closing != null) return 'ferme la balise <${closing[1]}>.';
    final opening = RegExp(r'^<(\w+)').firstMatch(line);
    if (opening == null) return 'texte affiché dans la page.';

    final parts = ['${_tags[opening[1]] ?? 'une balise <${opening[1]}>'} (<${opening[1]}>)'];
    for (final m in RegExp(r'\s(id|class|data-\w+)="([^"]*)"').allMatches(line)) {
      parts.add(switch (m[1]!) {
        'id' => 'd\'identifiant unique « ${m[2]} »',
        'class' => 'de classe « ${m[2]} »',
        final data => 'avec la donnée $data = ${m[2]}',
      });
    }
    return '${parts.join(', ')}.';
  }

  // ----- CSS, JSON, HTTP -----

  static String _css(String line) {
    final rule = RegExp(r'^([^{]+)\{').firstMatch(line);
    if (rule != null) return 'applique ce style aux éléments « ${rule[1]!.trim()} ».';
    if (line.startsWith('}')) return 'ferme la règle CSS.';
    return 'déclaration de style : une propriété et sa valeur.';
  }

  static String _json(String line) {
    final pair = RegExp(r'^"([^"]+)"\s*:\s*(.)').firstMatch(line);
    if (pair != null) {
      final kind = switch (pair[2]!) {
        '"' => 'un texte',
        '{' => 'un objet imbriqué',
        '[' => 'un tableau',
        't' || 'f' => 'un booléen',
        'n' => 'null (absence de valeur)',
        _ => 'un nombre',
      };
      return 'clé « ${pair[1]} », dont la valeur est $kind.';
    }
    if (RegExp(r'^\{.+\},?$').hasMatch(line)) return 'un objet complet, élément du tableau.';
    if (line.startsWith('{')) return 'ouvre un objet : des paires clé / valeur.';
    if (line.startsWith('[')) return 'ouvre un tableau : une liste de valeurs.';
    return 'ferme l\'objet ou le tableau ouvert plus haut.';
  }

  static String _http(String line) {
    final request = RegExp(r'^(GET|POST|PUT|PATCH|DELETE) (\S+)').firstMatch(line);
    if (request != null) return 'ligne de requête : méthode ${request[1]} sur ${request[2]}.';
    final status = RegExp(r'^HTTP/\S+ (\d+)').firstMatch(line);
    if (status != null) return 'ligne de statut : le serveur répond avec le code ${status[1]}.';
    final header = RegExp(r'^([\w-]+):').firstMatch(line);
    if (header != null) return 'en-tête « ${header[1]} ».';
    return 'corps du message.';
  }

  // ----- JavaScript / jQuery -----

  static _Rule _r(String pattern, String text) => (RegExp(pattern), (_) => text);
  static _Rule _m(String pattern, String Function(RegExpMatch) text) => (RegExp(pattern), text);

  /// Règles portant sur la syntaxe seule (chaînes vidées).
  static final List<_Rule> _syntaxRules = [
    _r(r'\bthrow\b', 'lève une erreur'),
    _r(r'\btry\b', 'ouvre un bloc protégé : une erreur y sera interceptée'),
    _r(r'(?<!\.)\bcatch\b', 'intercepte l\'erreur du bloc try'),
    _r(r'\belse\b', 'sinon, exécute l\'autre branche'),
    _r(r'\bif\s*\(', 'n\'exécute la suite que si la condition est vraie'),
    _r(r'\breturn\b', 'renvoie un résultat'),
    _r(r'\basync\b', 'rend la fonction asynchrone : elle peut utiliser await'),
    _m(r'\bfunction\s+(\w+)', (m) => 'déclare la fonction ${m[1]}'),
    _m(r'^const\s+(\w+)\s*=', (m) => 'déclare la constante ${m[1]}'),
    _m(r'^(?:let|var)\s+(\w+)', (m) => 'déclare la variable ${m[1]}'),
    _r(r'\bnew Promise\b', 'crée une Promise'),
    _r(r'\bsetTimeout\(', 'programme une exécution différée'),
    _r(r'\bawait\b', 'attend le résultat sans bloquer la page'),
    _r(r'\bfetch\(', 'envoie une requête HTTP avec fetch'),
    _r(r'\.json\(\)', 'convertit le corps de la réponse JSON en objet'),
    _r(r'JSON\.stringify\(', 'convertit un objet en texte JSON'),
    _r(r'JSON\.parse\(', 'convertit un texte JSON en objet'),
    _r(r'\$\.ajax\(', 'lance une requête HTTP décrite par un objet d\'options'),
    _r(r'\$\.get\(', 'lance une requête GET'),
    _r(r'\$\.post\(', 'lance une requête POST'),
    _r(r'^url\s*:', 'option : l\'adresse à interroger'),
    _r(r'^(?:method|type)\s*:', 'option : le verbe HTTP'),
    _r(r'^(?:data|body)\s*:', 'option : les données envoyées'),
    _r(r'^dataType\s*:', 'option : le format attendu en réponse'),
    _r(r'^contentType\s*:', 'option : le format des données envoyées'),
    _r(r'^headers\s*:', 'option : les en-têtes de la requête'),
    _r(r'^timeout\s*:', 'option : le délai maximum, en millisecondes'),
    _r(r'^success\s*:', 'callback exécuté si la requête réussit'),
    _r(r'^error\s*:', 'callback exécuté si la requête échoue'),
    _r(r'\.then\(', 'enchaîne quand la Promise est tenue'),
    _r(r'\.done\(', 'callback en cas de réussite'),
    _r(r'\.(?:fail|catch)\(', 'callback en cas d\'échec'),
    _r(r'\.always\(', 'callback exécuté dans tous les cas'),
    _r(r'^\$\(\s*function|\.ready\(', 'attend que le DOM soit prêt'),
    _r(r'\$\(this\)', 'cible l\'élément qui a déclenché l\'événement'),
    _r(r'\.preventDefault\(', 'annule le comportement par défaut du navigateur'),
    _r(r'\.closest\(', 'remonte au plus proche ancêtre correspondant'),
    _r(r'\.parents?\(', 'remonte vers le ou les parents'),
    _r(r'\.children\(', 'descend vers les enfants directs'),
    _r(r'\.find\(', 'cherche parmi les descendants'),
    _r(r'\.siblings\(', 'cible les éléments voisins'),
    _r(r'\.next\(', 'passe à l\'élément suivant'),
    _r(r'\.first\(', 'garde le premier élément'),
    _r(r'\.last\(', 'garde le dernier élément'),
    _r(r'\.eq\(', 'garde l\'élément à cet index'),
    _r(r'\.filter\(', 'ne garde que les éléments correspondants'),
    _r(r'\.text\(\)|\.html\(\)', 'lit le contenu de l\'élément'),
    _r(r'\.text\([^)]', 'remplace le texte de l\'élément'),
    _r(r'\.html\([^)]', 'remplace le HTML de l\'élément'),
    _r(r'\.val\(\)', 'lit la valeur du champ'),
    _r(r'\.val\([^)]', 'définit la valeur du champ'),
    _r(r'\.attr\(', 'lit ou modifie un attribut'),
    _r(r'\.css\(', 'modifie le style'),
    _r(r'\.data\(', 'lit une donnée data-*'),
    _r(r'\.addClass\(', 'ajoute une classe CSS'),
    _r(r'\.removeClass\(', 'retire une classe CSS'),
    _r(r'\.toggleClass\(', 'bascule une classe CSS'),
    _r(r'\.hasClass\(', 'teste la présence d\'une classe'),
    _r(r'\.append\(', 'ajoute du contenu à la fin de l\'élément'),
    _r(r'\.prepend\(', 'ajoute du contenu au début de l\'élément'),
    _r(r'\.before\(', 'insère du contenu avant l\'élément'),
    _r(r'\.after\(', 'insère du contenu après l\'élément'),
    _r(r'\.remove\(', 'supprime l\'élément du DOM'),
    _r(r'\.empty\(', 'vide l\'élément'),
    _r(r'\.hide\(', 'masque l\'élément'),
    _r(r'\.show\(', 'affiche l\'élément'),
    _r(r'\.toggle\(', 'bascule entre affiché et masqué'),
    _r(r'\.fade(?:In|Out|Toggle|To)\(', 'joue sur l\'opacité (fondu)'),
    _r(r'\.slide(?:Up|Down|Toggle)\(', 'joue sur la hauteur (glissement)'),
    _r(r'\.animate\(', 'anime des propriétés CSS numériques'),
    _r(r'\.forEach\(', 'parcourt chaque élément du tableau'),
    _r(r'\.push\(', 'ajoute un élément à la fin du tableau'),
    _r(r'\.length\b', 'utilise le nombre d\'éléments'),
    _r(r'\bNumber\(|\bparseInt\(', 'convertit un texte en nombre'),
    _r(r'\btypeof\b', 'donne le type de la valeur'),
    _r(r'\.addEventListener\(', 'écoute un événement'),
    _r(r'\.createElement\(', 'crée un élément HTML'),
    _r(r'\.appendChild\(', 'insère l\'élément dans la page'),
    _r(r'\.textContent\b', 'modifie le texte de l\'élément'),
    _r(r'console\.error\(', 'affiche une erreur dans la console'),
    _r(r'console\.log\(', 'affiche une valeur dans la console'),
    _r(r'\balert\(', 'ouvre une fenêtre d\'alerte'),
  ];

  /// Règles qui ont besoin du contenu des chaînes.
  static final List<_Rule> _textRules = [
    _m(r'''\$\(\s*(['"])(.+?)\1''', (m) => _selector(m[2]!)),
    _m(r'''getElementById\(['"]([\w-]+)''', (m) => 'retrouve l\'élément d\'id « ${m[1]} »'),
    _m(r'''\.on\(\s*['"]([\w ]+)['"]\s*,\s*['"]([^'"]+)['"]''',
        (m) => 'écoute « ${m[1]} » par délégation sur « ${m[2]} »'),
    _m(r'''\.on\(\s*['"]([\w ]+)['"]\s*,\s*(?!['"])''', (m) => 'écoute l\'événement « ${m[1]} »'),
    _r(r'\.on\(\s*\{', 'écoute plusieurs événements'),
    _m(r'\.(click|change|submit|keyup|hover)\(', (m) => 'écoute l\'événement « ${m[1]} »'),
  ];

  static String _selector(String selector) {
    final tag = RegExp(r'^<(\w+)').firstMatch(selector);
    if (tag != null) return 'crée un élément <${tag[1]}>';
    if (RegExp(r'^#[\w-]+$').hasMatch(selector)) {
      return 'sélectionne l\'élément d\'id « ${selector.substring(1)} »';
    }
    if (RegExp(r'^\.[\w-]+$').hasMatch(selector)) {
      return 'sélectionne les éléments de classe « ${selector.substring(1)} »';
    }
    return 'sélectionne les éléments « $selector »';
  }

  static String _js(String line) {
    final text = JsText.stripComments(line).trim();
    final syntax = JsText.blankStrings(line).trim();
    if (RegExp(r'^[\])}(;,\s\d]+$').hasMatch(syntax)) {
      return 'ferme le bloc ou l\'appel ouvert plus haut.';
    }

    final parts = <String>[
      for (final (pattern, explain) in _textRules)
        if (pattern.firstMatch(text) case final m?) explain(m),
      for (final (pattern, explain) in _syntaxRules)
        if (pattern.firstMatch(syntax) case final m?) explain(m),
    ];
    if (parts.isNotEmpty) return '${parts.take(3).join(' ; ')}.';

    if (RegExp(r'\bfunction\b|=>').hasMatch(syntax)) {
      return 'contient une fonction, exécutée plus tard (callback).';
    }
    final pair = RegExp(r'''^['"]?([\w-]+)['"]?\s*:''').firstMatch(text);
    if (pair != null) return 'propriété « ${pair[1]} » de l\'objet.';
    final call = RegExp(r'^([\w.]+)\(').firstMatch(syntax);
    if (call != null) return 'appelle la fonction ${call[1]}.';
    if (RegExp(r'^[\w.]+\s*=[^=]').hasMatch(syntax)) return 'affecte une nouvelle valeur.';
    if (RegExp(r'^[\w.\[\]]+$').hasMatch(syntax)) return 'lit cette valeur.';
    if (syntax.startsWith('{')) return 'un objet : des paires clé / valeur.';
    return 'suite de l\'instruction précédente.';
  }
}
