import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../app/theme.dart';
import '../data/app_data.dart';
import '../screens/quiz_screen.dart';
import '../services/progress_service.dart';

/// Accès au quiz d'un module, avec le meilleur score.
class QuizCard extends StatelessWidget {
  final String moduleId;

  const QuizCard({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    final quiz = AppData.quizOf(moduleId);
    if (quiz == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: ProgressService.instance,
      builder: (context, _) {
        final best = ProgressService.instance.bestQuizScore(moduleId);
        final total = quiz.questions.length;
        return Card(
          color: LabColors.seed.withValues(alpha: 0.08),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            leading: Icon(Icons.quiz_outlined, color: LabColors.seed.readable(context, ratio: 3)),
            title: const Text('Quiz du module', style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(best == null ? '$total questions' : 'Meilleur score : $best / $total'),
            trailing: AppData.isQuizPassed(moduleId)
                ? Icon(Icons.check_circle, color: Colors.green.readable(context, ratio: 3))
                : const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => QuizScreen(quiz: quiz)),
            ),
          ),
        );
      },
    );
  }
}
