import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/api/movie_service.dart';
import 'package:movieapp/movie/models/MovieModel.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Future<Map<String, dynamic>> _futureCredits;
  Future<List<Movie>>? _futuresimilarMovies;

  @override
  void initState() {
    super.initState();
    _futureCredits = MovieService().fetchMovieCredits(widget.movie.id);
    _futuresimilarMovies = MovieService().fetchMovieSimilar(widget.movie.id);
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
                    widget.movie.voteAverage.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
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
        'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
        fit: BoxFit.cover,
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

  Widget _buildMovieSection(
      {required String title, required Future<List<Movie>>? futureMovies}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .yellowAccent, // Customize this to match the style in the image
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // See All functionality
              //   },
              //   child: Text(
              //     'See all',
              //     style: TextStyle(
              //       fontSize: 16,
              //       color: Colors.yellowAccent,
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 8),
          FutureBuilder<List<Movie>>(
            future: futureMovies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final movies = snapshot.data!;
                return Container(
                  height: 200, // Fixed height for the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return _buildMovieItem(movie);
                    },
                  ),
                );
              } else {
                return Center(child: Text('No movies available.'));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMovieItem(Movie movie) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'movieDetail',
          extra: movie, // Pass the movie data as an extra parameter
        );
      },
      child: Container(
        width: 130, // Fixed width for each movie item
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 150,
                width: 130,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
