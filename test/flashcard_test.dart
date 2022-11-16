import 'package:flashcardplus/flashcardplus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

List<Widget> cards = [
  Container(),
  Container(),
  Container(),
];

MaterialApp tcardApp = MaterialApp(
  home: Scaffold(
    body: FlashCardPlus(cards: cards),
  ),
);

void main() {
  testWidgets('render tcards', (WidgetTester tester) async {
    await tester.pumpWidget(tcardApp);

    expect(find.byType(FlashCardPlus), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
  });
}
