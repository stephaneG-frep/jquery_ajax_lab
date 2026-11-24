import 'package:flutter/widgets.dart';

import 'content_block.dart';

/// Un cours complet, découpé en modules puis en sections (leçons).
class CourseModule {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final int number;
  final List<CourseSection> sections;

  const CourseModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.number,
    required this.sections,
  });

  int get totalSections => sections.length;
}

/// Une leçon : un titre et une liste de blocs de contenu.
class CourseSection {
  final String id;
  final String moduleId;
  final String title;
  final int order;
  final List<ContentBlock> blocks;

  const CourseSection({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.order,
    required this.blocks,
  });
}
