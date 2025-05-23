import 'package:flutter_test/flutter_test.dart';
import 'package:home/domain/entities/genre.dart';

void main() {
  group('Genre', () {
    test('should create Genre object correctly', () {
      // arrange & act
      const genre = Genre(id: 1, name: 'Action');

      // assert
      expect(genre.id, 1);
      expect(genre.name, 'Action');
    });

    test('should support value equality', () {
      // arrange
      const genre1 = Genre(id: 1, name: 'Action');
      const genre2 = Genre(id: 1, name: 'Action');

      // act & assert
      expect(genre1, genre2);
    });

    test('props should contain all properties', () {
      // arrange
      const genre = Genre(id: 1, name: 'Action');

      // act
      final props = genre.props;

      // assert
      expect(props, [1, 'Action']);
    });
  });
}