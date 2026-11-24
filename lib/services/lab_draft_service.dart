import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

/// Contenu des éditeurs du laboratoire.
typedef LabCode = ({String html, String css, String js});

/// Conserve le code de l'onglet Lab entre deux lancements.
class LabDraftService {
  LabDraftService._();

  static final LabDraftService instance = LabDraftService._();

  LabCode? _code;
  String? _presetId;

  /// Dernier code enregistré, ou null au premier lancement.
  LabCode? get code => _code;

  /// Exemple dont ce code est parti.
  String? get presetId => _presetId;

  Future<void> load() async {
    _code = null;
    _presetId = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(StorageKeys.labDraftJson);
      if (raw == null) return;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _code = (
        html: map['html'] as String,
        css: map['css'] as String,
        js: map['js'] as String,
      );
      _presetId = map['preset'] as String?;
    } catch (_) {
      // Brouillon illisible ou stockage indisponible : on repart de l'exemple.
    }
  }

  Future<void> save(LabCode code, String? presetId) async {
    if (code == _code && presetId == _presetId) return;
    _code = code;
    _presetId = presetId;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        StorageKeys.labDraftJson,
        jsonEncode({'html': code.html, 'css': code.css, 'js': code.js, 'preset': presetId}),
      );
    } catch (_) {
      // Stockage indisponible : le code reste en mémoire.
    }
  }
}
