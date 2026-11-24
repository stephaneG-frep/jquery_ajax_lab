import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/app_data.dart';
import '../models/course.dart';
import '../models/exercise.dart';
import '../services/favorites_service.dart';
import '../services/progress_service.dart';
import '../widgets/kit.dart';
import 'exercise_detail_screen.dart';
import 'section_screen.dart';

/// Détail d'un module : liste des leçons et exercices liés.
class CourseDetailScreen extends StatefulWidget {
  final CourseModule module;

  const CourseDetailScreen({super.key, required this.module});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Color get _color {
    final index = AppData.modules.indexOf(widget.module);
    const palette = [
      LabColors.seed,
      LabColors.coral,
      LabColors.amber,
      LabColors.purple,
      LabColors.sky,
      LabColors.terminal,
    ];
    return palette[index % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    final moduleExercises = AppData.exercises.where((e) => e.moduleId == module.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Module ${module.number}'),
        actions: [
          ListenableBuilder(
            listenable: FavoritesService.instance,
            builder: (context, _) {
              final fav = FavoritesService.instance.isFavorite(FavoriteKind.course, module.id);
              return IconButton(
                tooltip: fav ? 'Retirer des favoris' : 'Ajouter aux favoris',
                icon: Icon(fav ? Icons.star : Icons.star_border, color: fav ? Colors.amber : null),
                onPressed: () => FavoritesService.instance.toggle(FavoriteKind.course, module.id),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([ProgressService.instance, FavoritesService.instance]),
        builder: (context, _) {
          final done = module.sections
              .where((s) => ProgressService.instance.isSectionComplete(s.id))
              .length;
          final ratio = module.sections.isEmpty ? 0.0 : done / module.sections.length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(module.icon, color: _color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(module.title,
                            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(module.subtitle,
                            style: TextStyle(
                                fontSize: 12.5,
                                color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LabProgress(value: ratio, color: _color),
              const SizedBox(height: 6),
              Text(
                '$done/${module.totalSections} leçons terminées',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              const SectionHeader(
                icon: Icons.menu_book,
                title: 'Leçons',
                subtitle: 'Suivez-les dans l\'ordre',
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < module.sections.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SectionTile(
                    section: module.sections[i],
                    number: i + 1,
                    color: _color,
                    onTap: () {
                      ProgressService.instance.setCurrentSection(module.sections[i].id);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SectionScreen(section: module.sections[i]),
                        ),
                      );
                    },
                  ),
                ),
              if (moduleExercises.isNotEmpty) ...[
                const SizedBox(height: 8),
                const SectionHeader(
                  icon: Icons.fitness_center,
                  title: 'Exercices du module',
                  subtitle: 'Validez ce que vous avez appris',
                ),
                const SizedBox(height: 12),
                for (final ex in moduleExercises)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        leading: CircleAvatar(
                          backgroundColor: _color.withValues(alpha: 0.15),
                          child: Icon(ex.type == ExerciseType.choice
                              ? Icons.quiz_outlined
                              : Icons.code, color: _color, size: 18),
                        ),
                        title: Text(ex.title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        subtitle: Text('${ex.level.label} · ${ex.category}',
                            style: const TextStyle(fontSize: 12)),
                        trailing: ProgressService.instance.isExercisePassed(ex.id)
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: ex)),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final CourseSection section;
  final int number;
  final Color color;
  final VoidCallback onTap;

  const _SectionTile({
    required this.section,
    required this.number,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final done = ProgressService.instance.isSectionComplete(section.id);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: done ? Colors.green.withValues(alpha: 0.15) : color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: done
                    ? const Icon(Icons.check, color: Colors.green, size: 20)
                    : Text('$number',
                        style: TextStyle(fontWeight: FontWeight.w800, color: color)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(section.title,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
