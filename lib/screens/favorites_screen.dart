import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../widgets/snippet_sheet.dart';
import '../app/theme.dart';
import '../data/app_data.dart';
import '../services/favorites_service.dart';
import '../services/progress_service.dart';
import '../widgets/kit.dart';
import 'course_detail_screen.dart';
import 'exercise_detail_screen.dart';
import 'project_detail_screen.dart';
import 'section_screen.dart';

/// Écran des favoris : cours, leçons, exercices, projets et fiches.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: ListenableBuilder(
        listenable: FavoritesService.instance,
        builder: (context, _) {
          final favorites = FavoritesService.instance.favorites;
          if (favorites.isEmpty) {
            return const EmptyState(
              icon: Icons.star_border,
              title: 'Aucun favori',
              message: 'Touchez l\'étoile sur une leçon, un exercice, un projet ou une fiche pour la retrouver ici.',
              action: SizedBox.shrink(),
            );
          }

          final courses = favorites.where((f) => f.kind == FavoriteKind.course).toList();
          final sections = favorites.where((f) => f.kind == FavoriteKind.section).toList();
          final exercises = favorites.where((f) => f.kind == FavoriteKind.exercise).toList();
          final projects = favorites.where((f) => f.kind == FavoriteKind.project).toList();
          final snippets = favorites.where((f) => f.kind == FavoriteKind.snippet).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (courses.isNotEmpty) ...[
                _groupHeader(Icons.school, 'Cours', courses.length),
                for (final f in courses)
                  _favoriteTile(
                    icon: Icons.school_outlined,
                    color: LabColors.seed,
                    title: _courseTitle(f.id),
                    subtitle: 'Cours',
                    onTap: () => _openCourse(f.id),
                    onRemove: () => FavoritesService.instance.remove(f),
                  ),
                const SizedBox(height: 6),
              ],
              if (sections.isNotEmpty) ...[
                _groupHeader(Icons.menu_book, 'Leçons', sections.length),
                for (final f in sections)
                  _favoriteTile(
                    icon: Icons.menu_book_outlined,
                    color: LabColors.coral,
                    title: _sectionTitle(f.id),
                    subtitle: 'Leçon',
                    onTap: () => _openSection(f.id),
                    onRemove: () => FavoritesService.instance.remove(f),
                  ),
                const SizedBox(height: 6),
              ],
              if (exercises.isNotEmpty) ...[
                _groupHeader(Icons.fitness_center, 'Exercices', exercises.length),
                for (final f in exercises)
                  _favoriteTile(
                    icon: Icons.fitness_center,
                    color: LabColors.amber,
                    title: _exerciseTitle(f.id),
                    subtitle: 'Exercice',
                    onTap: () => _openExercise(f.id),
                    onRemove: () => FavoritesService.instance.remove(f),
                  ),
                const SizedBox(height: 6),
              ],
              if (projects.isNotEmpty) ...[
                _groupHeader(Icons.construction, 'Projets', projects.length),
                for (final f in projects)
                  _favoriteTile(
                    icon: Icons.construction_outlined,
                    color: LabColors.purple,
                    title: _projectTitle(f.id),
                    subtitle: 'Projet',
                    onTap: () => _openProject(f.id),
                    onRemove: () => FavoritesService.instance.remove(f),
                  ),
                const SizedBox(height: 6),
              ],
              if (snippets.isNotEmpty) ...[
                _groupHeader(Icons.sticky_note_2, 'Fiches', snippets.length),
                for (final f in snippets)
                  _favoriteTile(
                    icon: Icons.sticky_note_2_outlined,
                    color: LabColors.sky,
                    title: _snippetTitle(f.id),
                    subtitle: 'Fiche',
                    onTap: () => _showSnippet(f.id),
                    onRemove: () => FavoritesService.instance.remove(f),
                  ),
                const SizedBox(height: 6),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _groupHeader(IconData icon, String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SectionHeader(
        icon: icon,
        title: label,
        subtitle: '$count élément(s)',
      ),
    );
  }

  Widget _favoriteTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(icon, color: color.readable(context, ratio: 3), size: 18),
        ),
        title: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: IconButton(
          tooltip: 'Retirer des favoris',
          icon: Icon(Icons.star, color: Colors.amber.readable(context, ratio: 3)),
          onPressed: onRemove,
        ),
        onTap: onTap,
      ),
    );
  }

  String _courseTitle(String id) {
    final m = AppData.moduleById(id);
    return m != null ? m.title : id;
  }

  String _sectionTitle(String id) {
    final s = AppData.sectionById(id);
    return s != null ? s.title : id;
  }

  String _exerciseTitle(String id) {
    final e = AppData.exerciseById(id);
    return e != null ? e.title : id;
  }

  String _projectTitle(String id) {
    final p = AppData.projectById(id);
    return p != null ? p.title : id;
  }

  String _snippetTitle(String id) {
    final s = AppData.snippetById(id);
    return s != null ? s.name : id;
  }

  void _openCourse(String id) {
    final m = AppData.moduleById(id);
    if (m == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CourseDetailScreen(module: m)));
  }

  void _openSection(String id) {
    final s = AppData.sectionById(id);
    if (s == null) return;
    ProgressService.instance.setCurrentSection(s.id);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SectionScreen(section: s)));
  }

  void _openExercise(String id) {
    final e = AppData.exerciseById(id);
    if (e == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: e)));
  }

  void _openProject(String id) {
    final p = AppData.projectById(id);
    if (p == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: p)));
  }

  void _showSnippet(String id) {
    final s = AppData.snippetById(id);
    if (s == null) return;
    showSnippetSheet(context, s);
  }
}
