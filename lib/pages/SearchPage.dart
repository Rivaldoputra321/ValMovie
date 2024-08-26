import 'package:flutter/material.dart';
import 'package:movieapp/api/movie_service.dart';
import 'package:movieapp/movie/models/MovieModel.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Movie>>? _searchResults;
  final MovieService _movieService = MovieService();

  void _searchMovies(String query) {
    setState(() {
      _searchResults = _movieService.searchMovies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a movie...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
          textInputAction: TextInputAction.search,
          onSubmitted: _searchMovies,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchResults = null;
              });
            },
          ),
        ],
      ),
      body: _searchResults == null
          ? Center(child: Text('Search for a movie to see results.'))
          : FutureBuilder<List<Movie>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final movies = snapshot.data!;
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/original${movie.posterPath}',
                            height: 300,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(movie.title),
                        subtitle: Text(movie.releaseDate),
                        onTap: () {
                          context.pushNamed(
                            'movieDetail',
                            extra: movie,
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No results found.'));
                }
              },
            ),
    );
  }
}
