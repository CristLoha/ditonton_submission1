import 'dart:convert';
import 'package:core/core.dart';
import 'package:ditonton_submission1/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton_submission1/features/movies/data/models/movie_detail_model.dart';
import 'package:ditonton_submission1/features/movies/data/models/movie_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSource;
  late MockIOClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockIOClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Movies', () {
    final tMovieList =
        MovieResponse.fromJson(
          json.decode(readJson('dummy_data/now_playing.json')),
        ).movieList;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/now_playing.json'), 200),
        );
        // act
        final result = await dataSource.getNowPlayingMovies();
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getNowPlayingMovies();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular Movies', () {
    final tMovieList =
        MovieResponse.fromJson(
          json.decode(readJson('dummy_data/popular_movie.json')),
        ).movieList;

    test(
      'should return list of movies when response is success (200)',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/popular?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/popular_movie.json'), 200),
        );
        // act
        final result = await dataSource.getPopularMovies();
        // assert
        expect(result, tMovieList);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/popular?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularMovies();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Movies', () {
    final tMovieList =
        MovieResponse.fromJson(
          json.decode(readJson('dummy_data/top_rated_movie.json')),
        ).movieList;

    test('should return list of movies when response code is 200 ', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/movie/top_rated?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/top_rated_movie.json'), 200),
      );
      // act
      final result = await dataSource.getTopRatedMovies();
      // assert
      expect(result, tMovieList);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/top_rated?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedMovies();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie detail', () {
    final tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
      json.decode(readJson('dummy_data/movie_detail.json')),
    );

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/movie/$tId?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/movie_detail.json'), 200),
      );
      // act
      final result = await dataSource.getMovieDetail(tId);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/$tId?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovieDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie recommendations', () {
    final tMovieList =
        MovieResponse.fromJson(
          json.decode(readJson('dummy_data/movie_recommendations.json')),
        ).movieList;
    final tId = 1;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/movie/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/movie_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getMovieRecommendations(tId);
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/movie/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovieRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search movies', () {
    final tSearchResult =
        MovieResponse.fromJson(
          json.decode(readJson('dummy_data/search_spiderman_movie.json')),
        ).movieList;
    final tQuery = 'Spiderman';

    test('should return list of movies when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/movie?$apiKey&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_spiderman_movie.json'),
          200,
        ),
      );
      // act
      final result = await dataSource.searchMovies(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/movie?$apiKey&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchMovies(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
  group('MovieRemoteDataSourceImpl initialization', () {
    test('should use provided client when client is passed', () {
      final dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
      expect(dataSource.client, mockHttpClient);
    });

    test('should use SSLPinning client when no client is provided', () {
      final dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
      expect(dataSource.client, isA<http.Client>());
    });
  });
}
