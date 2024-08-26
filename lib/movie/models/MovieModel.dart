import 'package:intl/intl.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  // Factory method to convert JSON into a Movie object
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Parse release date to display month name
    String rawDate = json['release_date'] ?? 'Unknown';
    String formattedDate;

    try {
      DateTime parsedDate = DateTime.parse(rawDate);
      formattedDate = DateFormat('d MMMM yyyy').format(parsedDate); // e.g., 23 January 2024
    } catch (e) {
      formattedDate = 'Unknown';
    }

    return Movie(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? 'No Overview',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: formattedDate,
    );
  }

  // Getter to format vote average with one decimal
  String get formattedVoteAverage => voteAverage.toStringAsFixed(1);
}

// CastModel.dart
class Cast {
  final int id;
  final String name;
  final String character;
  final String profilePath;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      character: json['character'] ?? 'No Character',
      profilePath: json['profile_path'] ?? '',
    );
  }
}

// CrewModel.dart
class Crew {
  final int id;
  final String name;
  final String job;
  final String profilePath;

  Crew({
    required this.id,
    required this.name,
    required this.job,
    required this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      job: json['job'] ?? 'No Job',
      profilePath: json['profile_path'] ?? '',
    );
  }
  
}

class Video {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      key: json['key'],
      name: json['name'] ?? 'No Name',
      site: json['site'] ?? 'No Site',
      type: json['type'] ?? 'No Type',
    );
  }
}


