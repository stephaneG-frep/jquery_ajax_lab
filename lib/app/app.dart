import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../services/settings_service.dart';
import 'shell_screen.dart';
import 'theme.dart';

/// Racine de l'application : thème, navigation et initialisation.
class JqueryAjaxLabApp extends StatelessWidget {
  const JqueryAjaxLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) {
        return MaterialApp(
          title: AppInfo.name,
          debugShowCheckedModeBanner: false,
          theme: LabTheme.light(),
          darkTheme: LabTheme.dark(),
          themeMode: AppSettings.instance.flutterThemeMode,
          builder: (context, child) {
            // Taille du texte : le réglage s'ajoute à celui du système.
            final media = MediaQuery.of(context);
            final scale = AppSettings.instance.textScale;
            return MediaQuery(
              data: scale == 1.0
                  ? media
                  : media.copyWith(
                      textScaler: TextScaler.linear(media.textScaler.scale(14) / 14 * scale),
                    ),
              child: child!,
            );
          },
          home: const AppShell(),
        );
      },
    );
  }
}
