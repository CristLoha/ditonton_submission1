import 'package:ditonton_submission1/features/movies/presentation/bloc/search/search_movie_bloc.dart';
import 'package:home/domain/entities/movie.dart';
import 'package:ditonton_submission1/features/movies/presentation/pages/movie_search_page.dart';
import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchMovieBloc searchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = SearchMovieBloc(mockSearchMovies);
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMovieBloc>.value(
      value: searchBloc,
      child: MaterialApp(home: body),
    );
  }

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider...',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    searchBloc.emit(SearchMovieLoading());

    await tester.pumpWidget(makeTestableWidget(MovieSearchPage()));
    await tester.enterText(find.byType(TextField), 'Spider-Man');
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    searchBloc.emit(SearchMovieHasData([tMovie]));

    await tester.pumpWidget(makeTestableWidget(MovieSearchPage()));
    await tester.enterText(find.byType(TextField), 'Spider-Man');
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MediaCardList), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    searchBloc.emit(SearchMovieError('Error message'));

    await tester.pumpWidget(makeTestableWidget(MovieSearchPage()));
    await tester.enterText(find.byType(TextField), 'Spider-Man');
    await tester.pump();

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Page should display empty container when search is empty',
      (WidgetTester tester) async {
    searchBloc.emit(SearchMovieEmpty());

    await tester.pumpWidget(makeTestableWidget(MovieSearchPage()));
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(find.byType(Container), findsOneWidget);
  });
}
