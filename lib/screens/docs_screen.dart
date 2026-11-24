import 'package:flutter/material.dart';

import '../app/theme.dart';

import '../data/app_data.dart';
import '../models/snippet.dart';
import '../widgets/code_view.dart';
import '../widgets/kit.dart';

/// Aide-mémoire : fiches de référence et glossaire.
class DocsScreen extends StatefulWidget {
  const DocsScreen({super.key});

  @override
  State<DocsScreen> createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);
  String _query = '';

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<Snippet> get _snippets {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return AppData.snippets;
    return AppData.snippets
        .where((s) =>
            s.name.toLowerCase().contains(q) ||
            s.description.toLowerCase().contains(q) ||
            s.category.toLowerCase().contains(q) ||
            s.syntax.toLowerCase().contains(q))
        .toList();
  }

  List<GlossaryEntry> get _glossary {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return AppData.glossary;
    return AppData.glossary
        .where((g) =>
            g.term.toLowerCase().contains(q) || g.definition.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Chercher une fiche ou un terme…',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Fiches', icon: Icon(Icons.sticky_note_2_outlined, size: 18)),
            Tab(text: 'Glossaire', icon: Icon(Icons.book_outlined, size: 18)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _SnippetsList(snippets: _snippets),
              _GlossaryList(entries: _glossary),
            ],
          ),
        ),
      ],
    );
  }
}

class _SnippetsList extends StatelessWidget {
  final List<Snippet> snippets;
  const _SnippetsList({required this.snippets});

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<Snippet>>{};
    for (final s in snippets) {
      groups.putIfAbsent(s.category, () => []).add(s);
    }
    final categories = groups.keys.toList()..sort();

    if (snippets.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'Aucune fiche',
        message: 'Aucune fiche ne correspond à votre recherche.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        for (final category in categories) ...[
          SectionHeader(
            icon: Icons.folder_outlined,
            title: category,
            subtitle: '${groups[category]!.length} fiche(s)',
            color: LabColors.seed,
          ),
          const SizedBox(height: 10),
          for (final s in groups[category]!)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SnippetCard(snippet: s),
            ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _SnippetCard extends StatelessWidget {
  final Snippet snippet;
  const _SnippetCard({required this.snippet});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: CircleAvatar(
        backgroundColor: LabColors.seed.withValues(alpha: 0.12),
        child: Icon(snippet.icon, color: LabColors.seed, size: 18),
      ),
      title: Text(snippet.name,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 15, fontWeight: FontWeight.w700)),
      subtitle: Text(snippet.description,
          style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Syntaxe',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary)),
        ),
        const SizedBox(height: 6),
        CodeView(code: snippet.syntax, language: 'syntaxe', compact: true),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Exemple',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary)),
        ),
        const SizedBox(height: 6),
        CodeView(code: snippet.example, language: 'javascript', compact: true),
      ],
    );
  }
}

class _GlossaryList extends StatelessWidget {
  final List<GlossaryEntry> entries;
  const _GlossaryList({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'Aucun terme',
        message: 'Aucun terme du glossaire ne correspond à votre recherche.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final g = entries[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: CircleAvatar(
              backgroundColor: LabColors.purple.withValues(alpha: 0.14),
              child: const Icon(Icons.book, color: LabColors.purple, size: 18),
            ),
            title: Text(g.term,
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
            subtitle: Text(g.definition,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12)),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(g.definition, style: const TextStyle(height: 1.5)),
              ),
              if (g.example != null) ...[
                const SizedBox(height: 10),
                CodeView(code: g.example!, language: 'javascript', compact: true),
              ],
            ],
          ),
        );
      },
    );
  }
}
