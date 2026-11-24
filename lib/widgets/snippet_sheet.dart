import 'package:flutter/material.dart';

import '../models/snippet.dart';
import '../services/favorites_service.dart';
import 'code_view.dart';
import 'favorite_button.dart';

/// Ouvre une fiche de référence dans un panneau.
Future<void> showSnippetSheet(BuildContext context, Snippet snippet) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(snippet.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              FavoriteButton(kind: FavoriteKind.snippet, id: snippet.id),
            ],
          ),
          const SizedBox(height: 4),
          Text(snippet.description, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 12),
          const Text('Syntaxe', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          CodeView(code: snippet.syntax, language: 'syntaxe', compact: true),
          const SizedBox(height: 12),
          const Text('Exemple', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          CodeView(code: snippet.example, language: 'javascript', compact: true),
        ],
      ),
    ),
  );
}
