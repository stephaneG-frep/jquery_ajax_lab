import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../app/theme.dart';
import '../data/app_data.dart';
import '../models/course.dart';
import '../models/exercise.dart';
import '../services/progress_service.dart';
import '../widgets/kit.dart';
import 'course_detail_screen.dart';
import 'exercise_detail_screen.dart';

/// Onglet Cours : parcours des modules, avec bascule vers les exercices.
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _showExercises = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Modules'), icon: Icon(Icons.school, size: 16)),
                ButtonSegment(value: true, label: Text('Exercices'), icon: Icon(Icons.fitness_center, size: 16)),
              ],
              selected: {_showExercises},
              onSelectionChanged: (s) => setState(() => _showExercises = s.first),
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: ProgressService.instance,
              // Sans const : les listes doivent être reconstruites à chaque progrès.
              builder: (context, _) => _showExercises ? _ExercisesList() : _ModulesList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModulesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final modules = AppData.modules;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: modules.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final module = modules[i];
        final done = module.sections
            .where((s) => ProgressService.instance.isSectionComplete(s.id))
            .length;
        final ratio = module.sections.isEmpty ? 0.0 : done / module.sections.length;
        final colors = _moduleColor(i).readable(context);
        return _ModuleCard(
          module: module,
          ratio: ratio,
          done: done,
          colors: colors,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CourseDetailScreen(module: module)),
          ),
        );
      },
    );
  }

  Color _moduleColor(int i) {
    const palette = [
      LabColors.seed,
      LabColors.coral,
      LabColors.amber,
      LabColors.purple,
      LabColors.sky,
      LabColors.terminal,
    ];
    return palette[i % palette.length];
  }
}

class _ModuleCard extends StatelessWidget {
  final CourseModule module;
  final double ratio;
  final int done;
  final Color colors;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.module,
    required this.ratio,
    required this.done,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: colors.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(module.icon, color: colors, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Module ${module.number}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: colors,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          module.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(ratio * 100).round()}%',
                    style: TextStyle(fontWeight: FontWeight.w800, color: colors),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(module.subtitle,
                  style: TextStyle(
                      fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              LabProgress(value: ratio, color: colors),
              const SizedBox(height: 6),
              Text(
                '$done/${module.totalSections} leçons terminées',
                style: TextStyle(fontSize: 11.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExercisesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exercises = AppData.exercises;
    final passed = ProgressService.instance.passedExercises;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: exercises.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final ex = exercises[i];
        final isDone = passed.contains(ex.id);
        return Card(
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: CircleAvatar(
              backgroundColor: _levelColor(ex.level).withValues(alpha: 0.15),
              child: Icon(_levelIcon(ex.level), size: 18, color: _levelColor(ex.level).readable(context, ratio: 3)),
            ),
            title: Text(ex.title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
            subtitle: Text(
              '${ex.category} · ${ex.level.label}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: isDone
                ? Icon(Icons.check_circle, color: Colors.green.readable(context, ratio: 3))
                : const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: ex)),
            ),
          ),
        );
      },
    );
  }

  Color _levelColor(ExerciseLevel level) => switch (level) {
        ExerciseLevel.guided => Colors.green,
        ExerciseLevel.semiGuided => Colors.orange,
        ExerciseLevel.autonomous => Colors.deepPurple,
      };

  IconData _levelIcon(ExerciseLevel level) => switch (level) {
        ExerciseLevel.guided => Icons.map,
        ExerciseLevel.semiGuided => Icons.flag,
        ExerciseLevel.autonomous => Icons.rocket_launch,
      };
}
