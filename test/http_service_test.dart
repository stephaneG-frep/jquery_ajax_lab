import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:jquery_ajax_lab/services/http_service.dart';

void main() {
  group('HttpService', () {
    test('une URL vide retourne une erreur explicative', () async {
      final service = HttpService();
      final result = await service.send(method: 'GET', url: '  ');
      expect(result.result, isNull);
      expect(result.failure!.title, contains('URL vide'));
    });

    test('une URL sans schéma est refusée', () async {
      final service = HttpService();
      final result = await service.send(method: 'GET', url: 'pas-une-url');
      expect(result.result, isNull);
      expect(result.failure!.title, contains('URL incorrecte'));
    });

    test('une requête GET réussie est analysée', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        return http.Response(
          jsonEncode([{'id': 1, 'name': 'Alice'}]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final service = HttpService(client: client, timeout: const Duration(seconds: 5));
      final result = await service.send(
        method: 'GET',
        url: 'https://example.com/api/users',
      );
      expect(result.failure, isNull);
      expect(result.result!.statusCode, 200);
      expect(result.result!.isSuccess, isTrue);
      expect(result.result!.prettyBody, contains('Alice'));
      expect(result.result!.elapsed, isNotNull);
    });

    test('une requête POST envoie le corps et la bonne méthode', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.headers['content-type'], 'application/json');
        return http.Response(jsonEncode({'id': 2}), 201);
      });
      final service = HttpService(client: client, timeout: const Duration(seconds: 5));
      final result = await service.send(
        method: 'POST',
        url: 'https://example.com/api/users',
        headers: {'Content-Type': 'application/json'},
        body: '{"name": "Bob"}',
      );
      expect(result.result!.statusCode, 201);
    });

    test('une erreur 404 est transmise comme résultat', () async {
      final client = MockClient((request) async {
        return http.Response('introuvable', 404);
      });
      final service = HttpService(client: client, timeout: const Duration(seconds: 5));
      final result = await service.send(
        method: 'GET',
        url: 'https://example.com/api/absent',
      );
      expect(result.result!.statusCode, 404);
      expect(result.result!.isSuccess, isFalse);
    });

    test('un corps non JSON reste en texte brut', () async {
      final client = MockClient((request) async => http.Response('<html>', 200));
      final service = HttpService(client: client, timeout: const Duration(seconds: 5));
      final result = await service.send(
        method: 'GET',
        url: 'https://example.com/page',
      );
      expect(result.result!.body, '<html>');
    });

    test('une erreur réseau est convertie en HttpFailure', () async {
      final client = MockClient((request) async => throw http.ClientException('boom'));
      final service = HttpService(client: client, timeout: const Duration(seconds: 5));
      final result = await service.send(
        method: 'GET',
        url: 'https://example.com/api',
      );
      expect(result.result, isNull);
      expect(result.failure!.title, contains('Erreur réseau'));
    });

    test('un délai dépassé est converti en HttpFailure', () async {
      final client = MockClient((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        return http.Response('{}', 200);
      });
      final service = HttpService(
        client: client,
        timeout: const Duration(milliseconds: 50),
      );
      final result = await service.send(
        method: 'GET',
        url: 'https://example.com/api',
      );
      expect(result.result, isNull);
      expect(result.failure!.title, contains('Délai dépassé'));
    });
  });
}
