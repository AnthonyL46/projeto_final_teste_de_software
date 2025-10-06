import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stove_test_project/app/services/fogareu_service.dart';

void main() {
  group('FogareuService - GET', () {
    test('deve retornar um Fogareu válido quando status 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({
          "isEnable": true,
          "temperatura": 180,
        }), 200);
      });

      final service = FogareuService(client: mockClient);
      final fogareu = await service.getFogareu();

      expect(fogareu.isEnable, isTrue);
      expect(fogareu.temperatura, 180);
    });

    test('deve lançar exceção quando status != 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response("Erro", 404);
      });

      final service = FogareuService(client: mockClient);

      expect(() async => await service.getFogareu(), throwsException);
    });
  });

  group('FogareuService - POST', () {
    test('deve enviar corretamente o JSON e retornar sucesso', () async {
      final mockClient = MockClient((request) async {
        final body = jsonDecode(request.body);
        expect(body["files"]["fogareu_mock.json"]["content"], isNotEmpty);
        return http.Response("{}", 201);
      });

      final service = FogareuService(client: mockClient);
      await service.setFogareu(true, 250);
    });

    test('deve lançar exceção se status != 200/201', () async {
      final mockClient = MockClient((request) async {
        return http.Response("Erro", 409);
      });

      final service = FogareuService(client: mockClient);

      expect(() async => await service.setFogareu(true, 100), throwsException);
    });
  });
}
