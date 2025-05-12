import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/search/search_tv_bloc.dart';
import 'package:ditonton_submission1/injection.dart' as di;
import 'package:ditonton_submission1/features/movies/presentation/bloc/search/search_movie_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_submission1/features/movies/presentation/pages/movie_search_page.dart';
import 'package:ditonton_submission1/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton_submission1/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/tv_search_page.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/watchlist_page.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/tv_search_notifier.dart';
import 'package:ditonton_submission1/features/movies/presentation/provider/movies/watchlist_movie_notifier.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home/presentation/bloc/home/home_bloc.dart';
import 'package:provider/provider.dart';
import 'features/tv/presentation/provider/tv/popular_tv_notifier.dart';
import 'features/tv/presentation/provider/tv/top_rated_tv_notifier.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Movie
        BlocProvider(create: (_) => di.locator<MovieListBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<SearchMovieBloc>()),
        BlocProvider(create: (_) => di.locator<HomeBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        // TV
        BlocProvider(create: (_) => di.locator<TvListBloc>()),
        BlocProvider(create: (_) => di.locator<SearchTvBloc>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvNotifier>(),
        ),
        ChangeNotifierProvider(create: (_) => di.locator<PopularTvNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TopRatedTvNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TvDetailNotifier>()),

        ChangeNotifierProvider(create: (_) => di.locator<TvSearchNotifier>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case popularMoviesRoute:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case topRatedMoviesRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case movieDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case movieSearchRoute:
              return CupertinoPageRoute(builder: (_) => MovieSearchPage());
            case tvSearchRoute:
              return CupertinoPageRoute(builder: (_) => TvSearchPage());
            case wachlistRoute:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case aboutRoute:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case popularTvRoute:
              return CupertinoPageRoute(builder: (_) => PopularTvPage());
            case topRatedTvRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedTvPage());
            case tvDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
