import 'package:flutter/services.dart';

/// Construit une page HTML complète à partir des entrées du laboratoire.
///
/// Le JavaScript (jQuery) fourni par l'utilisateur est exécuté dans un
/// environnement isolé de la WebView. La bibliothèque jQuery est embarquée
/// dans les assets de l'application : le laboratoire fonctionne donc hors
/// connexion.
class LabEngine {
  /// Lit la bibliothèque jQuery embarquée.
  static Future<String> jquerySource() async {
    final data = await rootBundle.load('assets/vendor/jquery/jquery-3.7.1.min.js');
    return String.fromCharCodes(data.buffer.asUint8List());
  }

  /// Construit le document HTML final.
  ///
  /// La console et jQuery sont chargés dans le `<head>`, avant le HTML de
  /// l'apprenant : celui-ci peut contenir des scripts qui utilisent $.
  static String buildHtml({
    required String html,
    required String css,
    required String js,
    required String jquery,
  }) {
    final escapedJs = js.replaceAll(r'\$', r'\$').replaceAll('</script>', r'<\/script>');
    return '''
<!DOCTYPE html>
<html lang="fr">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
<script>
/* Pont vers la console Flutter */
(function () {
  function postLog(text) {
    try { AndroidBridge.postMessage(text); } catch (e) {}
  }
  // Représentation lisible d'une valeur quelconque.
  function format(value) {
    if (typeof value === 'string') return value;
    if (value === null || typeof value !== 'object') return String(value);
    if (value instanceof Error) return String(value);
    if (value instanceof Node) return value.outerHTML || value.nodeName;
    if (value.jquery) return 'jQuery(' + value.length + ' élément(s))';
    try {
      var short = stringify(value);
      return short.length <= 60 ? short : stringify(value, 2);
    } catch (e) {
      return String(value);
    }
  }
  function stringify(value, indent) {
    var parents = [];
    return JSON.stringify(value, function (key, v) {
      if (typeof v === 'function') return '[fonction]';
      if (v === undefined) return '[undefined]';
      if (v === null || typeof v !== 'object') return v;
      while (parents.length && parents[parents.length - 1] !== this) parents.pop();
      if (parents.indexOf(v) !== -1) return '[circulaire]';
      parents.push(v);
      return v;
    }, indent);
  }
  function replace(name, prefix) {
    var native = console[name];
    console[name] = function () {
      postLog(prefix + Array.prototype.map.call(arguments, format).join(' '));
      if (native) native.apply(console, arguments);
    };
  }
  ['log', 'info', 'debug', 'table', 'dir', 'group'].forEach(function (name) { replace(name, ''); });
  replace('warn', 'Avertissement: ');
  replace('error', 'Erreur: ');
  window.onerror = function (msg, src, line, col) {
    postLog('Erreur JS ligne ' + line + ' : ' + msg);
  };
  window.addEventListener('unhandledrejection', function (e) {
    postLog('Erreur (Promise) : ' + format(e.reason));
  });
})();
</script>

<script>
/* jQuery embarqué (hors connexion) */
$jquery
</script>

<style>
  * { box-sizing: border-box; }
  html, body { margin: 0; padding: 0; }
  body { font-family: -apple-system, "Segoe UI", Roboto, sans-serif;
         font-size: 15px; line-height: 1.5; color: #24292e; }
  /* ---------- CSS de l'apprenant ---------- */
$css
</style>
</head>
<body>
<!-- ---------- HTML de l'apprenant ---------- -->
$html

<script>
/* ---------- JavaScript / jQuery de l'apprenant ---------- */
$escapedJs
</script>
</body>
</html>
''';
  }
}
