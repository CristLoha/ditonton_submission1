// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:core/core.dart';
// import 'package:home/domain/usecases/get_now_playing_movies.dart';
// import 'package:home/domain/usecases/get_popular_movies.dart';
// import 'package:home/domain/usecases/get_top_rated_movies.dart';
// import 'package:home/presentation/bloc/movie_list/movie_list_bloc.dart';
// import 'package:home/presentation/bloc/movie_list/movie_list_event.dart';
// import 'package:home/presentation/bloc/movie_list/movie_list_state.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import '../../dummy_data/dummy_objects.dart';
// import 'movie_list_bloc_test.mocks.dart';

// @GenerateMocks([GetPopularMovies, GetTopRatedMovies, GetNowPlayingMovies])
// void main() {
//   late MovieListBloc bloc;
//   late MockGetNowPlayingMovies mockGetNowPlayingMovies;
//   late MockGetPopularMovies mockGetPopularMovies;
//   late MockGetTopRatedMovies mockGetTopRatedMovies;

//   setUp(() {
//     mockGetNowPlayingMovies = MockGetNowPlayingMovies();
//     mockGetPopularMovies = MockGetPopularMovies();
//     mockGetTopRatedMovies = MockGetTopRatedMovies();
//     bloc = MovieListBloc(
//       getNowPlayingMovies: mockGetNowPlayingMovies,
//       getPopularMovies: mockGetPopularMovies,
//       getTopRatedMovies: mockGetTopRatedMovies,
//     );
//   });

//   group('Now Playing Movies', () {
//     test('initial state should be empty', () {
//       expect(bloc.state, const MovieListState());
//     });

//     blocTest<MovieListBloc, MovieListState>(
//       'should emit [loading, loaded] when data is gotten successfully',
//       build: () {
//         when(
//           mockGetNowPlayingMovies.execute(),
//         ).thenAnswer((_) async => Right(testMovieList));
//         return bloc;
//       },
//       act: (bloc) => bloc.add(FetchNowPlayingMovies()),
//       expect:
//           () => [
//             const MovieListState(nowPlayingState: RequestState.loading),
//             MovieListState(
//               nowPlayingState: RequestState.loaded,
//               nowPlayingMovies: testMovieList,
//             ),
//           ],
//       verify: (_) {
//         verify(mockGetNowPlayingMovies.execute());
//       },
//     );

//     blocTest<MovieListBloc, MovieListState>(
//       'should emit [loading, error] when get data is unsuccessful',
//       build: () {
//         when(
//           mockGetNowPlayingMovies.execute(),
//         ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
//         return bloc;
//       },
//       act: (bloc) => bloc.add(FetchNowPlayingMovies()),
//       expect:
//           () => [
//             const MovieListState(nowPlayingState: RequestState.loading),
//             const MovieListState(
//               nowPlayingState: RequestState.error,
//               message: 'Server Failure',
//             ),
//           ],
//       verify: (_) {
//         verify(mockGetNowPlayingMovies.execute());
//       },
//     );
//   });

//   group('Popular Movies', () {
//     blocTest<MovieListBloc, MovieListState>(
//       'should emit [loading, loaded] when data is gotten successfully',
//       build: () {
//         when(
//           mockGetPopularMovies.execute(),
//         ).thenAnswer((_) async => Right(testMovieList));
//         return bloc;
//       },
//       act:
//           (bloc) => bloc.add(
//             FetchMovieListPopularMovies(),
//           ), // Ubah ke FetchMovieListPopularMovies
//       expect:
//           () => [
//             const MovieListState(popularMoviesState: RequestState.loading),
//             MovieListState(
//               popularMoviesState: RequestState.loaded,
//               popularMovies: testMovieList,
//             ),
//           ],
//       verify: (_) {
//         verify(mockGetPopularMovies.execute());
//       },
//     );

//     blocTest<MovieListBloc, MovieListState>(
//       'should emit [loading, error] when get data is unsuccessful',
//       build: () {
//         when(
//           mockGetPopularMovies.execute(),
//         ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
//         return bloc;
//       },
//       act:
//           (bloc) => bloc.add(
//             FetchMovieListPopularMovies(),
//           ), // Ubah ke FetchMovieListPopularMovies
//       expect:
//           () => [
//             const MovieListState(popularMoviesState: RequestState.loading),
//             const MovieListState(
//               popularMoviesState: RequestState.error,
//               message: 'Server Failure',
//             ),
//           ],
//       verify: (_) {
//         verify(mockGetPopularMovies.execute());
//       },
//     );
//   });

//   group('Top Rated Movies', () {
//     blocTest<MovieListBloc, MovieListState>(
//       'should emit [loading, loaded] when data is gotten successfully',
//       build: () {
//         when(
//           mockGetTopRatedMovies.execute(),
//         ).thenAnswer((_) async => Right(testMovieList));
//         return bloc;
//       },
//       act: (bloc) => bloc.add(FetchTopRatedMovies()),
//       expect:
//           () => [
//             const MovieListState(topRatedMoviesState: RequestState.loading),
//             MovieListState(
//               topRatedMoviesState: RequestState.loaded,
//               topRatedMovies: testMovieList,
//             ),
//           ],
//       verify: (_) {
//         verify(mockGetTopRatedMovies.execute());
//       },
//     );

//     blocTest<MovieListBloc, MovieListState>(
//       'should emit [loading, error] when get data is unsuccessful',
//       build: () {
//         when(
//           mockGetTopRatedMovies.execute(),
//         ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
//         return bloc;
//       },
//       act: (bloc) => bloc.add(FetchTopRatedMovies()),
//       expect:
//           () => [
//             const MovieListState(topRatedMoviesState: RequestState.loading),
//             const MovieListState(
//               topRatedMoviesState: RequestState.error,
//               message: 'Server Failure',
//             ),
//           ],
//       verify: (_) {
//         verify(mockGetTopRatedMovies.execute());
//       },
//     );
//   });
// }
