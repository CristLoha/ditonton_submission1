import 'package:ditonton_submission1/core/constants/colors.dart';
import 'package:ditonton_submission1/core/constants/themes.dart';
import 'package:ditonton_submission1/core/utils/utils.dart';
import 'package:ditonton_submission1/injection.dart' as di;
import 'package:ditonton_submission1/presentation/pages/about_page.dart';
import 'package:ditonton_submission1/presentation/pages/movies/movie_detail_page.dart';
import 'package:ditonton_submission1/presentation/pages/movies/movie_search_page.dart';
import 'package:ditonton_submission1/presentation/pages/movies/popular_movies_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton_submission1/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton_submission1/presentation/pages/home_page.dart';
import 'package:ditonton_submission1/presentation/pages/tv/tv_search_page.dart';
import 'package:ditonton_submission1/presentation/pages/watchlist_page.dart';
import 'package:ditonton_submission1/presentation/provider/movies/movie_detail_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/movies/movie_list_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/movies/movie_search_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/movies/popular_movies_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/movies/top_rated_movies_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/tv/tv_search_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/movies/watchlist_movie_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvNotifier>(),
        ),
        ChangeNotifierProvider(create: (_) => di.locator<PopularTvNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TopRatedTvNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TvDetailNotifier>()),

        ChangeNotifierProvider(create: (_) => di.locator<TvListNotifier>()),
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
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case MovieSearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => MovieSearchPage());
            case TvSearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => TvSearchPage());
            case WatchlistPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case PopularTvPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularTvPage());
            case TopRatedTvPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedTvPage());
            case TvDetailPage.routeName:
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
