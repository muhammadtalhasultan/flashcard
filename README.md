# FlashCard


[![GitHub stars](https://img.shields.io/github/stars/muhammadtalhasultan/flashcard)](https://github.com/xmuhammadtalhasultan/flashcard/stargazers) [![pub package](https://img.shields.io/pub/v/flashcard.svg)](https://pub.dev/packages/flashcard)

- [FlashCard](#flashcard)
  - [Install](#install)
  - [Usage](#usage)
    - [Normal widget](#normal-widget)
    - [Network image](#network-image)
    - [Use a controller to control](#use-a-controller-to-control)
    - [Determine the sliding direction](#determine-the-sliding-direction)
    - [Reset with new cards](#reset-with-new-cards)
  - [Property](#property)
  - [Contribute](#contribute)
  - [License](#license)

## Install

```yaml
# pubspec.yaml
dependencies:
  flashcard: ^0.0.1
```

## Usage

### Normal widget

```dart
List<Widget> cards = List.generate(
  5,
  (index) => Container(
    color: Colors.blue,
    child: Center(
      child: Text(
        '$index',
        style: TextStyle(fontSize: 60, color: Colors.white),
      ),
    ),
  ),
);

FlashCard(
  cards: cards,
)
```

### Network image

```dart
List<String> images = [
  'https://gank.io/images/5ba77f3415b44f6c843af5e149443f94',
  'https://gank.io/images/02eb8ca3297f4931ab64b7ebd7b5b89c',
  'https://gank.io/images/31f92f7845f34f05bc10779a468c3c13',
  'https://gank.io/images/b0f73f9527694f44b523ff059d8a8841',
  'https://gank.io/images/1af9d69bc60242d7aa2e53125a4586ad',
];

List<Widget> cards = List.generate(
  images.length,
  (int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 17),
            blurRadius: 23.0,
            spreadRadius: -13.0,
            color: Colors.black54,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          images[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  },
);

FlashCard(
  size: Size(400, 600),
  cards: cards,
);
```

Image from [gank.io](gank.io)

### Use a controller to control

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlashCardController _controller = FlashCardController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlashCard(
              cards: cards,
              leftIcon: ElevatedButton( // the left icon on the card
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(52, 52),
                  elevation: 0,
                  primary: Colors.red,
                  shape: CircleBorder(
                    side: BorderSide(width: 0, color: Colors.transparent),
                  ),
                ),
                onPressed: null,
                child: const Icon(
                  Icons.close,
                  color: Colors.black45,
                  size: 32,
                ),
              ),
              // the right icon if you want it.
              rightIcon: const Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 32,
              ),
              size: Size(360, 480),
              controller: _controller,
              onForward: (index, info) {
                print(index);
                var offset = 3;
                if (index >= cards.length - offset) {
                  print('loading more...');
                  List<Widget> addCards = List.generate(
                    // generate or load more cards from your server
                  ).toList();
                  setState(() {
                    cards.addAll(addCards);
                  });
                  _controller.append(addCards);// append more cards
                }
              },
              onBack: (index, info) {
                print(index);
              },
              onEnd: () {
                print('end');
              },
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    print(_controller);
                    _controller.back();
                  },
                  child: Text('Back'),
                ),
                OutlineButton(
                  onPressed: () {
                    _controller.reset();
                  },
                  child: Text('Reset'),
                ),
                OutlineButton(
                  onPressed: () {
                    _controller.forward();
                  },
                  child: Text('Forward'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```


### Determine the sliding direction

```dart
 FlashCard(
  cards: cards,
  size: Size(360, 480),
  controller: _controller,
  onForward: (index, info) {
    print(index);
    print(info.direction);
    if (info.direction == SwipeDirection.Right) {
      print('like');
    } else {
      print('dislike');
    }
  },
  onBack: (index, info) {
    print(index);
  },
  onEnd: () {
    print('end');
  },
)
```

![like](./example/like.png)

### Reset with new cards

```dart
List<Widget> newCards = [];

FlashCardController _controller = FlashCardController();

_controller.reset(cards: newCards);
```

## Property

| property      |       type        | default |                                                      description                                                       | required |
| :------------ | :---------------: | :-----: | :--------------------------------------------------------------------------------------------------------------------: | :------: |
| cards         |  `List<Widget>`   | `null`  |                                                      Render cards                                                      |  `true`  |
| size          |      `Size`       | `null`  |                                                       Card size                                                        | `false`  |
| controller    | `FlashCardController` | `null`  |                                                    Card controller                                                     | `false`  |
| onForward     | `ForwardCallback` | `null`  |                                               Forward animation callback                                               | `false`  |
| onBack        |  `BackCallback`   | `null`  |                                                Back animation callback                                                 | `false`  |
| onEnd         |   `EndCallback`   | `null`  |                                                  Forward end callback                                                  | `false`  |
| lockYAxis     |      `bool`       | `false` |                                                  Lock Y Axis Gesture                                                   | `false`  |
| slideSpeed    |     `double`      |  `20`   |                 How quick should it be slided? less is slower. 10 is a bit slow. 20 is a quick enough.                 | `false`  |
| delaySlideFor |       `int`       |  `500`  | How long does it have to wait until the next slide is sliable? less is quicker. 100 is fast enough. 500 is a bit slow. | `false`  |
| leftIcon      |       `Widget`    |  `null` |                            left icon on the card showing when swipe to right                                           | `false`  |
| rightIcon     |       `Widget`    |  `null` |                            right icon on the card showing when swipe to right                                          | `false`  |

## Contribute

1. Fork it (https://github.com/muhammadtalhasultan/flashcard.git)
2. Create your feature branch (git checkout -b feature/foo)
3. Commit your changes (git commit -am 'Add some foo')
4. Push to the branch (git push origin feature/foo)
5. Create a new Pull Request

## License

[MIT](./LICENSE)
