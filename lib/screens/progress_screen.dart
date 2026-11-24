import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../app/theme.dart';

import '../core/constants.dart';
import '../data/app_data.dart';
import '../services/progress_service.dart';
import '../widgets/kit.dart';

/// Écran de progression détaillée par catégorie.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progression')),
      body: ListenableBuilder(
        listenable: ProgressService.instance,
        builder: (context, _) {
          final sectionsDone = ProgressService.instance.completedSections.length;
          final exercisesDone = ProgressService.instance.passedExercises.length;
          final projectsDone = ProgressService.instance.completedProjects.length;

          final totalSections = AppData.totalSections;
          final totalExercises = AppData.totalExercises;
          final totalProjects = AppData.totalProjects;

          final globalPoints = totalSections + totalExercises + totalProjects;
          final globalDone = sectionsDone + exercisesDone + projectsDone;
          final globalRatio = globalPoints == 0 ? 0.0 : globalDone / globalPoints;

          // Par catégorie : leçons + exercices + projets rattachés.
          final categoryRows = <({String name, int done, int total})>[];
          for (final category in ProgressCategories.all) {
            final sections = AppData.allSections
                .where((s) => ProgressCategories.byModule[s.moduleId] == category);
            final exercises = AppData.exercises
                .where((e) => ProgressCategories.byModule[e.moduleId] == category);
            final projects = AppData.projects.where((p) => p.category == category);
            final total = sections.length + exercises.length + projects.length;
            final done =
                sections.where((s) => ProgressService.instance.isSectionComplete(s.id)).length +
                    exercises.where((e) => ProgressService.instance.isExercisePassed(e.id)).length +
                    projects.where((p) => ProgressService.instance.isProjectComplete(p.id)).length;
            categoryRows.add((name: category, done: done, total: total));
          }
          final activeCategories = categoryRows.where((r) => r.total > 0).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: LabColors.seed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Progression globale',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                        Text('${(globalRatio * 100).round()}%',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: LabColors.seed.readable(context))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LabProgress(value: globalRatio, color: LabColors.seed, height: 10),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _countCol(icon: Icons.menu_book, value: sectionsDone, total: totalSections, label: 'Leçons', color: LabColors.coral),
                        const SizedBox(width: 10),
                        _countCol(icon: Icons.fitness_center, value: exercisesDone, total: totalExercises, label: 'Exercices', color: LabColors.amber),
                        const SizedBox(width: 10),
                        _countCol(icon: Icons.construction, value: projectsDone, total: totalProjects, label: 'Projets', color: LabColors.purple),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionHeader(
                icon: Icons.bar_chart,
                title: 'Par catégorie',
                subtitle: 'Leçons + exercices + projets',
              ),
              const SizedBox(height: 12),
              for (final row in activeCategories) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(row.name,
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    ),
                    Text('${row.done}/${row.total}',
                        style: const TextStyle(fontSize: 12.5)),
                  ],
                ),
                const SizedBox(height: 6),
                LabProgress(
                  value: row.total == 0 ? 0 : row.done / row.total,
                  color: _colorFor(row.name),
                  height: 6,
                ),
                const SizedBox(height: 14),
              ],
            ],
          );
        },
      ),
    );
  }

  Color _colorFor(String category) => switch (category) {
        'jQuery' => LabColors.seed,
        'DOM' => LabColors.coral,
        'Événements' => LabColors.amber,
        'Animations' => LabColors.sky,
        'AJAX' => LabColors.terminal,
        'REST' => LabColors.purple,
        _ => LabColors.seed,
      };

  Widget _countCol({
    required IconData icon,
    required int value,
    required int total,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Builder(
              builder: (context) =>
                  Icon(icon, color: color.readable(context, ratio: 3), size: 18),
            ),
            const SizedBox(height: 6),
            Text('$value/$total',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
