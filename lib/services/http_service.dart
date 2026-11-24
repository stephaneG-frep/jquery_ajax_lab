import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Résultat d'une requête HTTP réussie.
class HttpResult {
  final int statusCode;
  final Duration elapsed;
  final Map<String, String> responseHeaders;
  final String body;

  const HttpResult({
    required this.statusCode,
    required this.elapsed,
    required this.responseHeaders,
    required this.body,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// Retourne le corps formaté en JSON s'il est valide, sinon le texte brut.
  String get prettyBody {
    try {
      final decoded = jsonDecode(body);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return body;
    }
  }
}

/// Erreur explicative lors d'un échec réseau.
class HttpFailure {
  final String title;
  final String message;

  const HttpFailure({required this.title, required this.message});
}

class HttpService {
  final http.Client _client;
  final Duration _timeout;

  HttpService({http.Client? client, this._timeout = const Duration(seconds: 20)})
      : _client = client ?? http.Client();

  static const List<String> methods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'];

  /// Envoie une requête HTTP quelconque et retourne un résultat ou une erreur.
  Future<({HttpResult? result, HttpFailure? failure})> send({
    required String method,
    required String url,
    Map<String, String> headers = const {},
    String? body,
  }) async {
    if (url.trim().isEmpty) {
      return (
        result: null,
        failure: const HttpFailure(
          title: 'URL vide',
          message: 'Renseignez une URL avant d\'envoyer la requête. '
              'Exemple : https://jsonplaceholder.typicode.com/users',
        ),
      );
    }

    final parsed = Uri.tryParse(url.trim());
    if (parsed == null || !(parsed.hasScheme && parsed.host.isNotEmpty)) {
      return (
        result: null,
        failure: const HttpFailure(
          title: 'URL incorrecte',
          message: 'L\'URL saisie n\'est pas valide. Vérifiez qu\'elle commence '
              'par http:// ou https:// et qu\'elle ne contient pas d\'espaces.',
        ),
      );
    }

    final stopwatch = Stopwatch()..start();
    try {
      final response = await _request(method, parsed, headers, body).timeout(_timeout);
      stopwatch.stop();

      return (
        result: HttpResult(
          statusCode: response.statusCode,
          elapsed: stopwatch.elapsed,
          responseHeaders: response.headers,
          body: _decodeBody(response),
        ),
        failure: null,
      );
    } on SocketException {
      stopwatch.stop();
      return (
        result: null,
        failure: const HttpFailure(
          title: 'Pas de connexion Internet',
          message: 'Impossible de joindre le serveur. Vérifiez votre connexion '
              'puis réessayez. Les cours fonctionnent hors connexion ; seules '
              'les requêtes réelles ont besoin d\'Internet.',
        ),
      );
    } on TimeoutException {
      stopwatch.stop();
      return (
        result: null,
        failure: const HttpFailure(
          title: 'Délai dépassé',
          message: 'Le serveur n\'a pas répondu dans le délai imparti. '
              'Vérifiez l\'URL ou réessayez plus tard.',
        ),
      );
    } on http.ClientException catch (e) {
      stopwatch.stop();
      return (
        result: null,
        failure: HttpFailure(
          title: 'Erreur réseau',
          message: 'La requête a échoué : ${e.message}. '
              'Vérifiez l\'URL, le réseau, ou les permissions de l\'API.',
        ),
      );
    } catch (e) {
      stopwatch.stop();
      return (
        result: null,
        failure: HttpFailure(
          title: 'Erreur inattendue',
          message: 'Une erreur est survenue : $e',
        ),
      );
    }
  }

  Future<http.Response> _request(
    String method,
    Uri uri,
    Map<String, String> headers,
    String? body,
  ) async {
    final request = http.Request(method.toUpperCase(), uri)..headers.addAll(headers);
    // Un GET n'envoie pas de corps.
    if (body != null && body.trim().isNotEmpty && request.method != 'GET') {
      // Sans Content-Type explicite, le corps est annoncé comme du JSON
      // (package:http annoncerait du text/plain).
      request.headers.putIfAbsent('Content-Type', () => 'application/json');
      request.body = body;
    }
    return http.Response.fromStream(await _client.send(request));
  }

  /// Décode le corps en UTF-8, sinon en latin1 ; un contenu binaire est résumé.
  static String _decodeBody(http.Response response) {
    final bytes = response.bodyBytes;
    final type = response.headers['content-type'] ?? '';
    final isBinary = RegExp(
      r'^(image/(?!svg)|audio/|video/|font/|application/(octet-stream|pdf|zip))',
      caseSensitive: false,
    ).hasMatch(type);
    if (isBinary) return '[Contenu binaire : $type, ${bytes.length} octets]';
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return latin1.decode(bytes);
    }
  }
}
