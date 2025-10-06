import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stove_test_project/app/api_key.dart';
import 'package:stove_test_project/app/model/fogareu_model.dart';

class FogareuService {
  final String url = "https://api.github.com/gists/631a7e284c90682a4811e43e49e3cb32";
  final http.Client client;

  FogareuService({http.Client? client}) : client = client ?? http.Client();

  Future<Fogareu> getFogareu() async {
    try {
      final resposta = await client.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $apiKey"},
      );

      if (resposta.statusCode != 200) {
        throw Exception("Erro ao buscar fogareu: ${resposta.statusCode}");
      }

      final data = jsonDecode(resposta.body);
      return Fogareu.fromMap(data);
    } on Exception catch (e) {
      throw Exception("Problema no get: $e");
    }
  }

  Future<void> setFogareu(bool isEnable, int temperatura) async {
    final fogareu = Fogareu(isEnable: isEnable, temperatura: temperatura);
    final contentJSON = json.encode(fogareu.toMap());

    final response = await client.post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $apiKey"},
      body: json.encode({
        "description": "fogareu_mock.json",
        "public": true,
        "files": {
          "fogareu_mock.json": {"content": contentJSON},
        },
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao enviar dados: ${response.statusCode}");
    }
  }
}




// import 'dart:convert';

// import 'package:stove_test_project/app/api_key.dart';
// import 'package:stove_test_project/app/model/fogareu_model.dart';
// import 'package:http/http.dart';

// class FogareuService {
//   String url = "https://api.github.com/gists/631a7e284c90682a4811e43e49e3cb32";

//   Future<Fogareu> getFogareu() async {
//     Fogareu fogareu;
//     try {
//       Response resposta = await get(
//         Uri.parse(url),
//         headers: {"Authorization": "Bearer $apiKey"},
//       );
//       List<dynamic> responseFromJSON = jsonDecode(resposta.body);
//       fogareu = Fogareu.fromMap(responseFromJSON as Map<String, dynamic>);
//     } on Exception catch (e) {
//       throw Exception("Problema no get, $e");
//     }
//     return fogareu;
//   }

//   Future<void> setFogareu(bool isEnable, int temperatura) async {
//     Fogareu fogareu = Fogareu(isEnable: isEnable, temperatura: temperatura);
//     String contentJSON = json.encode(fogareu.toMap());
//     Response response = await post(
//       Uri.parse(url),
//       headers: {"Authorization": "Bearer $apiKey"},
//       body: json.encode({
//         "description": "fogareu_mock.json",
//         "public": true,
//         "files": {
//           "fogareu_mock.json": {"content": contentJSON},
//         },
//       }),
//     );
//     print(response.statusCode);
//   }
// }
