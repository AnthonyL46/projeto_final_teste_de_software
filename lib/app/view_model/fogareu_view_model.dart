import 'package:stove_test_project/app/model/fogareu_model.dart';
import 'package:stove_test_project/app/services/fogareu_service.dart';

class FogareuViewModel {
  FogareuService fogareuService = FogareuService();

  void ligarFogareu(int temperatura) {
    fogareuService.setFogareu(true, temperatura);
  }

  Future<bool> fogareuIsEnable() async {
    Fogareu fogareu = await fogareuService.getFogareu();

    bool isEnable = fogareu.toMap()['isEnable'];

    return isEnable;
  }

  Future<int> fogareuTemperature() async {
    Fogareu fogareu = await fogareuService.getFogareu();

    int temperatura = fogareu.toMap()['temperatura'];

    return temperatura;
  }

  void desligarFogareu(){
    fogareuService.setFogareu(false, 0);
  }

  void alterarTemperatura(int temperatura){
    fogareuService.setFogareu(true, temperatura);
  }
}
