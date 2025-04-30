import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/core/constants/text_styles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Text Styles', () {
    test('kHeading5 should have correct properties', () {
      expect(kHeading5.fontSize, equals(23));
      expect(kHeading5.fontWeight, equals(FontWeight.w400));
    });

    test('kHeading6 should have correct properties', () {
      expect(kHeading6.fontSize, equals(19));
      expect(kHeading6.fontWeight, equals(FontWeight.w500));
      expect(kHeading6.letterSpacing, equals(0.15));
    });

    test('kSubtitle should have correct properties', () {
      expect(kSubtitle.fontSize, equals(15));
      expect(kSubtitle.fontWeight, equals(FontWeight.w400));
      expect(kSubtitle.letterSpacing, equals(0.15));
    });

    test('kBodyText should have correct properties', () {
      expect(kBodyText.fontSize, equals(13));
      expect(kBodyText.fontWeight, equals(FontWeight.w400));
      expect(kBodyText.letterSpacing, equals(0.25));
    });
  });
}
