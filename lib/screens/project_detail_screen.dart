import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../widgets/favorite_button.dart';
import '../models/project.dart';
import '../services/favorites_service.dart';
import '../services/progress_service.dart';
import '../widgets/code_view.dart';
import '../widgets/kit.dart';
import 'lab_screen.dart';

/// Déroulé d'un projet : objectifs, étapes, indices, solutions et code complet.
class ProjectDetailScreen extends StatefulWidget {
  final MiniProject project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final Set<int> _expandedTasks = {};
  final Set<int> _shownHints = {};
  final Set<int> _shownSolutions = {};

  MiniProject get project => widget.project;

  void _openLab({required String html, required String js, String? css}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LabPage(
          initialHtml: html,
          initialJs: js,
          initialCss: css ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projet'),
        actions: [
          FavoriteButton(kind: FavoriteKind.project, id: project.id),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([ProgressService.instance, FavoritesService.instance]),
        builder: (context, _) {
          final isDone = ProgressService.instance.isProjectComplete(project.id);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: (project.isFinalProject ? scheme.primary : scheme.tertiary)
                          .withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      project.icon,
                      color: project.isFinalProject ? scheme.primary : scheme.tertiary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        Text(project.category,
                            style: TextStyle(
                                fontSize: 12.5,
                                color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  if (isDone)
                    Icon(Icons.check_circle, color: Colors.green.readable(context, ratio: 3)),
                ],
              ),
              const SizedBox(height: 16),
              Text(project.intro, style: const TextStyle(height: 1.5)),
              const SizedBox(height: 16),
              const SectionHeader(
                icon: Icons.flag,
                title: 'Objectifs',
                subtitle: 'Ce que vous allez construire',
              ),
              const SizedBox(height: 10),
              for (final o in project.objectives)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_box_outlined, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(o, style: const TextStyle(height: 1.4))),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              const SectionHeader(
                icon: Icons.format_list_numbered,
                title: 'Étapes',
                subtitle: 'Suivez-les une par une',
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < project.tasks.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TaskCard(
                    index: i,
                    task: project.tasks[i],
                    expanded: _expandedTasks.contains(i),
                    hintShown: _shownHints.contains(i),
                    solutionShown: _shownSolutions.contains(i),
                    onToggle: () => setState(() {
                      if (_expandedTasks.contains(i)) {
                        _expandedTasks.remove(i);
                      } else {
                        _expandedTasks.add(i);
                      }
                    }),
                    onShowHint: () => setState(() => _shownHints.add(i)),
                    onShowSolution: () => setState(() => _shownSolutions.add(i)),
                  ),
                ),
              const SizedBox(height: 8),
              const SectionHeader(
                icon: Icons.rocket_launch,
                title: 'Code final',
                subtitle: 'Le résultat attendu, prêt à tester',
              ),
              const SizedBox(height: 12),
              CodeView(
                code: project.finalCode,
                language: 'html',
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _openLab(
                  html: project.finalCode,
                  js: '',
                ),
                icon: const Icon(Icons.science_outlined, size: 18),
                label: const Text('Exécuter le code final dans le Lab'),
              ),
              const SizedBox(height: 20),
              if (isDone)
                FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Projet terminé'),
                )
              else
                FilledButton.icon(
                  onPressed: () => ProgressService.instance.markProjectComplete(project.id),
                  icon: const Icon(Icons.task_alt),
                  label: const Text('Marquer le projet comme terminé'),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final int index;
  final ProjectTask task;
  final bool expanded;
  final bool hintShown;
  final bool solutionShown;
  final VoidCallback onToggle;
  final VoidCallback onShowHint;
  final VoidCallback onShowSolution;

  const _TaskCard({
    required this.index,
    required this.task,
    required this.expanded,
    required this.hintShown,
    required this.solutionShown,
    required this.onToggle,
    required this.onShowHint,
    required this.onShowSolution,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text('${index + 1}',
                          style: TextStyle(
                              color: scheme.onPrimaryContainer,
                              fontWeight: FontWeight.w800,
                              fontSize: 13)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Étape ${index + 1} · ${task.title}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                    Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
              ),
            ),
            if (expanded)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(task.instruction, style: const TextStyle(height: 1.5)),
                    const SizedBox(height: 10),
                    if (!hintShown && task.hint != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: onShowHint,
                          icon: const Icon(Icons.lightbulb_outline, size: 16),
                          label: const Text('Indice'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                    if (hintShown)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('💡 ${task.hint}',
                            style: const TextStyle(height: 1.4)),
                      ),
                    if (!solutionShown)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: onShowSolution,
                          icon: const Icon(Icons.visibility_outlined, size: 16),
                          label: const Text('Voir la solution'),
                        ),
                      ),
                    if (solutionShown) ...[
                      const SizedBox(height: 4),
                      CodeView(code: task.solution, language: 'html', compact: true),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
