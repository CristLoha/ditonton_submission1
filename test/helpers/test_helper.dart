import 'package:ditonton_submission1/core/error/network_info.dart';
import 'package:ditonton_submission1/data/datasources/db/movie_database_helper.dart';
import 'package:ditonton_submission1/data/datasources/db/tv_database_helper.dart';
import 'package:ditonton_submission1/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_submission1/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton_submission1/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_submission1/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_submission1/domain/entities/movie.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/domain/repositories/movie_repository.dart';
import 'package:ditonton_submission1/domain/repositories/tv_repository.dart';
import 'package:ditonton_submission1/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_submission1/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_submission1/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_watchlist_status_movie.dart';
import 'package:ditonton_submission1/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_submission1/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton_submission1/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton_submission1/domain/usecases/search_movies.dart';
import 'package:ditonton_submission1/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_submission1/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_submission1/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_submission1/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_submission1/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_submission1/domain/usecases/search_tv.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

// Test data
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
    MovieRepository,
    TvRepository,
    MovieRemoteDataSource,
    TvRemoteDataSource,
    NetworkInfo,
    GetNowPlayingMovies,
    GetPopularMovies,
    GetTopRatedMovies,
    GetMovieDetail,
    GetMovieRecommendations,
    GetWatchListStatusMovie,
    SaveWatchlistMovie,
    RemoveWatchlistMovie,
    GetWatchlistMovies,
    GetWatchListTv,
    SearchMovies,
    SearchTv,
    GetOnTheAirTv,
    GetPopularTv,
    GetTopRatedTv,
    GetTvDetail,
    GetTvRecommendations,
    MovieDatabaseHelper,
    TvDatabaseHelper,
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
