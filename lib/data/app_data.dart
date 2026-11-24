import 'package:flutter/material.dart';

import '../models/content_block.dart';
import '../models/course.dart';
import '../models/exercise.dart';
import '../models/project.dart';
import '../models/snippet.dart';
import 'courses_ajax.dart';
import 'courses_base.dart';
import 'courses_jquery.dart';
import 'exercises_data.dart';
import 'explain_data.dart';
import 'glossary_data.dart';
import 'projects_data.dart';
import 'snippets_data.dart';

/// Point d'accès unique aux données pédagogiques de l'application.
class AppData {
  AppData._();

  static final List<CourseModule> modules = [
    ...baseModules(),
    ...jqueryModules(),
    ...ajaxModules(),
  ];

  static final List<CourseSection> allSections =
      modules.expand((m) => m.sections).toList();

  static final List<Exercise> exercises = allExercises();

  static final List<MiniProject> projects = allProjects();

  static final List<Snippet> snippets = allSnippets();

  static final List<GlossaryEntry> glossary = allGlossary();

  static final List<ExplainableCode> explainableCodes = allExplainableCodes();

  // ----- Recherche -----

  static CourseModule? moduleById(String id) {
    for (final m in modules) {
      if (m.id == id) return m;
    }
    return null;
  }

  static CourseSection? sectionById(String id) {
    for (final s in allSections) {
      if (s.id == id) return s;
    }
    return null;
  }

  static CourseModule? moduleOfSection(String sectionId) {
    final s = sectionById(sectionId);
    return s == null ? null : moduleById(s.moduleId);
  }

  static Exercise? exerciseById(String id) {
    for (final e in exercises) {
      if (e.id == id) return e;
    }
    return null;
  }

  static MiniProject? projectById(String id) {
    for (final p in projects) {
      if (p.id == id) return p;
    }
    return null;
  }

  static Snippet? snippetById(String id) {
    for (final s in snippets) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Nombre total de leçons.
  static int get totalSections => allSections.length;

  /// Nombre total d'exercices.
  static int get totalExercises => exercises.length;

  /// Nombre total de projets.
  static int get totalProjects => projects.length;

  /// Résultat de recherche global.
  static List<SearchResult> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];

    final results = <SearchResult>[];

    for (final m in modules) {
      if (_match(m.title, q) || _match(m.subtitle, q)) {
        results.add(SearchResult.course(m));
      }
      for (final s in m.sections) {
        if (_match(s.title, q)) {
          results.add(SearchResult.section(s));
        }
        for (final b in s.blocks) {
          if (b is CodeBlock && _match(b.code, q)) {
            results.add(SearchResult.section(s));
            break;
          }
        }
      }
    }

    for (final e in exercises) {
      if (_match(e.title, q) ||
          _match(e.objective, q) ||
          _match(e.instructions, q) ||
          _match(e.solution, q)) {
        results.add(SearchResult.exercise(e));
      }
    }

    for (final p in projects) {
      if (_match(p.title, q) || _match(p.intro, q)) {
        results.add(SearchResult.project(p));
      }
    }

    for (final s in snippets) {
      if (_match(s.name, q) ||
          _match(s.description, q) ||
          _match(s.example, q)) {
        results.add(SearchResult.snippet(s));
      }
    }

    for (final g in glossary) {
      if (_match(g.term, q) || _match(g.definition, q)) {
        results.add(SearchResult.glossary(g));
      }
    }

    return results;
  }

  static bool _match(String haystack, String needle) =>
      haystack.toLowerCase().contains(needle);
}

/// Un résultat de recherche, avec un type pour la navigation.
class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final SearchResultType type;
  final Color color;

  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.type,
    required this.color,
  });

  SearchResult.course(CourseModule m)
      : id = 'course:${m.id}',
        title = m.title,
        subtitle = m.subtitle,
        icon = m.icon,
        type = SearchResultType.course,
        color = Colors.indigo;

  SearchResult.section(CourseSection s)
      : id = 'section:${s.id}',
        title = s.title,
        subtitle = 'Leçon',
        icon = Icons.menu_book,
        type = SearchResultType.section,
        color = Colors.teal;

  SearchResult.exercise(Exercise e)
      : id = 'exercise:${e.id}',
        title = e.title,
        subtitle = 'Exercice · ${e.category}',
        icon = Icons.fitness_center,
        type = SearchResultType.exercise,
        color = Colors.deepOrange;

  SearchResult.project(MiniProject p)
      : id = 'project:${p.id}',
        title = p.title,
        subtitle = 'Projet · ${p.category}',
        icon = Icons.construction,
        type = SearchResultType.project,
        color = Colors.purple;

  SearchResult.snippet(Snippet s)
      : id = 'snippet:${s.id}',
        title = s.name,
        subtitle = s.category,
        icon = s.icon,
        type = SearchResultType.snippet,
        color = Colors.blueGrey;

  SearchResult.glossary(GlossaryEntry g)
      : id = 'glossary:${g.term}',
        title = g.term,
        subtitle = 'Glossaire',
        icon = Icons.book,
        type = SearchResultType.glossary,
        color = Colors.green;
}

enum SearchResultType { course, section, exercise, project, snippet, glossary }
