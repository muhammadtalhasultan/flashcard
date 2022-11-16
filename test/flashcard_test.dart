import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flashcard/flashcard.dart';

List<Widget> cards = [
  Container(),
  Container(),
  Container(),
];

MaterialApp tcardApp = MaterialApp(
  home: Scaffold(
    body: FlashCard(cards: cards),
  ),
);

void main() {
  testWidgets('render tcards', (WidgetTester tester) async {
    await tester.pumpWidget(tcardApp);

    expect(find.byType(FlashCard), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
  });
}
