import 'package:flutter/material.dart';

/// Rend une couleur d'accent lisible sur les fonds de l'application.
extension ReadableColor on Color {
  /// Variante assombrie (thème clair) ou éclaircie (thème sombre) jusqu'au
  /// contraste voulu, y compris sur un fond teinté de cette même couleur.
  /// 4,5 pour du texte, 3 pour une icône (WCAG AA).
  Color readable(BuildContext context, {double ratio = 4.5}) =>
      readableOn(Theme.of(context).brightness, ratio: ratio);

  Color readableOn(Brightness brightness, {double ratio = 4.5}) =>
      _cache.putIfAbsent((toARGB32(), brightness, ratio), () {
        final dark = brightness == Brightness.dark;
        final surface = dark ? const Color(0xFF1E2130) : const Color(0xFFF4F6FB);
        final background = Color.alphaBlend(withValues(alpha: 0.18), surface);
        final hsl = HSLColor.fromColor(this);
        var lightness = hsl.lightness;
        var color = this;
        while (contrast(color, background) < ratio && lightness > 0 && lightness < 1) {
          lightness = (lightness + (dark ? 0.01 : -0.01)).clamp(0.0, 1.0);
          color = hsl.withLightness(lightness).toColor();
        }
        return color;
      });

  static final Map<(int, Brightness, double), Color> _cache = {};

  /// Rapport de contraste WCAG entre deux couleurs opaques.
  static double contrast(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    return la > lb ? (la + 0.05) / (lb + 0.05) : (lb + 0.05) / (la + 0.05);
  }
}
