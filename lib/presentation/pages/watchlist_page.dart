import 'package:ditonton_submission1/core/enums/state_enum.dart';
import 'package:ditonton_submission1/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton_submission1/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton_submission1/core/utils/utils.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';

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
      Provider.of<WatchlistMovieNotifier>(
        context,
        listen: false,
      ).fetchWatchlistMovies();
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
      Provider.of<WatchlistMovieNotifier>(
        context,
        listen: false,
      ).fetchWatchlistMovies();
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
    return Consumer<WatchlistMovieNotifier>(
      builder: (context, data, child) {
        if (data.watchlistState == RequestState.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (data.watchlistState == RequestState.loaded) {
          if (data.watchlistMovies.isEmpty) {
            return Center(child: Text('No movies in watchlist'));
          }
          return ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
              final movie = data.watchlistMovies[index];
              return MediaCardList(media: movie, isMovie: true);
            },
            itemCount: data.watchlistMovies.length,
          );
        } else {
          return Center(key: Key('error_message'), child: Text(data.message));
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
