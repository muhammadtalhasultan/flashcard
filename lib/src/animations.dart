import 'package:flutter/material.dart';

import 'swipe_info.dart';

/// Card Sizes
class CardSizes {
  static Size front(BoxConstraints constraints) {
    return Size(constraints.maxWidth * 0.9, constraints.maxHeight * 0.9);
  }

  static Size middle(BoxConstraints constraints) {
    return Size(constraints.maxWidth * 0.85, constraints.maxHeight * 0.9);
  }

  static Size back(BoxConstraints constraints) {
    return Size(constraints.maxWidth * 0.8, constraints.maxHeight * .9);
  }
}

/// Card Alignments
class CardAlignments {
  static Alignment front = const Alignment(0.0, -0.5);
  static Alignment middle = const Alignment(0.0, 0.0);
  static Alignment back = const Alignment(0.0, 0.5);
}

/// Card Forward Animations
class CardAnimations {
  /// Disappearing animation of the frontmost card
  static Animation<Alignment> frontCardDisappearAnimation(
      AnimationController parent,
      Alignment beginAlignment,
      SwipeInfo info,
      SwipeDirection? swipeDirection) {
    return AlignmentTween(
      begin: beginAlignment,
      end: Alignment(
        (swipeDirection ?? info.direction) == SwipeDirection.left
            ? beginAlignment.x - 30.0
            : beginAlignment.x + 30.0,
        0.0,
      ),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// Middle card position transformation animation
  static Animation<Alignment> middleCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.middle,
      end: CardAlignments.front,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// Middle card size transformation animation
  static Animation<Size?> middleCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.middle(constraints),
      end: CardSizes.front(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// The last card position transformation animation
  static Animation<Alignment> backCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.back,
      end: CardAlignments.middle,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  /// The last card size transformation animation
  static Animation<Size?> backCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.back(constraints),
      end: CardSizes.middle(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }
}

/// Card Backward Animations
class CardReverseAnimations {
  /// Appearance animation of the frontmost card
  static Animation<Alignment> frontCardShowAnimation(AnimationController parent,
      Alignment endAlignment, SwipeInfo info, SwipeDirection? swipeDirection) {
    return AlignmentTween(
      begin: Alignment(
        (swipeDirection ?? info.direction) == SwipeDirection.left
            ? endAlignment.x - 30.0
            : endAlignment.x + 30.0,
        0.0,
      ),
      end: endAlignment,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// Middle card position transformation animation
  static Animation<Alignment> middleCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.front,
      end: CardAlignments.middle,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// Middle card size transformation animation
  static Animation<Size?> middleCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.front(constraints),
      end: CardSizes.middle(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  /// The last card position transformation animation
  static Animation<Alignment> backCardAlignmentAnimation(
    AnimationController parent,
  ) {
    return AlignmentTween(
      begin: CardAlignments.middle,
      end: CardAlignments.back,
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }

  /// The last card size transformation animation
  static Animation<Size?> backCardSizeAnimation(
    AnimationController parent,
    BoxConstraints constraints,
  ) {
    return SizeTween(
      begin: CardSizes.middle(constraints),
      end: CardSizes.back(constraints),
    ).animate(
      CurvedAnimation(
        parent: parent,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );
  }
}
