import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../app/theme.dart';
import '../data/lab_examples.dart';
import '../services/lab_engine.dart';
import '../services/settings_service.dart';

/// Le laboratoire interactif : éditeur HTML/CSS/JS, exécution dans une
/// WebView sécurisée et console pédagogique.
class LabScreen extends StatefulWidget {
  final String? initialHtml;
  final String? initialCss;
  final String? initialJs;

  const LabScreen({super.key, this.initialHtml, this.initialCss, this.initialJs});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

/// Le laboratoire en page autonome, ouvert depuis un exercice ou un projet.
///
/// [LabScreen] n'a pas de Scaffold : il est conçu pour l'onglet Lab.
class LabPage extends StatelessWidget {
  final String? initialHtml;
  final String? initialCss;
  final String? initialJs;

  const LabPage({super.key, this.initialHtml, this.initialCss, this.initialJs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratoire')),
      body: SafeArea(
        top: false,
        child: LabScreen(
          initialHtml: initialHtml,
          initialCss: initialCss,
          initialJs: initialJs,
        ),
      ),
    );
  }
}

class _LabScreenState extends State<LabScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _htmlController;
  late final TextEditingController _cssController;
  late final TextEditingController _jsController;

  final List<String> _logs = [];
  bool _consoleVisible = true;
  bool _running = false;

  WebViewController? _webController;
  String? _jquerySource;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _htmlController = TextEditingController(text: widget.initialHtml ?? labPresets.first.html);
    _cssController = TextEditingController(text: widget.initialCss ?? labPresets.first.css);
    _jsController = TextEditingController(text: widget.initialJs ?? labPresets.first.js);
    _bootstrapWebview();
  }

  Future<void> _bootstrapWebview() async {
    if (WebViewPlatform.instance == null) {
      _addLog('Aperçu indisponible sur cette plateforme.');
      return;
    }
    _jquerySource = await LabEngine.jquerySource();
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFffffff))
      ..addJavaScriptChannel('AndroidBridge', onMessageReceived: (message) {
        _addLog(message.message);
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) => _addLog('⚠ Ressource : ${error.description}'),
        ),
      );
    _webController = controller;
    await _run(initial: true);
  }

  void _addLog(String text) {
    if (!mounted) return;
    setState(() {
      _logs.add(_clean(text));
    });
  }

  String _clean(String text) => text.replaceAll('\\n', '\n');

  Future<void> _run({bool initial = false}) async {
    final controller = _webController;
    if (controller == null) return;
    setState(() {
      _running = !initial;
    });
    try {
      final html = LabEngine.buildHtml(
        html: _htmlController.text,
        css: _cssController.text,
        js: _jsController.text,
        jquery: _jquerySource ?? '',
      );
      await controller.loadHtmlString(html);
      if (initial) {
        _addLog('Laboratoire prêt. Modifiez le code puis appuyez sur Exécuter.');
      } else {
        _addLog('▶ Code exécuté.');
      }
    } catch (e) {
      _addLog('Erreur lors de l\'exécution : $e');
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  void _applyPreset(LabPreset preset) {
    _htmlController.text = preset.html;
    _cssController.text = preset.css;
    _jsController.text = preset.js;
    _run();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _htmlController.dispose();
    _cssController.dispose();
    _jsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final editorHeight = (maxHeight * 0.34).clamp(150.0, 240.0);
        final consoleHeight = (maxHeight * 0.22).clamp(110.0, 190.0);
        final hasWeb = _webController != null;
        final webUnavailable = WebViewPlatform.instance == null;

        return Column(
          children: [
            _Toolbar(
              running: _running,
              onRun: _run,
              onPreset: _applyPreset,
            ),
            SizedBox(
              height: editorHeight,
              child: Column(
                children: [
                  Material(
                    color: isDark ? const Color(0xFF1A1B27) : Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      tabs: const [
                        Tab(text: 'HTML'),
                        Tab(text: 'CSS'),
                        Tab(text: 'JS / jQuery'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _codeField(_htmlController, language: 'html', key: const ValueKey('html')),
                        _codeField(_cssController, language: 'css', key: const ValueKey('css')),
                        _codeField(_jsController, language: 'javascript', key: const ValueKey('js')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              color: isDark ? const Color(0xFF1E2130) : const Color(0xFFE9EDF5),
              child: Row(
                children: [
                  const Icon(Icons.visibility_outlined, size: 14),
                  const SizedBox(width: 6),
                  const Text('Aperçu',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  if (_running) ...[
                    const SizedBox(
                        width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                    const SizedBox(width: 6),
                  ],
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Basculer la console',
                    icon: const Icon(Icons.terminal, size: 16),
                    onPressed: () => setState(() => _consoleVisible = !_consoleVisible),
                  ),
                ],
              ),
            ),
            Expanded(
              child: hasWeb
                  ? WebViewWidget(controller: _webController!)
                  : webUnavailable
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.visibility_off, size: 36),
                                const SizedBox(height: 10),
                                const Text(
                                  'Aperçu indisponible',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'La WebView n\'est pas disponible ici.\n'
                                  'Utilisez l\'application sur un appareil Android pour voir l\'aperçu.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
            ),
            if (_consoleVisible)
              SizedBox(
                height: consoleHeight,
                child: _Console(logs: _logs, onClear: () => setState(_logs.clear)),
              ),
          ],
        );
      },
    );
  }

  Widget _codeField(TextEditingController controller,
      {required String language, Key? key}) {
    return Container(
      key: key,
      color: Theme.of(context).brightness == Brightness.dark
          ? CodeDarkColors.background
          : CodeLightColors.background,
      child: ListenableBuilder(
        listenable: AppSettings.instance,
        builder: (context, _) => TextField(
          controller: controller,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: AppSettings.instance.codeFontSize,
            color: Theme.of(context).brightness == Brightness.dark
                ? CodeDarkColors.text
                : CodeLightColors.text,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(12),
            hintText: '// écrivez votre code…',
          ),
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final bool running;
  final VoidCallback onRun;
  final ValueChanged<LabPreset> onPreset;

  const _Toolbar({required this.running, required this.onRun, required this.onPreset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<LabPreset>(
              initialValue: labPresets.first,
              isExpanded: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                labelText: 'Exemples',
              ),
              items: [
                for (final p in labPresets)
                  DropdownMenuItem(value: p, child: Text(p.label, overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (p) {
                if (p != null) onPreset(p);
              },
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: running ? null : onRun,
            icon: running
                ? const SizedBox(
                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.play_arrow),
            label: const Text('Exécuter'),
            style: FilledButton.styleFrom(
              backgroundColor: LabColors.terminal,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _Console extends StatelessWidget {
  final List<String> logs;
  final VoidCallback onClear;

  const _Console({required this.logs, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1018) : const Color(0xFF1A1B22),
        border: Border(
          top: BorderSide(color: isDark ? const Color(0xFF2D3040) : const Color(0xFF000000)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFF2A2C36),
            child: Row(
              children: [
                const Icon(Icons.terminal, color: LabColors.terminal, size: 14),
                const SizedBox(width: 6),
                const Text('Console',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                const Spacer(),
                if (logs.isNotEmpty)
                  TextButton(
                    onPressed: onClear,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Effacer',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Console\n----------------\nLes messages console.log() et les erreurs s\'afficheront ici.',
                      style: TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'monospace'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: logs.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${i + 1} › ${logs[i]}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12, fontFamily: 'monospace', height: 1.4),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
