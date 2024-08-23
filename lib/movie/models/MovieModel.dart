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

  // Fungsi factory untuk mengubah JSON menjadi objek Movie
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? 'No Overview',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? 'Unknown',
    );
  }
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

