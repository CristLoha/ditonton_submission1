import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:home/domain/entities/tv.dart';
import 'package:home/presentation/bloc/home/home_bloc.dart';
import 'package:home/presentation/bloc/home/home_event.dart';
import 'package:home/presentation/bloc/home/home_state.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:home/presentation/bloc/movie_list/movie_list_state.dart';
import 'package:home/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:home/presentation/bloc/tv_list/tv_list_event.dart';
import 'package:home/presentation/bloc/tv_list/tv_list_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<MovieListBloc>()
        ..add(FetchNowPlayingMovies())
        ..add(FetchMovieListPopularMovies())
        ..add(FetchTopRatedMovies());
      context.read<TvListBloc>()
        ..add(FetchOnTheAirTv())
        ..add(FetchPopularTv())
        ..add(FetchTopRatedTv());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
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
                    selected: state.showMovies,
                    onTap: () {
                      context.read<HomeBloc>().add(const ToggleTab(true));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.tv),
                    title: Text('TV Shows'),
                    key: Key('tv_shows_button'),
                    selected: !state.showMovies,
                    onTap: () {
                      context.read<HomeBloc>().add(const ToggleTab(false));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.save_alt),
                    title: Text('Watchlist'),
                    onTap: () {
                      Navigator.pushNamed(context, wachlistRoute);
                    },
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, aboutRoute);
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
                    if (state.showMovies) {
                      Navigator.pushNamed(context, movieSearchRoute);
                    } else {
                      Navigator.pushNamed(context, tvSearchRoute);
                    }
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            body: state.showMovies ? _buildMovieContent() : _buildTvContent(),
          );
        },
      ),
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
            BlocBuilder<MovieListBloc, MovieListState>(
              builder: (context, data) {
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
              onTap: () => Navigator.pushNamed(context, popularMoviesRoute),
            ),
            BlocBuilder<MovieListBloc, MovieListState>(
              builder: (context, data) {
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
              onTap: () => Navigator.pushNamed(context, topRatedMoviesRoute),
            ),
            BlocBuilder<MovieListBloc, MovieListState>(
              builder: (context, data) {
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
      child: BlocBuilder<TvListBloc, TvListState>(
        builder: (context, state) {
          if (state is TvListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TvListHasData) {
   
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('On The Air', style: kHeading6),
                  TvList(state.onTheAirTv),

                  _buildSubHeading(
                    title: 'Popular',
                    onTap: () => Navigator.pushNamed(context, popularTvRoute),
                  ),
                  TvList(state.popularTv),

                  _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () => Navigator.pushNamed(context, topRatedTvRoute),
                  ),
                  TvList(state.topRatedTv),
                ],
              ),
            );
          } else if (state is TvListError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
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
                  movieDetailRoute,
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
                Navigator.pushNamed(context, tvDetailRoute, arguments: tv.id);
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
