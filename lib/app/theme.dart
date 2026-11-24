import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Palette de couleurs du « laboratoire de développement ».
class LabColors {
  static const Color seed = Color(0xFF3D5AFE); // indigo « IDE »
  static const Color terminal = Color(0xFF00C853);
  static const Color terminalDark = Color(0xFF69F0AE);
  static const Color amber = Color(0xFFFFB300);
  static const Color coral = Color(0xFFFF6E40);
  static const Color purple = Color(0xFFB388FF);
  static const Color sky = Color(0xFF40C4FF);
}

/// Couleurs utilisées pour le rendu du code (thème clair).
class CodeLightColors {
  static const Color background = Color(0xFFF6F8FA);
  static const Color border = Color(0xFFE1E4E8);
  static const Color text = Color(0xFF24292E);
  static const Color keyword = Color(0xFFD73A49);
  static const Color string = Color(0xFF032F62);
  static const Color number = Color(0xFF005CC5);
  static const Color comment = Color(0xFF6A737D);
  static const Color function = Color(0xFF6F42C1);
  static const Color variable = Color(0xFF005CC5);
}

/// Couleurs utilisées pour le rendu du code (thème sombre).
class CodeDarkColors {
  static const Color background = Color(0xFF1E2130);
  static const Color border = Color(0xFF2D3040);
  static const Color text = Color(0xFFE1E4E8);
  static const Color keyword = Color(0xFFFF7B72);
  static const Color string = Color(0xFFA5D6FF);
  static const Color number = Color(0xFF79C0FF);
  static const Color comment = Color(0xFF8B949E);
  static const Color function = Color(0xFFD2A8FF);
  static const Color variable = Color(0xFF79C0FF);
}

class LabTheme {
  static ThemeData light() => _base(Brightness.light);

  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: LabColors.seed,
      brightness: brightness,
      surface: isDark ? const Color(0xFF15161F) : Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? const Color(0xFF15161F) : const Color(0xFFF4F6FB),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
        backgroundColor: isDark ? const Color(0xFF15161F) : const Color(0xFFF4F6FB),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: isDark ? const Color(0xFF1E2130) : Colors.white,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: isDark ? const Color(0xFF1A1B27) : Colors.white,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0xFF2D3040) : const Color(0xFFE5E8F0),
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E2130) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D3040) : const Color(0xFF24292E),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
