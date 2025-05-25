import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/detail/tv_detail_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/search/search_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:ditonton_submission1/firebase_options.dart';
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
import 'package:ditonton_submission1/watchlist_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:ditonton_submission1/features/tv/presentation/pages/tv_search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home/presentation/bloc/home/home_cubit.dart';
import 'package:provider/provider.dart';
import 'features/movies/presentation/bloc/popular/popular_movies_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SSLPinning.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  di.init();
  final analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);

  runApp(MyApp(analytics: analytics));
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics;
  const MyApp({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Movie
        BlocProvider(create: (_) => di.locator<MovieListBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<SearchMovieBloc>()),
        BlocProvider(create: (_) => di.locator<HomeCubit>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        // TV
        BlocProvider(create: (_) => di.locator<TvListBloc>()),
        BlocProvider(create: (_) => di.locator<SearchTvBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvBloc>()),
        BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ditonton Submission Final',

        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomePage(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
          routeObserver,
        ],
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
