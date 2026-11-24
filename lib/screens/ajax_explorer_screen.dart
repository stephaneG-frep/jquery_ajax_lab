import 'dart:convert';

import 'package:flutter/material.dart';

import '../app/readable_color.dart';
import '../app/theme.dart';
import '../services/http_service.dart';
import '../widgets/code_field.dart';
import '../widgets/code_view.dart';

const Map<int, String> _statusText = {
  200: 'OK',
  201: 'Créé',
  204: 'Sans contenu',
  400: 'Requête invalide',
  401: 'Non authentifié',
  403: 'Interdit',
  404: 'Introuvable',
  409: 'Conflit',
  429: 'Trop de requêtes',
  500: 'Erreur serveur',
  502: 'Passerelle invalide',
  503: 'Service indisponible',
};

/// Explorateur AJAX : un mini-Postman pédagogique.
class AjaxExplorerScreen extends StatefulWidget {
  const AjaxExplorerScreen({super.key});

  @override
  State<AjaxExplorerScreen> createState() => _AjaxExplorerScreenState();
}

class _AjaxExplorerScreenState extends State<AjaxExplorerScreen> {
  final HttpService _http = HttpService();
  final TextEditingController _url = TextEditingController();
  final TextEditingController _headers = TextEditingController();
  final TextEditingController _body = TextEditingController();

  String _method = 'GET';
  bool _loading = false;
  HttpResult? _result;
  HttpFailure? _failure;

  @override
  void dispose() {
    _url.dispose();
    _headers.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _result = null;
      _failure = null;
    });

    Map<String, String> headers = {};
    if (_headers.text.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(_headers.text);
        headers = Map<String, String>.from(decoded as Map);
      } catch (_) {
        setState(() {
          _loading = false;
          _failure = const HttpFailure(
            title: 'En-têtes invalides',
            message: 'Les en-têtes doivent être au format JSON : {"Content-Type": "application/json"}',
          );
        });
        return;
      }
    }

    final response = await _http.send(
      method: _method,
      url: _url.text,
      headers: headers,
      body: _body.text,
    );

    if (!mounted) return;
    setState(() {
      _loading = false;
      _result = response.result;
      _failure = response.failure;
    });
  }

  void _useSample(String url, String method, String body) {
    setState(() {
      _url.text = url;
      _method = method;
      _body.text = body;
      _headers.text = body.isEmpty
          ? '{\n  "Accept": "application/json"\n}'
          : '{\n  "Accept": "application/json",\n  "Content-Type": "application/json"\n}';
      _result = null;
      _failure = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorateur AJAX')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Un mini-Postman pour tester vos requêtes HTTP réelles.',
            style: TextStyle(height: 1.4),
          ),
          const SizedBox(height: 14),

          // Méthode
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HttpService.methods.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final m = HttpService.methods[i];
                final selected = _method == m;
                return ChoiceChip(
                  label: Text(m),
                  selected: selected,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: _methodColor(m).readable(context),
                    fontSize: 12.5,
                  ),
                  selectedColor: _methodColor(m).withValues(alpha: 0.2),
                  onSelected: (_) => setState(() => _method = m),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // URL
          TextField(
            controller: _url,
            keyboardType: TextInputType.url,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'URL',
              hintText: 'https://jsonplaceholder.typicode.com/users',
              prefixIcon: Icon(Icons.link),
            ),
          ),
          const SizedBox(height: 12),

          // Headers
          CodeField(
            controller: _headers,
            maxLines: 3,
            minLines: 2,
            decoration: const InputDecoration(
              labelText: 'En-têtes / headers (JSON)',
              hintText: '{"Content-Type": "application/json"}',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),

          // Body
          CodeField(
            controller: _body,
            maxLines: 4,
            minLines: 2,
            decoration: const InputDecoration(
              labelText: 'Corps / body (JSON)',
              hintText: '{"title": "Mon post"}',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),

          // Envoyer
          FilledButton.icon(
            onPressed: _loading ? null : _send,
            icon: _loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send),
            label: Text(_loading ? 'Envoi en cours…' : 'ENVOYER'),
            style: FilledButton.styleFrom(
              backgroundColor: LabColors.terminal,
              foregroundColor: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Exemples rapides
          const Text('Exemples rapides',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text('GET users'),
                onPressed: () => _useSample(
                    'https://jsonplaceholder.typicode.com/users', 'GET', ''),
              ),
              ActionChip(
                label: const Text('GET post 1'),
                onPressed: () => _useSample(
                    'https://jsonplaceholder.typicode.com/posts/1', 'GET', ''),
              ),
              ActionChip(
                label: const Text('POST'),
                onPressed: () => _useSample(
                    'https://jsonplaceholder.typicode.com/posts',
                    'POST',
                    '{\n  "title": "Mon post",\n  "body": "Contenu"\n}'),
              ),
              ActionChip(
                label: const Text('PATCH'),
                onPressed: () => _useSample(
                    'https://jsonplaceholder.typicode.com/posts/1',
                    'PATCH',
                    '{\n  "title": "Titre modifié"\n}'),
              ),
              ActionChip(
                label: const Text('DELETE'),
                onPressed: () => _useSample(
                    'https://jsonplaceholder.typicode.com/posts/1', 'DELETE', ''),
              ),
              ActionChip(
                label: const Text('URL invalide'),
                onPressed: () => _useSample('une url sans schéma', 'GET', ''),
              ),
              ActionChip(
                label: const Text('404'),
                onPressed: () => _useSample(
                    'https://jsonplaceholder.typicode.com/users/9999', 'GET', ''),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (_failure != null) ...[
            _ErrorCard(failure: _failure!),
            const SizedBox(height: 12),
          ],

          if (_result != null) ...[
            _ResultPanel(result: _result!),
          ],
        ],
      ),
    );
  }

  Color _methodColor(String m) => switch (m) {
        'GET' => LabColors.sky,
        'POST' => LabColors.terminal,
        'PUT' => LabColors.amber,
        'PATCH' => LabColors.purple,
        'DELETE' => LabColors.coral,
        _ => LabColors.seed,
      };
}

class _ErrorCard extends StatelessWidget {
  final HttpFailure failure;
  const _ErrorCard({required this.failure});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: Colors.red.readable(context, ratio: 3)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(failure.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.red.readable(context))),
                const SizedBox(height: 4),
                Text(failure.message, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  final HttpResult result;
  const _ResultPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    final statusColor = result.isSuccess ? Colors.green : Colors.red;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Statut : ${result.statusCode} '
                '${_statusText[result.statusCode] ?? ''}',
                style: TextStyle(color: statusColor.readable(context), fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${result.elapsed.inMilliseconds} ms',
                style: const TextStyle(fontSize: 12.5),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text('En-têtes', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E2130)
                : const Color(0xFFF6F8FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final e in result.responseHeaders.entries.take(12))
                Chip(
                  label: Text('${e.key}: ${e.value}',
                      style: const TextStyle(fontSize: 10.5, fontFamily: 'monospace')),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text('Corps', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        CodeView(code: result.prettyBody, language: 'json'),
      ],
    );
  }
}
