import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class MovieGenerator {
  static const String apiKey = "fd4651c463eead9c0e5a93af47dd4578";

  static Future<List<int>> getTop250MovieIds() async {
    final int randomPageNumber = 1 + Random().nextInt(13); // Random page number between 1 and 13

    final String url = "https://api.themoviedb.org/3/list/634?api_key=$apiKey&language=fr-FR&page=$randomPageNumber";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<dynamic> items = listData['items'];

      // Extract movie IDs from the list
      final List<int> movieIds = items.map<int>((item) => item['id']).toList();

      return movieIds;
    }

    // Handle error or return an empty list
    return [];
  }

  static Future<Map<String, String>> generateRandomMovie() async {
    final List<int> movieIds = await getTop250MovieIds();

    if (movieIds.isNotEmpty) {
      // Pick a random movie ID from the list
      final int randomMovieId = movieIds[Random().nextInt(movieIds.length)];

      final String url = "https://api.themoviedb.org/3/movie/$randomMovieId?language=fr-FR&api_key=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> movie = json.decode(response.body);

        final String title = movie['title'];
        final String posterPath = movie['poster_path'];
        final String overview = movie['overview'];

        return {'title': title, 'posterPath': posterPath, 'overview': overview};
      }
    }

    // Handle error or return default values
    return {'title': 'Unknown', 'posterPath': '', 'overview': 'No overview available.'};
  }
}
