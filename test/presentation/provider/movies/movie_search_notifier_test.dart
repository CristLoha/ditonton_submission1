// import 'package:dartz/dartz.dart';
// import 'package:ditonton_submission1/features/movies/presentation/provider/movies/movie_search_notifier.dart';
// import 'package:core/core.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import '../../../dummy_data/dummy_objects.dart';
// import '../../../helpers/test_helper.mocks.dart';

// void main() {
//   late MovieSearchNotifier provider;
//   late MockSearchMovies mockSearchMovies;
//   late int listenerCallCount;

//   setUp(() {
//     listenerCallCount = 0;
//     mockSearchMovies = MockSearchMovies();
//     provider = MovieSearchNotifier(searchMovies: mockSearchMovies)
//       ..addListener(() {
//         listenerCallCount += 1;
//       });
//   });

//   final tQuery = 'spiderman';

//   group('search movies', () {
//     test('should change state to loading when usecase is called', () async {
//       // arrange
//       when(
//         mockSearchMovies.execute(tQuery),
//       ).thenAnswer((_) async => Right(testMovieList));
//       // act
//       provider.fetchMovieSearch(tQuery);
//       // assert
//       expect(provider.state, RequestState.loading);
//     });

//     test(
//       'should change search data when data is gotten successfully',
//       () async {
//         // arrange
//         when(
//           mockSearchMovies.execute(tQuery),
//         ).thenAnswer((_) async => Right(testMovieList));
//         // act
//         await provider.fetchMovieSearch(tQuery);
//         // assert
//         expect(provider.state, RequestState.loaded);
//         expect(provider.searchResult, testMovieList);
//         expect(listenerCallCount, 2);
//       },
//     );

//     test('should return error when data is unsuccessful', () async {
//       // arrange
//       when(
//         mockSearchMovies.execute(tQuery),
//       ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
//       // act
//       await provider.fetchMovieSearch(tQuery);
//       // assert
//       expect(provider.state, RequestState.error);
//       expect(provider.message, 'Server Failure');
//       expect(listenerCallCount, 2);
//     });
//   });
// }
