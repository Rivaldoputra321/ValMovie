import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieapp/movie/models/MovieModel.dart';

class MovieService {
  static const String _apiKey =
      'e4f1e22cc8dfb95aab3f2c1699289773'; // Replace with your TMDb API key
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  

  // Fetch Now Playing Movies
  Future<List<Movie>> fetchNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List movies = jsonData['results'];
      return movies.map((movieData) => Movie.fromJson(movieData)).toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  // Fetch Trending Movies This Week
  Future<List<Movie>> fetchTrendingMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/trending/movie/week?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List movies = jsonData['results'];
      return movies.map((movieData) => Movie.fromJson(movieData)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<Movie>> fetchUpcomingMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List movies = jsonData['results'];
      return movies.map((movieData) => Movie.fromJson(movieData)).toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

// Video Trailer

  Future<List<Video>> fetchVideoMovies(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  // Fetch Cast and Crew
  Future<Map<String, dynamic>> fetchMovieCredits(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List cast = jsonData['cast'];
      List crew = jsonData['crew'];

      return {
        'cast': cast.map((castData) => Cast.fromJson(castData)).toList(),
        'crew': crew.map((crewData) => Crew.fromJson(crewData)).toList(),
      };
    } else {
      throw Exception('Failed to load movie credits');
    }
  }

  Future<List<Movie>> fetchMovieSimilar(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/similar?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List movies = jsonData['results'];
      return movies.map((movieData) => Movie.fromJson(movieData)).toList();
    } else {
      throw Exception('Failed To Load Similar Movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
