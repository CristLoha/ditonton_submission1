import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_submission1/core/constants/text_styles.dart';
import 'package:ditonton_submission1/core/constants/values.dart';
import 'package:ditonton_submission1/domain/entities/movie.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/presentation/pages/about_page.dart';
import 'package:ditonton_submission1/presentation/pages/movies/movie_detail_page.dart';
import 'package:ditonton_submission1/presentation/pages/movies/movie_search_page.dart';
import 'package:ditonton_submission1/presentation/pages/movies/popular_movies_page.dart';
import 'package:ditonton_submission1/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/tv_search_page.dart';
import 'package:ditonton_submission1/presentation/pages/watchlist_page.dart';
import 'package:ditonton_submission1/presentation/provider/movies/movie_list_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _showMovies = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
      Provider.of<TvListNotifier>(context, listen: false)
        ..fetchOnTheAirTv()
        ..fetchPopularTv()
        ..fetchTopRatedTv();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              selected: _showMovies,
              onTap: () {
                setState(() {
                  _showMovies = true;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Shows'),
              key: Key('tv_shows_button'),
              selected: !_showMovies,
              onTap: () {
                setState(() {
                  _showMovies = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.routeName);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              if (_showMovies) {
                Navigator.pushNamed(context, MovieSearchPage.routeName);
              } else {
                Navigator.pushNamed(context, TvSearchPage.routeName);
              }
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: _showMovies ? _buildMovieContent() : _buildTvContent(),
    );
  }

  Widget _buildMovieContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Now Playing', style: kHeading6),
            Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return MovieList(data.nowPlayingMovies);
                } else {
                  return Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap:
                  () =>
                      Navigator.pushNamed(context, PopularMoviesPage.routeName),
            ),
            Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                final state = data.popularMoviesState;
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return MovieList(data.popularMovies);
                } else {
                  return Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    TopRatedMoviesPage.routeName,
                  ),
            ),
            Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                final state = data.topRatedMoviesState;
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return MovieList(data.topRatedMovies);
                } else {
                  return Text('Failed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTvContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('On The Air', style: kHeading6),
            Consumer<TvListNotifier>(
              builder: (context, data, child) {
                final state = data.onTheAirTvState;
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return TvList(data.onTheAirTv);
                } else {
                  return Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap:
                  () => Navigator.pushNamed(context, PopularTvPage.routeName),
            ),
            Consumer<TvListNotifier>(
              builder: (context, data, child) {
                final state = data.popularTvState;
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return TvList(data.popularTv);
                } else {
                  return Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap:
                  () => Navigator.pushNamed(context, TopRatedTvPage.routeName),
            ),
            Consumer<TvListNotifier>(
              builder: (context, data, child) {
                final state = data.topRatedTvState;
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return TvList(data.topRatedTv);
                } else {
                  return Text('Failed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvShows;

  const TvList(this.tvShows, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.routeName,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
