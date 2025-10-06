import 'package:flutter_test/flutter_test.dart';
import 'package:stove_test_project/app/model/fogareu_model.dart';

void main() {
  test('Fogareu toMap e fromMap funcionam corretamente', () {
  final fogareu = Fogareu(isEnable: true, temperatura: 200);
  final map = fogareu.toMap();

  expect(map['isEnable'], true);
  expect(map['temperatura'], 200);

  final fromMap = Fogareu.fromMap(map);
  expect(fromMap.isEnable, fogareu.isEnable);
  expect(fromMap.temperatura, fogareu.temperatura);
});

}