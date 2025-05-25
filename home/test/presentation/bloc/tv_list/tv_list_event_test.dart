import 'package:flutter_test/flutter_test.dart';
import 'package:home/presentation/bloc/tv_list/tv_list_event.dart';

void main() {
  group('TvListEvent', () {
    group('FetchOnTheAirTv', () {
      test('should be comparable', () {
        final event1 = FetchOnTheAirTv();
        final event2 = FetchOnTheAirTv();

        expect(event1, event2);
        expect(event1.props, event2.props);
        expect(event1.props, []);
      });
    });

    group('FetchPopularTv', () {
      test('should be comparable', () {
        final event1 = FetchPopularTv();
        final event2 = FetchPopularTv();

        expect(event1, event2);
        expect(event1.props, event2.props);
        expect(event1.props, []);
      });
    });

    group('FetchTopRatedTv', () {
      test('should be comparable', () {
        final event1 = FetchTopRatedTv();
        final event2 = FetchTopRatedTv();

        expect(event1, event2);
        expect(event1.props, event2.props);
        expect(event1.props, []);
      });
    });
  });
}
