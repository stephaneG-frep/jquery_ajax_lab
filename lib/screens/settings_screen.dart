import 'package:flutter/material.dart';

import '../app/theme.dart';

import '../core/constants.dart';
import '../services/favorites_service.dart';
import '../services/progress_service.dart';
import '../services/settings_service.dart';
import '../widgets/kit.dart';

/// Paramètres : thème, taille de texte, taille du code, réinitialisation.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListenableBuilder(
        listenable: AppSettings.instance,
        builder: (context, _) {
          final settings = AppSettings.instance;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _card(
                icon: Icons.palette_outlined,
                color: LabColors.seed,
                title: 'Thème',
                child: SegmentedButton<AppThemeMode>(
                  segments: const [
                    ButtonSegment(value: AppThemeMode.system, label: Text('Système'), icon: Icon(Icons.brightness_auto)),
                    ButtonSegment(value: AppThemeMode.light, label: Text('Clair'), icon: Icon(Icons.light_mode)),
                    ButtonSegment(value: AppThemeMode.dark, label: Text('Sombre'), icon: Icon(Icons.dark_mode)),
                  ],
                  selected: {settings.themeMode},
                  onSelectionChanged: (s) => settings.setThemeMode(s.first),
                ),
              ),
              const SizedBox(height: 12),
              _card(
                icon: Icons.format_size,
                color: LabColors.coral,
                title: 'Taille du texte',
                subtitle: '${(settings.textScale * 100).round()}%',
                child: Slider(
                  value: settings.textScale,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(settings.textScale * 100).round()}%',
                  onChanged: (v) => settings.setTextScale(v),
                ),
              ),
              const SizedBox(height: 12),
              _card(
                icon: Icons.code,
                color: LabColors.purple,
                title: 'Taille du code',
                subtitle: '${settings.codeFontSize.toStringAsFixed(0)} px',
                child: Slider(
                  value: settings.codeFontSize,
                  min: 10,
                  max: 20,
                  divisions: 10,
                  label: '${settings.codeFontSize.toStringAsFixed(0)} px',
                  onChanged: (v) => settings.setCodeFontSize(v),
                ),
              ),
              const SizedBox(height: 20),
              const SectionHeader(
                icon: Icons.delete_forever,
                title: 'Zone de danger',
                color: Colors.red,
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.withValues(alpha: 0.14),
                    child: const Icon(Icons.restart_alt, color: Colors.red, size: 18),
                  ),
                  title: const Text('Réinitialiser toute la progression',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  subtitle: const Text('Leçons, exercices, projets et favoris.',
                      style: TextStyle(fontSize: 12)),
                  onTap: () => _confirmReset(context),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      '${AppInfo.name} · v${AppInfo.version}',
                      style: TextStyle(
                          fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Apprendre le Web, jQuery et AJAX pas à pas.',
                      style: TextStyle(
                          fontSize: 11.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required Color color,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                ),
                if (subtitle != null)
                  Text(subtitle, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tout réinitialiser ?'),
        content: const Text(
            'Cette action effacera définitivement votre progression '
            '(leçons terminées, exercices réussis, projets achevés) '
            'ainsi que vos favoris.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ProgressService.instance.reset();
      await FavoritesService.instance.reset();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progression réinitialisée.')),
        );
      }
    }
  }
}
