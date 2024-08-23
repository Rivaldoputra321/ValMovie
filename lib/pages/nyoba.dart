// import 'package:http/http.dart' as http;
// import 'package:movieapp/api/api_config.dart';
// import 'dart:convert';

// import 'package:movieapp/movie/models/MovieModel.dart';


// class MovieService {
//   static Future<List<Movie>> fetchMovies() async {
//     final response = await http.get(Uri.parse(
//       '${ApiConfig.baseUrl}/movie/popular?api_key=${ApiConfig.apiKey}',
//     ));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List<dynamic> results = data['results'];
//       return results.map((json) => Movie.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to fetch movies');
//     }
//   }
// }