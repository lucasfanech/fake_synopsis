import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieGenerator {
  static const String apiKey = "f284d86fabe6a583282b88a52798bdd6";

  static Future<Map<String, String>> generateRandomMovie() async {
    final int pageNumber = 1 + (DateTime.now().millisecondsSinceEpoch % 5); // Random page number between 1 and 5
    final String url = "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=$pageNumber&api_key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      if (results.isNotEmpty) {

        // Pick a random movie from the list
        int randomIndex = DateTime.now().millisecondsSinceEpoch % results.length;
        final Map<String, dynamic> movie = results[randomIndex];

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
