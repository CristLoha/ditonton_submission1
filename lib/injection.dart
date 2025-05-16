import 'package:core/core.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton_submission1/features/movies/data/datasources/db/movie_database_helper.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/db/tv_database_helper.dart';
import 'package:ditonton_submission1/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_submission1/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_submission1/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:ditonton_submission1/features/tv/data/repositories/tv_repository_impl.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/search_tv.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/search/search_movie_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/search/search_tv_bloc.dart';
import 'package:home/home.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'features/movies/presentation/bloc/popular/popular_movies_bloc.dart';
import 'features/tv/presentation/provider/tv/popular_tv_notifier.dart';
import 'features/tv/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc movie
  locator.registerFactory(() => SearchMovieBloc(locator()));
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
      getMovieRecommendations: locator(),
    ),
  );
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => WatchlistMovieBloc(locator()));

  // bloc movie
  locator.registerFactory(
    () => MovieListBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  // bloc tv
  locator.registerFactory(
    () => TvListBloc(
      getOnTheAirTv: locator(),
      getPopularTv: locator(),
      getTopRatedTv: locator(),
    ),
  );

  locator.registerFactory(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(() => SearchTvBloc(locator()));
  locator.registerFactory(() => PopularTvBloc(locator()));
  locator.registerFactory(() => TopRatedTvNotifier(getTopRatedTv: locator()));

  locator.registerFactory(() => WatchlistTvNotifier(getWatchlistTv: locator()));

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
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchListTv(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));

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

  // data sources tv local
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(databaseHelper: locator()),
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
