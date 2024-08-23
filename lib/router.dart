import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/pages/HomePage.dart';
import 'package:movieapp/movie/models/MovieModel.dart';
import 'package:movieapp/pages/MovieDetail.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/movieDetail',
      name: 'movieDetail',
      builder: (BuildContext context, GoRouterState state) {
        final movie = state.extra as Movie; // Receive the movie data
        return MovieDetailPage(movie: movie);
      },
    ),
  ],
);
