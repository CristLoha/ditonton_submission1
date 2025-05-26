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
import 'package:ditonton_submission1/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/search_tv.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/search/search_movie_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/detail/movie_detail_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/detail/tv_detail_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/search/search_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:home/home.dart';
import 'package:home/presentation/bloc/home/home_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';
import 'features/movies/presentation/bloc/popular/popular_movies_bloc.dart';
import 'package:ditonton_submission1/features/movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  final ioClient = await SslPinning.ioClient;

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
    () => TvDetailBloc(
      getTvDetail: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
      getTvRecommendations: locator(),
    ),
  );

  locator.registerFactory(() => HomeCubit());

  locator.registerFactory(() => SearchTvBloc(locator()));
  locator.registerFactory(() => PopularTvBloc(locator()));
  locator.registerFactory(() => TopRatedTvBloc(locator()));

  locator.registerFactory(() => WatchlistTvBloc(locator()));

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
  locator.registerLazySingleton<IOClient>(() => ioClient);
  locator.registerLazySingleton(() => DataConnectionChecker());

  // network info
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: locator()),
  );
}
