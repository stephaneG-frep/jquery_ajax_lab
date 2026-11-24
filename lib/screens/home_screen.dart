import 'package:flutter/material.dart';

import '../app/theme.dart';

import '../core/constants.dart';
import '../data/app_data.dart';
import '../models/course.dart';
import '../services/favorites_service.dart';
import '../services/progress_service.dart';
import '../widgets/kit.dart';
import 'ajax_explorer_screen.dart';
import 'help_screen.dart';
import 'progress_screen.dart';
import 'search_screen.dart';
import 'section_screen.dart';
import 'settings_screen.dart';

/// Écran d'accueil : tableau de bord de progression et accès rapides.
class HomeScreen extends StatelessWidget {
  final void Function(int tab) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: Listenable.merge([
          ProgressService.instance,
          FavoritesService.instance,
        ]),
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _WelcomeHeader(onNavigate: onNavigate),
              const SizedBox(height: 16),
              _ProgressCard(onNavigate: onNavigate),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.fitness_center,
                      value: '${ProgressService.instance.passedExercises.length}',
                      label: 'Exercices réussis',
                      color: LabColors.coral,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.construction,
                      value: '${ProgressService.instance.completedProjects.length}',
                      label: 'Projets terminés',
                      color: LabColors.purple,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.star,
                      value: '${FavoritesService.instance.favorites.length}',
                      label: 'Favoris',
                      color: LabColors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _QuickAccess(onNavigate: onNavigate),
              const SizedBox(height: 20),
              const SectionHeader(
                icon: Icons.more_horiz,
                title: 'Découvrir',
              ),
              const SizedBox(height: 12),
              _ShortcutTile(
                icon: Icons.show_chart,
                color: LabColors.seed,
                title: 'Progression',
                subtitle: 'Votre avancement par catégorie',
                onTap: () => _push(context, const ProgressScreen()),
              ),
              _ShortcutTile(
                icon: Icons.help_outline,
                color: LabColors.sky,
                title: 'Mode d\'emploi',
                subtitle: 'Tout comprendre de l\'application',
                onTap: () => _push(context, const HelpScreen()),
              ),
              _ShortcutTile(
                icon: Icons.settings_outlined,
                color: LabColors.terminal,
                title: 'Paramètres',
                subtitle: 'Thème, taille du texte, réinitialisation',
                onTap: () => _push(context, const SettingsScreen()),
              ),
              _ShortcutTile(
                icon: Icons.search,
                color: LabColors.coral,
                title: 'Recherche globale',
                subtitle: 'Retrouvez n\'importe quel contenu',
                onTap: () => _push(context, const SearchScreen()),
              ),
              const SizedBox(height: 16),
              _QuoteCard(),
            ],
          );
        },
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _WelcomeHeader extends StatelessWidget {
  final void Function(int tab) onNavigate;
  const _WelcomeHeader({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withValues(alpha: 0.75)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.code, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'jQuery AJAX Lab',
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'De zéro à expert du Web',
                      style: TextStyle(color: Colors.white70, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.language, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _sentence,
            style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.4),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeaderChip(label: 'Cours', onTap: () => onNavigate(Tabs.courses)),
              _HeaderChip(label: 'Lab', onTap: () => onNavigate(Tabs.lab)),
              _HeaderChip(label: 'Projets', onTap: () => onNavigate(Tabs.projects)),
            ],
          ),
        ],
      ),
    );
  }

  String get _sentence {
    final done = ProgressService.instance.completedSections.length;
    if (done == 0) {
      return 'Bienvenue ! Commencez par le Module 1 pour comprendre le Web, ou ouvrez le Lab pour expérimenter tout de suite.';
    }
    return 'Vous avez terminé $done leçons. Continuez sur votre lancée !';
  }
}

class _HeaderChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _HeaderChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final void Function(int tab) onNavigate;
  const _ProgressCard({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final total = AppData.totalSections;
    final done = ProgressService.instance.completedSections.length;
    final ratio = total == 0 ? 0.0 : done / total;

    final lastId = ProgressService.instance.currentSectionId;
    final lastSection = lastId != null ? AppData.sectionById(lastId) : null;
    final module = lastSection != null ? AppData.moduleOfSection(lastSection.id) : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Progression globale',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
                Text('${(ratio * 100).round()}%',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            LabProgress(value: ratio),
            const SizedBox(height: 12),
            if (lastSection != null)
              Row(
                children: [
                  const Icon(Icons.bookmark_outline, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Dernier chapitre : ${lastSection.title}'
                      '${module != null ? ' · ${module.title}' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                ],
              )
            else
              const Text(
                'Commencez votre premier chapitre pour le retrouver ici.',
                style: TextStyle(fontSize: 12.5),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      final resume = _resumeSection();
                      if (resume != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SectionScreen(section: resume)),
                        );
                      } else {
                        onNavigate(Tabs.courses);
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Continuer'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onNavigate(Tabs.courses),
                    icon: const Icon(Icons.school_outlined, size: 18),
                    label: const Text('Cours'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CourseSection? _resumeSection() {
    final lastId = ProgressService.instance.currentSectionId;
    if (lastId != null) {
      final s = AppData.sectionById(lastId);
      if (s != null) return s;
    }
    for (final s in AppData.allSections) {
      if (!ProgressService.instance.isSectionComplete(s.id)) return s;
    }
    return null;
  }
}

class _QuickAccess extends StatelessWidget {
  final void Function(int tab) onNavigate;
  const _QuickAccess({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickCard(
                icon: Icons.science,
                color: LabColors.terminal,
                title: 'Laboratoire',
                subtitle: 'Éditez et exécutez du code',
                onTap: () => onNavigate(Tabs.lab),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickCard(
                icon: Icons.travel_explore,
                color: LabColors.purple,
                title: 'Explorateur AJAX',
                subtitle: 'Mini-Postman pour tester les API',
                onTap: () => _push(context, const AjaxExplorerScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
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
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShortcutTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final day = DateTime.now().difference(DateTime(2026)).inDays;
    final quote = Quotes.all[day % Quotes.all.length];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LabColors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LabColors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: LabColors.amber),
          const SizedBox(height: 6),
          Text(quote,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, height: 1.4)),
          const SizedBox(height: 8),
          const Text('Astuce du jour',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: LabColors.amber)),
        ],
      ),
    );
  }
}
