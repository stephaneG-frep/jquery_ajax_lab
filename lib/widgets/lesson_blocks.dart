import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/content_block.dart';
import 'code_view.dart';
import 'inline_text.dart';

/// Rend une liste de blocs de contenu pédagogique.
class LessonBlocks extends StatelessWidget {
  final List<ContentBlock> blocks;
  final void Function(String exerciseId)? onExerciseTap;
  final void Function(CodeBlock block)? onExplainTap;

  const LessonBlocks({
    super.key,
    required this.blocks,
    this.onExerciseTap,
    this.onExplainTap,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      children.add(Padding(
        padding: EdgeInsets.only(bottom: i == blocks.length - 1 ? 0 : 16),
        child: _BlockWidget(
          block: block,
          onExerciseTap: onExerciseTap,
          onExplainTap: onExplainTap,
        ),
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }
}

class _BlockWidget extends StatelessWidget {
  final ContentBlock block;
  final void Function(String exerciseId)? onExerciseTap;
  final void Function(CodeBlock block)? onExplainTap;

  const _BlockWidget({
    required this.block,
    this.onExerciseTap,
    this.onExplainTap,
  });

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      ParagraphBlock(:final text) => InlineText(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55),
        ),
      HeadingBlock(:final text) => Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      CodeBlock block => _CodeCard(block: block, onExplainTap: onExplainTap),
      TipBlock(:final text) => _Box(
          icon: Icons.lightbulb_outline,
          color: LabColors.terminal,
          title: 'Astuce',
          text: text,
        ),
      WarningBlock(:final text) => _Box(
          icon: Icons.warning_amber_rounded,
          color: LabColors.amber,
          title: 'Attention',
          text: text,
        ),
      InfoBlock(:final text) => _Box(
          icon: Icons.info_outline,
          color: LabColors.sky,
          title: 'À savoir',
          text: text,
        ),
      TableBlock(:final headers, :final rows) => _DataTable(headers: headers, rows: rows),
      ComparisonBlock(:final title, :final jquery, :final modern, :final note) => _ComparisonCard(
          title: title,
          jquery: jquery,
          modern: modern,
          note: note,
        ),
      StepsBlock(:final steps, :final title) => _StepsCard(steps: steps, title: title),
      BulletsBlock(:final items) => _Bullets(items: items, numbered: false),
      NumbersBlock(:final items) => _Bullets(items: items, numbered: true),
      ExerciseLinkBlock(:final exerciseId) => _ExerciseCta(
          exerciseId: exerciseId,
          onTap: onExerciseTap,
        ),
      ConceptCardBlock(:final icon, :final title, :final text) => _ConceptCard(
          icon: icon,
          title: title,
          text: text,
        ),
    };
  }
}

class _CodeCard extends StatelessWidget {
  final CodeBlock block;
  final void Function(CodeBlock block)? onExplainTap;

  const _CodeCard({required this.block, this.onExplainTap});

  @override
  Widget build(BuildContext context) {
    final canExplain = block.lineByLine || block.explanation != null;
    final code = CodeView(code: block.code, language: block.language);
    final children = <Widget>[code];
    if (canExplain) {
      children.add(const SizedBox(height: 8));
      children.add(Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => onExplainTap?.call(block),
          icon: const Icon(Icons.auto_awesome, size: 16),
          label: const Text('Explique-moi ce code'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ));
    }
    if (block.explanation != null) {
      children.add(const SizedBox(height: 10));
      children.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notes, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: InlineText(
              block.explanation!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
            ),
          ),
        ],
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }
}

class _Box extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String text;

  const _Box({required this.icon, required this.color, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 4),
                InlineText(text,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;

  const _DataTable({required this.headers, required this.rows});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Table(
          columnWidths: {
            for (var i = 0; i < headers.length; i++)
              i: FlexColumnWidth(i == 0 ? 1.4 : 1),
          },
          border: TableBorder(
            horizontalInside: BorderSide(color: isDark ? const Color(0xFF2D3040) : const Color(0xFFE5E8F0)),
            verticalInside: BorderSide(color: isDark ? const Color(0xFF2D3040) : const Color(0xFFE5E8F0)),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: scheme.primaryContainer),
              children: [
                for (final h in headers)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(h,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
              ],
            ),
            for (final row in rows)
              TableRow(
                children: [
                  for (final cell in row)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        cell,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5, height: 1.4),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String title;
  final String jquery;
  final String modern;
  final String? note;

  const _ComparisonCard({
    required this.title,
    required this.jquery,
    required this.modern,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            const _CompareTag(label: 'jQuery', color: LabColors.purple),
            const SizedBox(height: 6),
            CodeView(code: jquery, language: 'javascript'),
            const SizedBox(height: 12),
            const _CompareTag(label: 'JavaScript moderne', color: LabColors.sky),
            const SizedBox(height: 6),
            CodeView(code: modern, language: 'javascript'),
            if (note != null) ...[
              const SizedBox(height: 10),
              InlineText(note!, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompareTag extends StatelessWidget {
  final String label;
  final Color color;
  const _CompareTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _StepsCard extends StatelessWidget {
  final List<String> steps;
  final String? title;

  const _StepsCard({required this.steps, this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
          ],
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text('${i + 1}',
                        style: TextStyle(color: scheme.onPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: InlineText(steps[i], style: const TextStyle(height: 1.35)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  final bool numbered;

  const _Bullets({required this.items, required this.numbered});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: numbered
                      ? Text('${i + 1}. ',
                          style: const TextStyle(fontWeight: FontWeight.w700))
                      : const Icon(Icons.circle, size: 8),
                ),
                const SizedBox(width: 10),
                Expanded(child: InlineText(items[i], style: const TextStyle(height: 1.5))),
              ],
            ),
          ),
      ],
    );
  }
}

class _ExerciseCta extends StatelessWidget {
  final String exerciseId;
  final void Function(String exerciseId)? onTap;

  const _ExerciseCta({required this.exerciseId, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: LabColors.seed.withValues(alpha: 0.08),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: LabColors.seed),
        title: const Text('Exercice lié',
            style: TextStyle(fontWeight: FontWeight.w700)),
        subtitle: const Text('Mettez cette notion en pratique.'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => onTap?.call(exerciseId),
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _ConceptCard({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primaryContainer, scheme.primaryContainer.withValues(alpha: 0.5)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                const SizedBox(height: 4),
                InlineText(text, style: const TextStyle(height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
