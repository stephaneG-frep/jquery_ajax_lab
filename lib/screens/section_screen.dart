import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/course.dart';
import '../services/favorites_service.dart';
import '../services/progress_service.dart';
import '../widgets/explain_sheet.dart';
import '../widgets/lesson_blocks.dart';
import 'exercise_detail_screen.dart';

/// Lecture d'une leçon avec marquage « terminée » et explications.
class SectionScreen extends StatefulWidget {
  final CourseSection section;

  const SectionScreen({super.key, required this.section});

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final module = AppData.moduleOfSection(section.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leçon'),
        actions: [
          ListenableBuilder(
            listenable: FavoritesService.instance,
            builder: (context, _) {
              final fav = FavoritesService.instance.isFavorite(FavoriteKind.section, section.id);
              return IconButton(
                tooltip: fav ? 'Retirer des favoris' : 'Ajouter aux favoris',
                icon: Icon(fav ? Icons.star : Icons.star_border, color: fav ? Colors.amber : null),
                onPressed: () => FavoritesService.instance.toggle(FavoriteKind.section, section.id),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([ProgressService.instance, FavoritesService.instance]),
        builder: (context, _) {
          final isDone = ProgressService.instance.isSectionComplete(section.id);
          final allSections = AppData.allSections;
          final index = allSections.indexWhere((s) => s.id == section.id);
          final next = index >= 0 && index < allSections.length - 1 ? allSections[index + 1] : null;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    if (module != null)
                      Text(
                        'Module ${module.number} · ${module.title}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      section.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    LessonBlocks(
                      blocks: section.blocks,
                      onExplainTap: (block) => showCodeExplanation(context, block),
                      onExerciseTap: (id) {
                        final ex = AppData.exerciseById(id);
                        if (ex != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: ex)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: Theme.of(context).dividerTheme.color ?? Colors.transparent),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isDone)
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Leçon terminée'),
                          ),
                        )
                      else
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => ProgressService.instance.markSectionComplete(section.id),
                            icon: const Icon(Icons.check),
                            label: const Text('Terminer cette leçon'),
                          ),
                        ),
                      if (next != null) ...[
                        const SizedBox(width: 10),
                        IconButton.filledTonal(
                          tooltip: 'Leçon suivante',
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            ProgressService.instance.setCurrentSection(next.id);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => SectionScreen(section: next),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
