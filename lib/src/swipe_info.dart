enum SwipeDirection {
  left,
  right,
  none,
}

class SwipeInfo {
  final int cardIndex;
  final SwipeDirection direction;

  SwipeInfo(
    this.cardIndex,
    this.direction,
  );
}
