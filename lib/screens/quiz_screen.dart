import 'dart:math';

import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../data/app_data.dart';
import '../models/quiz.dart';
import '../services/progress_service.dart';
import '../widgets/code_view.dart';
import '../widgets/kit.dart';

/// Quiz de fin de module : une question à la fois, puis le score.
class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  /// Source de hasard pour l'ordre des réponses (fixée dans les tests).
  final Random? random;

  const QuizScreen({super.key, required this.quiz, this.random});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final Random _random = widget.random ?? Random();
  late List<int> _order;
  final ScrollController _scroll = ScrollController();

  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _finished = false;

  List<QuizQuestion> get _questions => widget.quiz.questions;
  QuizQuestion get _question => _questions[_index];

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _shuffle() {
    _order = List.generate(_question.choices.length, (i) => i)..shuffle(_random);
  }

  void _answer(int choice) {
    if (_selected != null) return;
    setState(() {
      _selected = choice;
      if (choice == _question.correctIndex) _score++;
    });
    // L'explication apparaît sous les réponses : on la rend visible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _shuffle();
      });
      if (_scroll.hasClients) _scroll.jumpTo(0);
    } else {
      ProgressService.instance.recordQuizScore(widget.quiz.moduleId, _score);
      setState(() => _finished = true);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _score = 0;
      _selected = null;
      _finished = false;
      _shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final module = AppData.moduleById(widget.quiz.moduleId);
    return Scaffold(
      appBar: AppBar(title: Text('Quiz · ${module?.title ?? ''}')),
      body: SafeArea(top: false, child: _finished ? _result() : _questionView()),
    );
  }

  Widget _questionView() {
    final selected = _selected;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question ${_index + 1} sur ${_questions.length}',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              LabProgress(value: (_index + (selected == null ? 0 : 1)) / _questions.length),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.all(16),
            children: [
              Text(_question.question,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, height: 1.3)),
              if (_question.code != null) ...[
                const SizedBox(height: 12),
                CodeView(code: _question.code!, compact: true),
              ],
              const SizedBox(height: 16),
              for (final choice in _order) _choice(choice),
              if (selected != null) _explanation(selected == _question.correctIndex),
            ],
          ),
        ),
        if (selected != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _next,
                child: Text(
                    _index < _questions.length - 1 ? 'Question suivante' : 'Voir mon score'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _choice(int choice) {
    final answered = _selected != null;
    final isCorrect = choice == _question.correctIndex;
    final isSelected = choice == _selected;
    final Color? mark = !answered
        ? null
        : isCorrect
            ? Colors.green.readable(context, ratio: 3)
            : isSelected
                ? Colors.red.readable(context, ratio: 3)
                : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: mark ?? Theme.of(context).colorScheme.outlineVariant,
            width: mark == null ? 1 : 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: answered ? null : () => _answer(choice),
          title: Text(
            _question.choices[choice],
            style: TextStyle(fontSize: 14.5, color: Theme.of(context).colorScheme.onSurface),
          ),
          trailing: mark == null
              ? null
              : Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: mark,
                  semanticLabel: isCorrect ? 'Bonne réponse' : 'Mauvaise réponse',
                ),
        ),
      ),
    );
  }

  Widget _explanation(bool correct) {
    final color = correct ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(correct ? 'Exact !' : 'Pas tout à fait.',
              style: TextStyle(fontWeight: FontWeight.w800, color: color.readable(context))),
          const SizedBox(height: 4),
          Text(_question.explanation, style: const TextStyle(height: 1.45)),
        ],
      ),
    );
  }

  Widget _result() {
    final passed = _score >= widget.quiz.passMark;
    final color = (passed ? Colors.green : Colors.orange).readable(context);
    final best = ProgressService.instance.bestQuizScore(widget.quiz.moduleId) ?? _score;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 24),
        Icon(passed ? Icons.emoji_events : Icons.school, size: 64, color: color),
        const SizedBox(height: 16),
        Text('$_score / ${_questions.length}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 8),
        Text(
          passed
              ? 'Quiz réussi, bravo !'
              : 'Il faut ${widget.quiz.passMark} bonnes réponses. Relisez les leçons, puis réessayez.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, height: 1.4),
        ),
        const SizedBox(height: 6),
        Text('Meilleur score : $best / ${_questions.length}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Terminer'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _restart,
          icon: const Icon(Icons.replay, size: 18),
          label: const Text('Recommencer'),
        ),
      ],
    );
  }
}
