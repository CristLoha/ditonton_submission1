import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton_submission1/core/error/network_info.dart';
import 'package:ditonton_submission1/data/datasources/db/movie_database_helper.dart';
import 'package:ditonton_submission1/data/datasources/db/tv_database_helper.dart';
import 'package:ditonton_submission1/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_submission1/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton_submission1/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_submission1/data/repositories/movie_repository_impl.dart';
import 'package:ditonton_submission1/data/repositories/tv_repository_impl.dart';
import 'package:ditonton_submission1/domain/repositories/movie_repository.dart';
import 'package:ditonton_submission1/domain/repositories/tv_repository.dart';
import 'package:ditonton_submission1/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_submission1/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_submission1/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_submission1/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_submission1/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_submission1/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_submission1/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_submission1/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_watchlist_status_movie.dart';
import 'package:ditonton_submission1/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_submission1/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_submission1/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton_submission1/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_submission1/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton_submission1/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_submission1/domain/usecases/search_movies.dart';
import 'package:ditonton_submission1/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton_submission1/presentation/provider/watchlist_movie_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider movie
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  // provider tv
  locator.registerFactory(
    () => TvListNotifier(
      getOnTheAirTv: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator(),
    ),
  );

  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => MovieSearchNotifier(searchMovies: locator()));
  locator.registerFactory(() => PopularMoviesNotifier(locator()));
  locator.registerFactory(
    () => TopRatedMoviesNotifier(getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(getWatchlistMovies: locator()),
  );

  // use case movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovie(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // use case tv
  locator.registerLazySingleton(() => GetOnTheAirTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => GetWatchlistStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchListTv(locator()));

  // repository movie
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // repository tv
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // data sources movie remote
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  //data sources movie local
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );

  // data sources tv remote
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(client: locator()),
  );

  // helper
  locator.registerLazySingleton<MovieDatabaseHelper>(
    () => MovieDatabaseHelper(),
  );
  locator.registerLazySingleton<TvDatabaseHelper>(() => TvDatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());

  // network info
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: locator()),
  );
}
