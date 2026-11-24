import 'package:flutter/material.dart';

import '../services/settings_service.dart';

/// Champ de saisie de code : police à chasse fixe, taille réglable, et aucune
/// aide à la frappe (une majuscule ou un guillemet « corrigé » casse le code).
class CodeField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final Color? color;
  final int? minLines;
  final int? maxLines;

  /// Occupe toute la hauteur disponible.
  final bool expands;

  const CodeField({
    super.key,
    required this.controller,
    required this.decoration,
    this.focusNode,
    this.color,
    this.minLines,
    this.maxLines,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) => TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: decoration,
        minLines: minLines,
        maxLines: maxLines,
        expands: expands,
        textAlignVertical: expands ? TextAlignVertical.top : null,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: TextCapitalization.none,
        smartQuotesType: SmartQuotesType.disabled,
        smartDashesType: SmartDashesType.disabled,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: AppSettings.instance.codeFontSize,
          color: color,
        ),
      ),
    );
  }
}
