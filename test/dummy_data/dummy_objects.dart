import 'package:ditonton_submission1/data/models/movie_detail_model.dart';
import 'package:ditonton_submission1/data/models/movie_table.dart';
import 'package:ditonton_submission1/data/models/tv_detail_model.dart';
import 'package:ditonton_submission1/domain/entities/genre.dart';
import 'package:ditonton_submission1/domain/entities/movie.dart';
import 'package:ditonton_submission1/domain/entities/movie_detail.dart';
import 'package:ditonton_submission1/domain/entities/tv_detail.dart';
import 'package:ditonton_submission1/domain/entities/tv.dart';
import 'package:ditonton_submission1/data/models/tv_model.dart';
import 'package:ditonton_submission1/data/models/movie_model.dart';
import 'package:ditonton_submission1/data/models/genre_model.dart';
import 'package:ditonton_submission1/data/models/tv_table.dart';

final testMovie = Movie(
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

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testMovieCache = MovieTable(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testMovieCacheMap = {
  'id': 557,
  'overview':
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  'title': 'Spider-Man',
};

final testMovieFromCache = Movie.watchlist(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: '/h0y3OzHzG4yNvn8u3Za6ByH8lrQ.jpg',
  id: 45789,
  name: 'Sturm der Liebe',
  overview:
      'These are the stories of relationships taking place in the fictional five-star hotel Fürstenhof, located in Feldkirchen-Westerham near Rosenheim with the plot revolving around members of the family room area, the hotel owners, and employees.',
  posterPath: '/jfFNydakwvbeACEwSd2Gh8UWtba.jpg',
  voteAverage: 6.014,
  voteCount: 36,
  firstAirDate: DateTime.parse('2005-09-26'),
  genreIds: [18],
  originalName: 'Sturm der Liebe',
  originCountry: ['DE'],
  originalLanguage: 'de',
  popularity: 572.0316,
);

final testTv = Tv(
  id: 100088,
  name: 'The Last of Us',
  overview:
      'Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.',
  posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
  voteAverage: 8.579,
  voteCount: 5750,
  adult: false,
  backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
  genreIds: [18],
  originalName: 'The Last of Us',
  originCountry: ['US'],
  originalLanguage: 'en',
  popularity: 433.6105,
  firstAirDate: DateTime.parse('2023-01-15'),
);

final testTvModel = TvModel(
  id: 100088,
  name: 'The Last of Us',
  overview:
      'Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.',
  posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
  voteAverage: 8.579,
  voteCount: 5750,
  firstAirDate: DateTime.parse('2023-01-15'),
  genreIds: [18],
  originalName: 'The Last of Us',
  originCountry: ['US'],
  originalLanguage: 'en',
  popularity: 433.6105,
  backdropPath: '/7dowXHcFccjmxf0YZYxDFkfVq65.jpg',
  adult: false,
);

final testTvModelList = [testTvModel];

final testMovieModel = MovieModel(
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

final testMovieResponse = MovieDetailResponse(
  adult: false,
  backdropPath: 'backdropPath',
  budget: 100,
  genres: [GenreModel(id: 1, name: 'Action')],
  homepage: "https://google.com",
  id: 1,
  imdbId: 'imdb1',
  originalLanguage: 'en',
  originalTitle: 'originalTitle',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  revenue: 12000,
  runtime: 120,
  status: 'Status',
  tagline: 'Tagline',
  title: 'title',
  video: false,
  voteAverage: 1,
  voteCount: 1,
);

final testTvDetailResponse = TvDetailResponse(
  adult: false,
  backdropPath: '/h0y3OzHzG4yNvn8u3Za6ByH8lrQ.jpg',
  createdBy: [],
  episodeRunTime: [45],
  firstAirDate: DateTime.parse('2005-09-26'),
  genres: [GenreModel(id: 18, name: 'Drama')],
  homepage: 'https://www.ard.de/',
  id: 45789,
  inProduction: true,
  languages: ['de'],
  lastAirDate: DateTime.parse('2023-01-15'),
  name: 'Sturm der Liebe',
  nextEpisodeToAir: null,
  numberOfEpisodes: 50,
  numberOfSeasons: 1,
  originCountry: ['DE'],
  originalLanguage: 'de',
  originalName: 'Sturm der Liebe',
  overview:
      'These are the stories of relationships taking place in the fictional five-star hotel Fürstenhof, located in Feldkirchen-Westerham near Rosenheim with the plot revolving around members of the family room area, the hotel owners, and employees.',
  popularity: 572.0316,
  posterPath: '/jfFNydakwvbeACEwSd2Gh8UWtba.jpg',
  productionCompanies: [],
  status: 'Returning Series',
  tagline: 'Tagline',
  type: 'Scripted',
  voteAverage: 6.014,
  voteCount: 36,
);

final testTvCache = TvTable(
  id: 100088,
  name: 'The Last of Us',
  overview:
      'Twenty years after modern civilization has been destroyed, Joel, a hardened survivor, is hired to smuggle Ellie, a 14-year-old girl, out of an oppressive quarantine zone. What starts as a small job soon becomes a brutal, heartbreaking journey, as they both must traverse the United States and depend on each other for survival.',
  posterPath: '/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg',
);
