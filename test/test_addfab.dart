import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:homework_tracker/widgets.dart/add_fab.dart';

void main() {
  testWidgets('AddFAB displays and responds to tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: AddFAB(
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // Verify that the FAB is present
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the FAB
    await tester.tap(find.byType(AddFAB));
    await tester.pump();

    // Verify that the onPressed callback was called
    expect(tapped, isTrue);
  });
}