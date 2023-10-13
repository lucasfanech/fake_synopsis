import 'dart:convert';
import 'package:http/http.dart' as http;

class WordGenerator {
  static const String datamuseApiUrl = "https://api.datamuse.com/words?rel_trg=";
  static const String randomWordApiUrl = "https://random-word-api.herokuapp.com/word";

  static Future<List<String>> generateWordsFromSynopsis(String synopsis) async {
    List<String> relatedWords = await _getRelatedWords(synopsis);
    List<String> randomWords = await _getRandomWords();

    // Prendre seulement 5 mots de chaque liste
    relatedWords = relatedWords.take(5).toList();
    randomWords = randomWords.take(5).toList();

    // Combiner les deux listes
    List<String> allWords = [...relatedWords, ...randomWords];

    return allWords;
  }

  static Future<List<String>> _getRelatedWords(String synopsis) async {
    List<String> words = synopsis.split(" ");
    List<String> relatedWords = [];

    for (String word in words) {
      final response = await http.get(Uri.parse('$datamuseApiUrl$word'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<String> words = data.map((entry) => entry['word'] as String).toList();
        relatedWords.addAll(words);
      }
    }

    return relatedWords;
  }

  static Future<List<String>> _getRandomWords() async {

    List<String> randomWords = [];

    // Effectuer 5 requêtes pour obtenir 5 mots aléatoires
    for (int i = 0; i < 5; i++) {
      final response = await http.get(Uri.parse(randomWordApiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        randomWords.add(data[0] as String); // Ajouter le mot à la liste
      }
    }

    return randomWords;
  }
}
