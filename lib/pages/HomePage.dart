import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/api/movie_service.dart';
import 'package:movieapp/movie/models/MovieModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieService _movieService = MovieService();
  Future<List<Movie>>? _futureNowPlayingMovies;
  Future<List<Movie>>? _futureTrendingMovies;
  Future<List<Movie>>? _futureUpcomingMovies;

  @override
  void initState() {
    super.initState();
    _futureNowPlayingMovies =
        _movieService.fetchNowPlayingMovies(); // Fetch Now Playing movies
    _futureTrendingMovies =
        _movieService.fetchTrendingMovies(); // Fetch Trending movies
    _futureUpcomingMovies = _movieService.fetchUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ValMovies'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              context.pushNamed('searchMovie');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieSection(
              title: "Now Playing",
              futureMovies: _futureNowPlayingMovies,
            ),
            _buildMovieSection(
              title: "Trending This Week",
              futureMovies: _futureTrendingMovies,
            ),
            _buildMovieSection(
              title: "Coming Soon",
              futureMovies: _futureUpcomingMovies,
            ),
          ],
        ),
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
              GestureDetector(
                onTap: () {
                  context.pushNamed('seeAll');
                },
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.yellowAccent,
                  ),
                ),
              ),
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
