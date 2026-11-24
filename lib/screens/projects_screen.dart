import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../data/app_data.dart';
import '../models/project.dart';
import '../services/progress_service.dart';
import '../widgets/kit.dart';
import 'project_detail_screen.dart';

/// Onglet Projets : les 10 mini-projets et le projet final.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finalProject = AppData.projects.firstWhere((p) => p.isFinalProject);
    final miniProjects = AppData.projects.where((p) => !p.isFinalProject).toList();

    return ListenableBuilder(
      listenable: ProgressService.instance,
      builder: (context, _) {
        final done = AppData.projects
            .where((p) => ProgressService.instance.isProjectComplete(p.id))
            .length;
        final ratio = AppData.projects.isEmpty ? 0.0 : done / AppData.projects.length;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$done/${AppData.projects.length} projets terminés',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    LabProgress(value: ratio),
                    const SizedBox(height: 4),
                    Text(
                      ratio >= 1
                          ? 'Parcours de projets complet !'
                          : 'Terminez un projet pour progresser.',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(
              icon: Icons.workspace_premium,
              title: 'Projet final',
              subtitle: 'Assemblez tout ce que vous avez appris',
            ),
            const SizedBox(height: 12),
            _ProjectCard(project: finalProject, featured: true),
            const SizedBox(height: 20),
            const SectionHeader(
              icon: Icons.construction,
              title: 'Mini-projets',
              subtitle: 'Du plus simple au plus complet',
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < miniProjects.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProjectCard(project: miniProjects[i], number: i + 1),
              ),
          ],
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final MiniProject project;
  final int? number;
  final bool featured;

  const _ProjectCard({required this.project, this.number, this.featured = false});

  @override
  Widget build(BuildContext context) {
    final done = ProgressService.instance.isProjectComplete(project.id);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: project)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: (featured ? scheme.primary : scheme.tertiary).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(project.icon, color: featured ? scheme.primary : scheme.tertiary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      number != null ? 'Projet $number · ${project.title}' : project.title,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(project.intro,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    Text(
                      '${project.totalTasks} étapes',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: featured ? scheme.primary : scheme.tertiary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (done)
                Icon(Icons.check_circle, color: Colors.green.readable(context, ratio: 3))
              else
                const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
