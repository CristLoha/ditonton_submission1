import 'dart:convert';
import 'package:core/core.dart';
import 'package:ditonton_submission1/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_submission1/features/tv/data/models/tv_detail_model.dart';
import 'package:ditonton_submission1/features/tv/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Air Tv', () {
    final tTvResponse = TvResponse.fromJson(
      json.decode(readJson('dummy_data/on_the_air.json')),
    );
    final tTvList = tTvResponse.tvList;

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/on_the_air.json'), 200),
        );
        // act
        final result = await dataSource.getOnTheAirTv();
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getOnTheAirTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular Tv', () {
    final tTvResponse = TvResponse.fromJson(
      json.decode(readJson('dummy_data/popular_tv.json')),
    );
    final tTvList = tTvResponse.tvList;

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/popular_tv.json'), 200),
        );
        // act
        final result = await dataSource.getPopularTv();
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv detail', () {
    final tId = 1;
    final tTvDetailResponse = TvDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_detail.json'), 200),
      );
      // act
      final result = await dataSource.getTvDetail(tId);
      // assert
      expect(result, equals(tTvDetailResponse));
    });

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv recommendations', () {
    final tId = 1;
    final tTvList =
        TvResponse.fromJson(
          json.decode(readJson('dummy_data/tv_recommendations.json')),
        ).tvList;

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTvRecommendations(tId);
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated Tv', () {
    final tTvResponse = TvResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv.json')),
    );
    final tTvList = tTvResponse.tvList;

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/top_rated_tv.json'), 200),
        );
        // act
        final result = await dataSource.getTopRatedTv();
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Tv Search', () {
    final tQuery = 'The Last of Us';
    final tTvResponse = TvResponse.fromJson(
      json.decode(readJson('dummy_data/search_the_last_of_us_tv.json')),
    );
    final tTvList = tTvResponse.tvList;

    test(
      'should return list of Tv Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/search_the_last_of_us_tv.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.searchTv(tQuery);
        // assert
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        // act
        final call = dataSource.searchTv(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('TvRemoteDataSourceImpl initialization', () {
    test('should use provided client when client is passed', () {
      final dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
      expect(dataSource.client, mockHttpClient);
    });

    test('should use SSLPinning client when no client is provided', () {
      final dataSource = TvRemoteDataSourceImpl();
      expect(dataSource.client, isA<http.Client>());
    });
  });
}
