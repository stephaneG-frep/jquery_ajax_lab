import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../widgets/favorite_button.dart';
import '../models/exercise.dart';
import '../services/favorites_service.dart';
import '../services/progress_service.dart';
import '../widgets/code_field.dart';
import '../widgets/code_view.dart';
import 'lab_screen.dart';

/// Écran d'un exercice : énoncé, indices progressifs, solution et validation.
class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  final TextEditingController _answer = TextEditingController();
  int _hintsShown = 0;
  int? _selectedChoice;
  bool _showSolution = false;
  bool? _lastValid;
  String? _lastFeedback;

  Exercise get ex => widget.exercise;

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  void _validate() {
    if (ex.type == ExerciseType.choice) {
      if (_selectedChoice == null) {
        _showFeedback(false, 'Sélectionnez d\'abord une réponse.');
        return;
      }
      final r = ex.validateChoice(_selectedChoice!);
      _showFeedback(r.valid, r.feedback);
      if (r.valid) {
        ProgressService.instance.markExercisePassed(ex.id);
      }
    } else {
      if (_answer.text.trim().isEmpty) {
        _showFeedback(false, 'Écrivez votre réponse dans la zone de code avant de valider.');
        return;
      }
      final r = ex.validate(_answer.text);
      _showFeedback(r.valid, r.feedback);
      if (r.valid) {
        ProgressService.instance.markExercisePassed(ex.id);
      }
    }
  }

  void _showFeedback(bool valid, String? feedback) {
    setState(() {
      _lastValid = valid;
      _lastFeedback = feedback;
    });
    if (valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✓ Correct ! Exercice réussi.',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green.shade800,
        ),
      );
    }
  }

  void _openInLab(String js) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LabPage(
          initialHtml: '<button id="btn">Tester</button>\n<p id="message"></p>',
          initialJs: js,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDone = ProgressService.instance.isExercisePassed(ex.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercice'),
        actions: [
          FavoriteButton(kind: FavoriteKind.exercise, id: ex.id),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([ProgressService.instance, FavoritesService.instance]),
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _LevelBadge(level: ex.level),
                  Chip(
                    avatar: const Icon(Icons.category_outlined, size: 16),
                    label: Text(ex.category),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (isDone)
                    Icon(Icons.check_circle, color: Colors.green.readable(context, ratio: 3)),
                ],
              ),
              const SizedBox(height: 14),
              Text(ex.objective,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, height: 1.3)),
              const SizedBox(height: 12),
              Text(ex.instructions, style: const TextStyle(height: 1.5)),
              const SizedBox(height: 20),

              if (ex.type == ExerciseType.choice) ...[
                const _StepLabel('1 · Choisissez la bonne réponse'),
                const SizedBox(height: 8),
                RadioGroup<int>(
                  groupValue: _selectedChoice,
                  onChanged: (v) => setState(() {
                    _selectedChoice = v;
                    _lastValid = null;
                    _lastFeedback = null;
                  }),
                  child: Column(
                    children: [
                      for (var i = 0; i < (ex.choices?.length ?? 0); i++)
                        Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: RadioListTile<int>(
                            value: i,
                            title: Text(
                              ex.choices![i],
                              style:
                                  const TextStyle(fontFamily: 'monospace', fontSize: 13),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                    ],
                  ),
                ),
              ] else ...[
                const _StepLabel('1 · Écrivez votre réponse'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1E2130)
                        : const Color(0xFFF6F8FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: CodeField(
                    controller: _answer,
                    maxLines: 8,
                    minLines: 4,
                    decoration: const InputDecoration(
                      hintText: '// écrivez votre code ici',
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Indices progressifs
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_hintsShown == 0)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _hintsShown = 1),
                      icon: const Icon(Icons.lightbulb_outline, size: 18),
                      label: const Text('Indice 1'),
                    ),
                  if (_hintsShown >= 1)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _hintsShown = 2),
                      icon: const Icon(Icons.lightbulb, size: 18),
                      label: const Text('Indice 2'),
                    ),
                  if (_hintsShown >= 2)
                    TextButton(
                      onPressed: () => setState(() => _showSolution = true),
                      child: const Text('Voir la solution'),
                    ),
                ],
              ),
              if (_hintsShown >= 1)
                _HintBox(index: 1, text: ex.hints.isNotEmpty ? ex.hints[0] : ''),
              if (_hintsShown >= 2 && ex.hints.length > 1)
                _HintBox(index: 2, text: ex.hints[1]),
              if (_showSolution)
                _SolutionBox(
                  exercise: ex,
                  onOpenLab: () => _openInLab(ex.solution),
                ),

              const SizedBox(height: 8),

              // Feedback
              if (_lastValid != null)
                _FeedbackBox(valid: _lastValid!, feedback: _lastFeedback ?? ''),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: _validate,
                icon: const Icon(Icons.task_alt),
                label: const Text('Valider ma réponse'),
              ),
              const SizedBox(height: 8),
              if (ex.type == ExerciseType.code)
                OutlinedButton.icon(
                  onPressed: () => _openInLab(_answer.text),
                  icon: const Icon(Icons.science_outlined, size: 18),
                  label: const Text('Tester dans le Lab'),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String text;
  const _StepLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary));
  }
}

class _LevelBadge extends StatelessWidget {
  final ExerciseLevel level;
  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      ExerciseLevel.guided => Colors.green,
      ExerciseLevel.semiGuided => Colors.orange,
      ExerciseLevel.autonomous => Colors.deepPurple,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(level.label,
          style: TextStyle(
              color: color.readable(context), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
    );
  }
}

class _HintBox extends StatelessWidget {
  final int index;
  final String text;
  const _HintBox({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: Colors.orange.readable(context, ratio: 3), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Indice $index : $text', style: const TextStyle(height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _SolutionBox extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onOpenLab;
  const _SolutionBox({required this.exercise, required this.onOpenLab});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Solution',
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.green.readable(context))),
          const SizedBox(height: 10),
          CodeView(code: exercise.solution, language: 'javascript', compact: true),
          const SizedBox(height: 10),
          Text(exercise.solutionExplanation, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 8),
          if (exercise.type == ExerciseType.code)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onOpenLab,
                icon: const Icon(Icons.science_outlined, size: 16),
                label: const Text('Tester la solution dans le Lab'),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeedbackBox extends StatelessWidget {
  final bool valid;
  final String feedback;
  const _FeedbackBox({required this.valid, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final color = valid ? Colors.green : Colors.red;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(valid ? Icons.check_circle : Icons.error_outline, color: color.readable(context, ratio: 3), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              valid ? '✓ Correct ! $feedback' : feedback,
              style: const TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
