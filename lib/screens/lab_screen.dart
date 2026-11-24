import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../app/theme.dart';
import '../data/lab_examples.dart';
import '../services/lab_draft_service.dart';
import '../services/lab_engine.dart';
import '../widgets/code_field.dart';

/// Le laboratoire interactif : éditeur HTML/CSS/JS, exécution dans une
/// WebView sécurisée et console pédagogique.
class LabScreen extends StatefulWidget {
  final String? initialHtml;
  final String? initialCss;
  final String? initialJs;

  /// Reprend et enregistre le code de l'utilisateur (onglet Lab).
  final bool keepsDraft;

  const LabScreen({
    super.key,
    this.initialHtml,
    this.initialCss,
    this.initialJs,
    this.keepsDraft = false,
  });

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
  final FocusNode _htmlFocus = FocusNode();
  final FocusNode _cssFocus = FocusNode();
  final FocusNode _jsFocus = FocusNode();

  /// Code de départ (exemple choisi ou code reçu) : sert à savoir si
  /// l'utilisateur l'a modifié.
  late LabCode _baseline;
  String? _presetId;
  int _pickerVersion = 0;
  Timer? _saveTimer;
  AppLifecycleListener? _lifecycle;

  LabCode get _code =>
      (html: _htmlController.text, css: _cssController.text, js: _jsController.text);

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), _saveNow);
  }

  void _saveNow() {
    _saveTimer?.cancel();
    LabDraftService.instance.save(_code, _presetId);
  }

  List<FocusNode> get _editorFocus => [_htmlFocus, _cssFocus, _jsFocus];

  final List<String> _logs = [];
  bool _consoleVisible = true;
  bool _running = false;

  WebViewController? _webController;
  String? _jquerySource;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final first = labPresets.first;
    _baseline = (
      html: widget.initialHtml ?? first.html,
      css: widget.initialCss ?? first.css,
      js: widget.initialJs ?? first.js,
    );
    var code = _baseline;
    final hasInitialCode =
        widget.initialHtml != null || widget.initialCss != null || widget.initialJs != null;
    _presetId = hasInitialCode ? null : first.id;

    final draft = widget.keepsDraft ? LabDraftService.instance.code : null;
    if (draft != null) {
      code = draft;
      _presetId = LabDraftService.instance.presetId;
      final preset = labPresets.where((p) => p.id == _presetId).firstOrNull;
      if (preset == null) _presetId = null;
      if (preset != null) _baseline = (html: preset.html, css: preset.css, js: preset.js);
    }
    _htmlController = TextEditingController(text: code.html);
    _cssController = TextEditingController(text: code.css);
    _jsController = TextEditingController(text: code.js);
    if (widget.keepsDraft) {
      for (final c in [_htmlController, _cssController, _jsController]) {
        c.addListener(_scheduleSave);
      }
      // Enregistre aussitôt si l'application passe en arrière-plan.
      _lifecycle = AppLifecycleListener(onInactive: _saveNow);
    }
    for (final node in _editorFocus) {
      node.addListener(_onEditorFocusChange);
    }
    _bootstrapWebview();
  }

  // La place de l'éditeur et de l'aperçu dépend de celui qu'on utilise.
  void _onEditorFocusChange() {
    if (mounted) setState(() {});
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

  Future<void> _applyPreset(LabPreset preset) async {
    if (_code != _baseline && !await _confirmReplace()) {
      // Remet la liste sur l'exemple en cours.
      if (mounted) setState(() => _pickerVersion++);
      return;
    }
    if (!mounted) return;
    setState(() {
      _presetId = preset.id;
      _baseline = (html: preset.html, css: preset.css, js: preset.js);
      _htmlController.text = preset.html;
      _cssController.text = preset.css;
      _jsController.text = preset.js;
    });
    await _run();
  }

  Future<bool> _confirmReplace() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remplacer votre code ?'),
        content: const Text('Vous avez modifié le code du laboratoire. '
            'Charger cet exemple effacera vos modifications.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Garder mon code'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remplacer'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  void dispose() {
    if (widget.keepsDraft) _saveNow();
    _lifecycle?.dispose();
    _tabController.dispose();
    _htmlController.dispose();
    _cssController.dispose();
    _jsController.dispose();
    for (final node in _editorFocus) {
      node.dispose();
    }
    super.dispose();
  }

  // Hauteurs minimales (toutes parties visibles : 72 + 150 + 30 + 70 + 110).
  static const double _toolbarHeight = 72;
  static const double _previewBarHeight = 30;
  static const double _previewMinHeight = 70;
  static const double _compactBelow = 432;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        // Peu de hauteur : clavier ouvert ou téléphone en paysage.
        final compact = height < _compactBelow;
        final sideBySide = compact && width >= 600;
        final showToolbar = height >= 170;
        final body = height - (showToolbar ? _toolbarHeight : 0);

        // Place restante pour l'éditeur en gardant un aperçu visible.
        final room = math.max(0.0, body - _previewBarHeight - _previewMinHeight);
        final double editorHeight;
        if (!compact) {
          editorHeight = (height * 0.34).clamp(150.0, 240.0);
        } else if (_editorFocus.any((node) => node.hasFocus)) {
          editorHeight = room;
        } else if (View.of(context).viewInsets.bottom > 0) {
          editorHeight = 0; // On écrit dans l'aperçu : il prend toute la place.
        } else {
          editorHeight = room * 0.5;
        }

        return Column(
          children: [
            if (showToolbar)
              SizedBox(
                height: _toolbarHeight,
                child: _Toolbar(
                  key: ValueKey((_presetId, _pickerVersion)),
                  presetId: _presetId,
                  running: _running,
                  onRun: _run,
                  onPreset: _applyPreset,
                ),
              ),
            // Le Flex change d'axe sans recréer la WebView.
            Expanded(
              child: Flex(
                direction: sideBySide ? Axis.horizontal : Axis.vertical,
                children: [
                  SizedBox(
                    height: sideBySide ? body : editorHeight,
                    width: sideBySide ? width / 2 : width,
                    child: _editors(sideBySide ? body : editorHeight),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        if (!sideBySide || body >= _previewBarHeight + 40)
                          _previewBar(showConsoleButton: !compact),
                        Expanded(child: _preview()),
                        if (_consoleVisible && !compact)
                          SizedBox(
                            height: (height * 0.22).clamp(110.0, 190.0),
                            child: _Console(logs: _logs, onClear: () => setState(_logs.clear)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _editors(double height) {
    if (height <= 0) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Très peu de place : on garde le champ plutôt que les onglets.
        if (height >= 100)
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
              _codeField(_htmlController, _htmlFocus),
              _codeField(_cssController, _cssFocus),
              _codeField(_jsController, _jsFocus),
            ],
          ),
        ),
      ],
    );
  }

  Widget _previewBar({required bool showConsoleButton}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: _previewBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      color: isDark ? const Color(0xFF1E2130) : const Color(0xFFE9EDF5),
      child: Row(
        children: [
          const Icon(Icons.visibility_outlined, size: 14),
          const SizedBox(width: 6),
          const Text('Aperçu', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (_running) ...[
            const SizedBox(
                width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 6),
          ],
          if (showConsoleButton)
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Basculer la console',
              icon: const Icon(Icons.terminal, size: 16),
              onPressed: () => setState(() => _consoleVisible = !_consoleVisible),
            ),
        ],
      ),
    );
  }

  Widget _preview() {
    final controller = _webController;
    if (controller != null) return WebViewWidget(controller: controller);
    if (WebViewPlatform.instance != null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.visibility_off, size: 36),
            const SizedBox(height: 10),
            const Text('Aperçu indisponible', style: TextStyle(fontWeight: FontWeight.w700)),
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
    );
  }

  Widget _codeField(TextEditingController controller, FocusNode focusNode) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? CodeDarkColors.background : CodeLightColors.background,
      child: CodeField(
        controller: controller,
        focusNode: focusNode,
        expands: true,
        color: isDark ? CodeDarkColors.text : CodeLightColors.text,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12),
          hintText: '// écrivez votre code…',
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final String? presetId;
  final bool running;
  final VoidCallback onRun;
  final ValueChanged<LabPreset> onPreset;

  const _Toolbar({
    super.key,
    required this.presetId,
    required this.running,
    required this.onRun,
    required this.onPreset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<LabPreset>(
              initialValue: labPresets.where((p) => p.id == presetId).firstOrNull,
              hint: const Text('Choisir…'),
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

  // Préfixes posés par la console du laboratoire (voir LabEngine).
  static Color _color(String log) {
    if (log.startsWith('Erreur')) return const Color(0xFFFF8A80);
    if (log.startsWith('Avertissement') || log.startsWith('⚠')) return const Color(0xFFFFD180);
    return Colors.white;
  }

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
                      style: TextStyle(color: Colors.white60, fontSize: 12, fontFamily: 'monospace'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: logs.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${i + 1} › ${logs[i]}',
                        style: TextStyle(
                            color: _color(logs[i]),
                            fontSize: 12,
                            fontFamily: 'monospace',
                            height: 1.4),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
