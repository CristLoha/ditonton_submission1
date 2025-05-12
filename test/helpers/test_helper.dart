import 'package:core/core.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton_submission1/features/movies/data/datasources/db/movie_database_helper.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/db/tv_database_helper.dart';
import 'package:ditonton_submission1/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_submission1/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/get_watchlist_status_movie.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton_submission1/features/movies/domain/usecases/search_movies.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/search_tv.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton_submission1/features/tv/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:home/home.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/tv_search_notifier.dart';
import 'package:ditonton_submission1/features/tv/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

// Test data
final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genres: [Genre(id: 1, name: 'Action')],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  runtime: 120,
  title: 'Spider-Man',
  voteAverage: 7.2,
  voteCount: 13507,
);

final tMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final tTv = Tv(
  adult: false,
  backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
  genreIds: [18],
  id: 100088,
  originalName: 'The Last of Us',
  overview:
      'Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.',
  popularity: 433.6105,
  posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
  firstAirDate: DateTime.parse('2023-01-15'),
  name: 'The Last of Us',
  voteAverage: 8.579,
  voteCount: 5750,
  originCountry: ['US'],
  originalLanguage: 'en',
);

final testTvList = [tTv];

// Mock classes
@GenerateMocks(
  [
    GetTopRatedMovies,
    GetTopRatedTv,
    MovieRepository,
    TvRepository,
    MovieRemoteDataSource,
    TvRemoteDataSource,
    NetworkInfo,
    GetMovieDetail,
    GetMovieRecommendations,
    GetWatchListStatusMovie,
    SaveWatchlistMovie,
    RemoveWatchlistMovie,
    GetWatchlistMovies,
    GetWatchListTv,
    SearchMovies,
    SearchTv,
    GetTvDetail,
    GetTvRecommendations,
    GetWatchListStatusTv,
    SaveWatchlistTv,
    RemoveWatchlistTv,
    MovieDatabaseHelper,
    TvDatabaseHelper,
    TopRatedTvNotifier,
    TvDetailNotifier,
    PopularTvNotifier,
    GetPopularTv,
    TvSearchNotifier,
    WatchlistTvNotifier,
    DataConnectionChecker,
    http.Client,
  ],
  customMocks: [
    MockSpec<MovieRemoteDataSource>(as: #MockMovieRemoteDataSourceImpl),
    MockSpec<TvRemoteDataSource>(as: #MockTvRemoteDataSourceImpl),
    MockSpec<MovieLocalDataSource>(as: #MockMovieLocalDataSource),
    MockSpec<TvLocalDataSource>(as: #MockTvLocalDataSource),
  ],
)
void main() {}
