import 'dart:convert';
import 'package:http/http.dart' as http;

class WordGenerator {
  static const String randomWordApiUrl = "https://trouve-mot.fr/api/random/10";

  static Future<List<String>> getRandomWords() async {

    List<String> randomWords = [];

    final response = await http.get(Uri.parse(randomWordApiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // boucle sur les 10 mots renvoyés pour ne garder que le nom
      for (var i = 0; i < data.length; i++) {
        data[i] = data[i]['name'];
        // Ajouter le mot à la liste
        randomWords.add(data[i] as String);
      }
    }


    return randomWords;
  }
}
