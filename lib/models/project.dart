/// Mini-projets guidés : étapes, indices, solutions et code final.
library;
import 'package:flutter/widgets.dart';

class ProjectTask {
  final String title;
  final String instruction;
  final String? hint;
  final String solution;

  const ProjectTask({
    required this.title,
    required this.instruction,
    this.hint,
    required this.solution,
  });
}

class MiniProject {
  final String id;
  final String title;
  final String category;
  final IconData icon;
  final String intro;
  final List<String> objectives;
  final List<ProjectTask> tasks;
  final String starterCode;
  final String finalCode;
  final bool isFinalProject;

  const MiniProject({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.intro,
    required this.objectives,
    required this.tasks,
    required this.starterCode,
    required this.finalCode,
    this.isFinalProject = false,
  });

  int get totalTasks => tasks.length;
}
