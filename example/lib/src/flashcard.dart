// ignore_for_file: depend_on_referenced_packages, unused_field

import 'package:flutter/material.dart';
import 'package:flashcardplus/flashcardplus.dart';

List<Color> colors = [
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.orange,
  Colors.pink,
  Colors.amber,
  Colors.cyan,
  Colors.purple,
  Colors.brown,
  Colors.teal,
];

List<Widget> cards = List.generate(
  colors.length,
  (int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors[index],
      ),
      child: Text(
        '${index + 1}',
        style: const TextStyle(fontSize: 100.0, color: Colors.white),
      ),
    );
  },
);

class FlashCardPage extends StatefulWidget {
  const FlashCardPage({super.key});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  final FlashCardController _controller = FlashCardController();

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 200),
            FlashCardPlus(
              cards: cards,
              controller: _controller,
              onForward: (index, info) {
                // you can load more cards from you server
                var offset = 3;
                if (index >= cards.length - offset) {
                  List<Widget> addCards = List.generate(
                    colors.length,
                    (int index2) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors[index2],
                        ),
                        child: Text(
                          '${index2 + 1}',
                          style: const TextStyle(
                              fontSize: 100.0, color: Colors.white),
                        ),
                      );
                    },
                  ).toList();
                  setState(() {
                    cards.addAll(addCards);
                  });
                  _controller.append(addCards);
                }
                _index = index;
                setState(() {});
              },
              onBack: (index, info) {
                _index = index;
                setState(() {});
              },
              onEnd: () {},
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _controller.back();
                  },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.forward();
                  },
                  child: const Text('Forward'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.reset();
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // you can add more cards
                    _controller.append(cards);
                  },
                  child: const Text('Append'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
