/// Prépare un texte pour une recherche insensible à la casse et aux accents.
String foldText(String text) {
  const accents = {
    'à': 'a', 'â': 'a', 'ä': 'a', 'á': 'a', 'ã': 'a',
    'ç': 'c',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'î': 'i', 'ï': 'i', 'í': 'i',
    'ô': 'o', 'ö': 'o', 'ó': 'o', 'õ': 'o',
    'ù': 'u', 'û': 'u', 'ü': 'u', 'ú': 'u',
    'ÿ': 'y', 'ñ': 'n', 'œ': 'oe', 'æ': 'ae', '’': "'",
  };
  return text
      .toLowerCase()
      .replaceAll('**', '')
      .replaceAllMapped(RegExp('[à-ÿœ’]'), (m) => accents[m[0]] ?? m[0]!);
}
