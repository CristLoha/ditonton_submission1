import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_submission1/presentation/pages/about_page.dart';

void main() {
  testWidgets('About page should display correct content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: AboutPage()));

    // Verify the back button exists
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Verify the image exists
    expect(find.byType(Image), findsOneWidget);

    // Verify the description text
    expect(
      find.text(
        'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('About page should have correct layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: AboutPage()));

    // Verify the Scaffold exists
    expect(find.byType(Scaffold), findsOneWidget);

    // Verify at least one Stack exists
    expect(find.byType(Stack), findsWidgets);

    // Verify the Column exists
    expect(find.byType(Column), findsOneWidget);

    // Verify the SafeArea exists
    expect(find.byType(SafeArea), findsOneWidget);

    // Verify the containers exist
    expect(find.byType(Container), findsAtLeastNWidgets(2));
  });

  testWidgets('Back button should pop navigation', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AboutPage()));

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify that we've popped the navigation
    expect(find.byType(AboutPage), findsNothing);
  });
}
