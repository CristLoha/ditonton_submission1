import 'package:core/core.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_event.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_state.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
      Provider.of<WatchlistTvNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTv();
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
      Provider.of<WatchlistTvNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTv();
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
    return Consumer<WatchlistTvNotifier>(
      builder: (context, data, child) {
        if (data.watchlistState == RequestState.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (data.watchlistState == RequestState.loaded) {
          if (data.watchlistTv.isEmpty) {
            return Center(child: Text('No TV shows in watchlist'));
          }
          return ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
              final tv = data.watchlistTv[index];
              return MediaCardList(media: tv, isMovie: false);
            },
            itemCount: data.watchlistTv.length,
          );
        } else {
          return Center(child: Text(data.message));
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
