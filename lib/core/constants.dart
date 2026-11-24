/// Constantes globales de l'application : identité, citations et catégories.
library;

class AppInfo {
  static const String name = 'jQuery AJAX Lab';
  static const String tagline = 'Le laboratoire pour apprendre le Web, jQuery et AJAX';
  static const String version = '1.0.0';
  static const String description =
      'Application éducative pour apprendre progressivement les bases du Web, '
      'HTML, JavaScript, jQuery, la manipulation du DOM, les événements, les '
      'animations, AJAX, HTTP, JSON et les API REST.';
}

/// Citations / astuces affichées sur l'écran d'accueil.
class Quotes {
  static const List<String> all = [
    'Un programme est une pensée rendue exécutable.',
    'Le débogage, c\u2019est deux fois plus difficile que l\u2019écriture. Alors écrivez le code le plus simple possible.',
    'Tout apprenti développeur est un futur architecte.',
    r'$ est une fonction, pas un sortilège.',
    'AJAX, ce n\u2019est pas de la magie : c\u2019est une requête HTTP.',
    'Le DOM est l\u2019arbre que JavaScript apprend à tailler.',
    'Une API, c\u2019est le serveur qui parle à travers une porte.',
    'JSON : des clés, des valeurs, et beaucoup de promesses.',
    r'fetch() est la suite moderne de $.ajax().',
    'Toute erreur HTTP est une information, pas une insulte.',
    'Un développeur qui teste est un développeur qui dort bien.',
    'La curiosité est la première dépendance du développeur.',
  ];
}

/// Libellés courts pour la barre de navigation.
class Tabs {
  static const int home = 0;
  static const int courses = 1;
  static const int lab = 2;
  static const int projects = 3;
  static const int docs = 4;
}

/// Clés de stockage (shared_preferences).
class StorageKeys {
  static const String settingsTheme = 'settings.theme';
  static const String settingsTextScale = 'settings.textScale';
  static const String settingsCodeSize = 'settings.codeSize';
  static const String progressJson = 'progress.data';
  static const String favoritesJson = 'favorites.data';
}

/// Catégories de progression affichées dans l'écran Progression.
class ProgressCategories {
  static const List<String> all = [
    'Bases du Web',
    'jQuery',
    'DOM',
    'Événements',
    'Animations',
    'AJAX',
    'REST',
  ];

  /// Catégorie de chaque module ; leçons et exercices en héritent.
  /// (Les projets portent directement leur catégorie.)
  static const Map<String, String> byModule = {
    'web': 'Bases du Web',
    'html': 'Bases du Web',
    'js': 'Bases du Web',
    'jquery': 'jQuery',
    'dom': 'DOM',
    'events': 'Événements',
    'anim': 'Animations',
    'ajax': 'AJAX',
    'http': 'AJAX',
    'json': 'AJAX',
    'rest': 'REST',
    'modern': 'AJAX',
  };
}
