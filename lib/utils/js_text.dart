/// Outils d'analyse légère de code JavaScript : commentaires, chaînes, blocs.
class JsText {
  JsText._();

  /// Chaînes ('…', "…", `…`) ou commentaires. Traiter les deux ensemble évite
  /// de prendre le // de 'https://…' pour un commentaire.
  static final RegExp _stringsAndComments = RegExp(
    r"""'(?:[^'\\\n]|\\.)*'|"(?:[^"\\\n]|\\.)*"|`(?:[^`\\]|\\.)*`|//[^\n]*|/\*[\s\S]*?\*/""",
  );

  static bool _isComment(String token) =>
      token.startsWith('//') || token.startsWith('/*');

  /// Retire les commentaires, en conservant les chaînes.
  static String stripComments(String code) => code.replaceAllMapped(
        _stringsAndComments,
        (m) => _isComment(m[0]!) ? ' ' : m[0]!,
      );

  /// Retire les commentaires et vide les chaînes : il ne reste que la syntaxe.
  static String blankStrings(String code) => code.replaceAllMapped(
        _stringsAndComments,
        (m) => _isComment(m[0]!) ? ' ' : "''",
      );

  /// Forme canonique : sans commentaires, guillemets unifiés en ', espaces
  /// réduits. Deux écritures équivalentes donnent le même texte.
  static String canonical(String code) {
    final out = StringBuffer();
    final source = stripComments(code).replaceAll(RegExp(r'[\u00A0\u202F]'), ' ');
    var last = 0;
    for (final m in _stringsAndComments.allMatches(source)) {
      out.write(_compact(source.substring(last, m.start)));
      final token = m[0]!;
      out.write("'${token.substring(1, token.length - 1)}'");
      last = m.end;
    }
    out.write(_compact(source.substring(last)));
    return out.toString().trim();
  }

  static String _compact(String s) => s
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAllMapped(RegExp(r' ?([^\w$ ]) ?'), (m) => m[1]!);

  /// Vrai si parenthèses, crochets, accolades et guillemets sont bien fermés.
  static bool isBalanced(String code) {
    final syntax = blankStrings(code).replaceAll("''", '');
    if (syntax.contains(RegExp('[\'"`]'))) return false;
    const pairs = {')': '(', ']': '[', '}': '{'};
    final stack = <String>[];
    for (final c in syntax.split('')) {
      if (pairs.containsValue(c)) {
        stack.add(c);
      } else if (pairs.containsKey(c)) {
        if (stack.isEmpty || stack.removeLast() != pairs[c]) return false;
      }
    }
    return stack.isEmpty;
  }
}
