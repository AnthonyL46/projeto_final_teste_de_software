import 'package:flutter_test/flutter_test.dart';
import 'package:stove_test_project/app/model/fogareu_model.dart';
import 'package:stove_test_project/app/view_model/fogareu_view_model.dart';
import 'package:stove_test_project/app/services/fogareu_service.dart';

// Mock manual do service (sem http)
class MockFogareuService extends FogareuService {
  bool? ultimoIsEnable;
  int? ultimaTemperatura;
  bool getFogareuChamado = false;

  @override
  Future<Fogareu> getFogareu() async {
    getFogareuChamado = true;
    return Fogareu(isEnable: true, temperatura: 180);
  }

  @override
  Future<void> setFogareu(bool isEnable, int temperatura) async {
    ultimoIsEnable = isEnable;
    ultimaTemperatura = temperatura;
  }
}

void main() {
  group('FogareuViewModel', () {
    late FogareuViewModel viewModel;
    late MockFogareuService mockService;

    setUp(() {
      mockService = MockFogareuService();
      viewModel = FogareuViewModel();
      viewModel.fogareuService = mockService;
    });

    test('deve chamar setFogareu(true, temperatura) ao ligar o fogareu', () {
      viewModel.ligarFogareu(200);

      expect(mockService.ultimoIsEnable, isTrue);
      expect(mockService.ultimaTemperatura, 200);
    });

    test('deve chamar setFogareu(false, 0) ao desligar fogareu', () {
      viewModel.desligarFogareu();

      expect(mockService.ultimoIsEnable, isFalse);
      expect(mockService.ultimaTemperatura, 0);
    });

    test('deve alterar a temperatura corretamente', () {
      viewModel.alterarTemperatura(250);

      expect(mockService.ultimoIsEnable, isTrue);
      expect(mockService.ultimaTemperatura, 250);
    });

    test('deve retornar true quando o fogareu estiver ligado', () async {
      final result = await viewModel.fogareuIsEnable();

      expect(mockService.getFogareuChamado, isTrue);
      expect(result, isTrue);
    });

    test('deve retornar a temperatura correta', () async {
      final result = await viewModel.fogareuTemperature();

      expect(mockService.getFogareuChamado, isTrue);
      expect(result, equals(180));
    });
  });
}
