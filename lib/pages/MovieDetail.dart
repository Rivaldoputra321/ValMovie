import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/api/movie_service.dart';
import 'package:movieapp/movie/models/MovieModel.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<Map<String, dynamic>> _futureCredits;
  Future<List<Movie>>? _futuresimilarMovies;
  Future<List<Video>>? _futureVideosMovies;

  @override
  void initState() {
    super.initState();
    _futureCredits = MovieService().fetchMovieCredits(widget.movie.id);
    _futuresimilarMovies = MovieService().fetchMovieSimilar(widget.movie.id);
    _futureVideosMovies = MovieService().fetchVideoMovies(widget.movie.id);
  }

  // Method to get YouTube video URL
  String? getYoutubeVideoUrl(List<Video> videos) {
    final video = videos.firstWhere(
      (video) =>
          video.site.toLowerCase() == 'youtube' &&
          video.type.toLowerCase() == 'trailer',
    );
    return video != null
        ? 'https://www.youtube.com/watch?v=${video.key}'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoviePoster(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovieTitleSection(),
                  SizedBox(height: 16),
                  Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.movie.overview,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  _buildCastSection(),
                  SizedBox(height: 16),
                  _buildCrewSection(),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovieSection(
                    title: "Similar Film",
                    futureMovies: _futuresimilarMovies,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviePoster() {
    return Container(
      width: double.infinity,
      height: 250,
      child: Image.network(
        'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildMovieTitleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMoviePosterTitle(),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Release Date: ${widget.movie.releaseDate}",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  SizedBox(width: 4),
                  Text(
                    widget.movie.formattedVoteAverage,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (_futureVideosMovies != null) {
                    final videos = await _futureVideosMovies;
                    final url = getYoutubeVideoUrl(videos!);
                    if (url != null) {
                      await launch(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Trailer not available')),
                      );
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(10),
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellowAccent),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Watch Trailer",
                    style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoviePosterTitle() {
    return Container(
      width: 100,
      height: 140,
      child: Image.network(
        'https://image.tmdb.org/t/p/original${widget.movie.posterPath}',
        height: 100,
        width: 140,
        fit: BoxFit.cover,
        errorBuilder: (context, error, StackTrace) {
          return Container(
            width: 140,
            height: 100,
            child: Center(
              child: Text("Photo Not Found"),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCastSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureCredits,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Cast> cast = snapshot.data!['cast'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cast",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: MediaQuery.of(context).size.height / 5,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  itemBuilder: (context, index) {
                    final actor = cast[index];
                    return _buildCastItem(actor);
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text('No cast available.'));
        }
      },
    );
  }

  Widget _buildCastItem(Cast actor) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              actor.profilePath.isNotEmpty
                  ? 'https://image.tmdb.org/t/p/w500${actor.profilePath}'
                  : 'https://via.placeholder.com/100', // Placeholder image
              height: 120,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            actor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            actor.character,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrewSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureCredits,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Crew> crew = snapshot.data!['crew'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Crew",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: MediaQuery.of(context).size.height / 5,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: crew.length,
                  itemBuilder: (context, index) {
                    final member = crew[index];
                    return _buildCrewItem(member);
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text('No crew available.'));
        }
      },
    );
  }

  Widget _buildCrewItem(Crew member) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              member.profilePath.isNotEmpty
                  ? 'https://image.tmdb.org/t/p/w500${member.profilePath}'
                  : 'https://via.placeholder.com/100', // Placeholder image
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            member.job,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieSection({
    required String title,
    required Future<List<Movie>>? futureMovies,
  }) {
    return FutureBuilder<List<Movie>>(
      future: futureMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Movie> movies = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return _buildMovieItem(movie);
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text('No $title available.'));
        }
      },
    );
  }

  Widget _buildMovieItem(Movie movie) {
    return GestureDetector(
      onTap: () {
        context.push('/movies/${movie.id}', extra: movie);
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 180,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
