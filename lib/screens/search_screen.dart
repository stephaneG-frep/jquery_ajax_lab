import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../widgets/snippet_sheet.dart';
import '../data/app_data.dart';
import '../services/progress_service.dart';
import '../widgets/code_view.dart';
import '../widgets/kit.dart';
import 'course_detail_screen.dart';
import 'exercise_detail_screen.dart';
import 'project_detail_screen.dart';
import 'section_screen.dart';

/// Recherche globale dans les cours, exercices, projets, fiches et glossaire.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  bool _showGlossary = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<SearchResult> get _results {
    final all = AppData.search(_query);
    return _showGlossary ? all : all.where((r) => r.type != SearchResultType.glossary).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Ex : ajax, fadeIn, jQuery, REST…',
                prefixIcon: Icon(Icons.search),
                suffixIcon: null,
              ),
            ),
          ),
        ),
      ),
      body: _query.trim().isEmpty
          ? const EmptyState(
              icon: Icons.search,
              title: 'Que cherchez-vous ?',
              message: 'Recherchez dans les cours, leçons, exercices, projets, fiches et le glossaire.',
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      Text('${results.length} résultat(s)',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text('Glossaire',
                          style: const TextStyle(fontSize: 12.5)),
                      const SizedBox(width: 6),
                      Switch(
                        value: _showGlossary,
                        onChanged: (v) => setState(() => _showGlossary = v),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: results.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off,
                          title: 'Aucun résultat',
                          message: 'Essayez un autre mot-clé, par exemple « ajax » ou « fade ».',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          itemCount: results.length,
                          itemBuilder: (context, i) {
                            final r = results[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Card(
                                child: ListTile(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  leading: CircleAvatar(
                                    backgroundColor: r.color.withValues(alpha: 0.14),
                                    child: Icon(r.icon, color: r.color.readable(context, ratio: 3), size: 18),
                                  ),
                                  title: Text(r.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                  subtitle: Text(r.subtitle, style: const TextStyle(fontSize: 12)),
                                  trailing: const Icon(Icons.chevron_right, size: 20),
                                  onTap: () => _open(r),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _open(SearchResult r) {
    switch (r.type) {
      case SearchResultType.course:
        final m = AppData.moduleById(r.id.split(':').last);
        if (m == null) return;
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => CourseDetailScreen(module: m)));
      case SearchResultType.section:
        final s = AppData.sectionById(r.id.split(':').last);
        if (s == null) return;
        ProgressService.instance.setCurrentSection(s.id);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SectionScreen(section: s)));
      case SearchResultType.exercise:
        final e = AppData.exerciseById(r.id.split(':').last);
        if (e == null) return;
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: e)));
      case SearchResultType.project:
        final p = AppData.projectById(r.id.split(':').last);
        if (p == null) return;
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: p)));
      case SearchResultType.snippet:
        final s = AppData.snippetById(r.id.split(':').last);
        if (s == null) return;
        showSnippetSheet(context, s);
      case SearchResultType.glossary:
        final term = r.id.split(':').last;
        final entry = AppData.glossary.where((g) => g.term == term).firstOrNull;
        if (entry == null) return;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Text(entry.term,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(entry.definition, style: const TextStyle(height: 1.5)),
              if (entry.example != null) ...[
                const SizedBox(height: 12),
                CodeView(code: entry.example!, language: 'javascript', compact: true),
              ],
            ],
          ),
        );
    }
  }
}
