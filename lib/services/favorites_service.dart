import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

enum FavoriteKind { course, section, exercise, project, snippet }

extension FavoriteKindLabel on FavoriteKind {
  String get label => switch (this) {
        FavoriteKind.course => 'Cours',
        FavoriteKind.section => 'Leçon',
        FavoriteKind.exercise => 'Exercice',
        FavoriteKind.project => 'Projet',
        FavoriteKind.snippet => 'Fiche',
      };
}

class Favorite {
  final FavoriteKind kind;
  final String id;

  const Favorite(this.kind, this.id);

  String get key => '${kind.name}:$id';

  Map<String, dynamic> toJson() => {'kind': kind.name, 'id': id};

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        FavoriteKind.values.asNameMap()[json['kind']] ?? FavoriteKind.section,
        json['id'] as String,
      );
}

/// Gère la liste des favoris (cours, leçons, exercices, projets, fiches).
class FavoritesService extends ChangeNotifier {
  FavoritesService._();

  static final FavoritesService instance = FavoritesService._();

  final Set<Favorite> _favorites = {};
  bool _loaded = false;

  List<Favorite> get favorites {
    final list = _favorites.toList();
    list.sort((a, b) => a.key.compareTo(b.key));
    return list;
  }

  bool get isLoaded => _loaded;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(StorageKeys.favoritesJson);
      if (raw != null && raw.isNotEmpty) {
        final list = (jsonDecode(raw) as List<dynamic>? ?? const []);
        for (final item in list) {
          _favorites.add(Favorite.fromJson(item as Map<String, dynamic>));
        }
      }
      _loaded = true;
      notifyListeners();
    } catch (_) {
      _loaded = true;
    }
  }

  bool isFavorite(FavoriteKind kind, String id) =>
      _favorites.any((f) => f.kind == kind && f.id == id);

  Future<void> toggle(FavoriteKind kind, String id) async {
    final existing = _favorites.any((f) => f.kind == kind && f.id == id);
    if (existing) {
      _favorites.removeWhere((f) => f.kind == kind && f.id == id);
    } else {
      _favorites.add(Favorite(kind, id));
    }
    notifyListeners();
    await _save();
  }

  Future<void> remove(Favorite favorite) async {
    _favorites.removeWhere((f) => f.kind == favorite.kind && f.id == favorite.id);
    notifyListeners();
    await _save();
  }

  /// Vide la liste des favoris (après confirmation).
  Future<void> reset() async {
    _favorites.clear();
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        StorageKeys.favoritesJson,
        jsonEncode(_favorites.map((f) => f.toJson()).toList()),
      );
    } catch (_) {
      // Stockage indisponible (tests) : on ignore.
    }
  }
}
