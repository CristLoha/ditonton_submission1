import 'package:core/core.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_event.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_state.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  WatchlistPageState createState() => WatchlistPageState();
}

class WatchlistPageState extends State<WatchlistPage>
    with RouteAware, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      if (!mounted) return;
      context.read<WatchlistMovieBloc>().add(FetchWatchlistMoviesEvent());
      context.read<WatchlistTvBloc>().add(FetchWatchlistTvEvent());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    if (_tabController.index == 0) {
      context.read<WatchlistMovieBloc>().add(FetchWatchlistMoviesEvent());
    } else {
      context.read<WatchlistTvBloc>().add(FetchWatchlistTvEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'Movies'), Tab(text: 'TV Shows')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMovieContent(), _buildTvContent()],
      ),
    );
  }

  Widget _buildMovieContent() {
    return BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
      builder: (context, state) {
        if (state is WatchlistMovieLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WatchlistMovieHasData) {
          final result = state.result;
          return ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
              final movie = result[index];
              return MediaCardList(media: movie, isMovie: true);
            },
            itemCount: result.length,
          );
        } else if (state is WatchlistMovieEmpty) {
          return Center(child: Text('No movies in watchlist'));
        } else if (state is WatchlistMovieError) {
          return Center(key: Key('error_message'), child: Text(state.message));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildTvContent() {
    return BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
      builder: (context, state) {
        if (state is WatchlistTvLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WatchlistTvHasData) {
          final data = state.result;
          return ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
              final tv = data[index];
              return MediaCardList(media: tv, isMovie: false);
            },
            itemCount: data.length,
          );
        } else if (state is WatchlistTvEmpty) {
          return Center(child: Text('No TV shows in watchlist'));
        } else if (state is WatchlistTvError) {
          return Center(key: Key('error_message'), child: Text(state.message));
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }
}
