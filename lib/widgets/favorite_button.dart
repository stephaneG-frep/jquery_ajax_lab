import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../services/favorites_service.dart';

/// Étoile qui ajoute ou retire un élément des favoris.
class FavoriteButton extends StatelessWidget {
  final FavoriteKind kind;
  final String id;

  const FavoriteButton({super.key, required this.kind, required this.id});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final fav = FavoritesService.instance.isFavorite(kind, id);
        return IconButton(
          tooltip: fav ? 'Retirer des favoris' : 'Ajouter aux favoris',
          icon: Icon(
            fav ? Icons.star : Icons.star_border,
            color: fav ? Colors.amber.readable(context, ratio: 3) : null,
          ),
          onPressed: () => FavoritesService.instance.toggle(kind, id),
        );
      },
    );
  }
}
