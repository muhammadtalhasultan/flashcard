import 'dart:math';

import 'cards.dart';
import 'swipe_info.dart';

/// Card controller
class FlashCardController {
  FlashCardPlusState? state;

  void bindState(FlashCardPlusState state) {
    this.state = state;
  }

  int get index => state?.frontCardIndex ?? 0;

  forward({SwipeDirection? direction}) {
    direction ??=
        Random().nextBool() ? SwipeDirection.left : SwipeDirection.right;

    state!.swipeInfoList.add(SwipeInfo(state!.frontCardIndex, direction));
    state!.runChangeOrderAnimation();
  }

  back() {
    state!.runReverseOrderAnimation();
  }

  get reset => state!.reset;

  get append => state!.append;

  void dispose() {
    state = null;
  }
}
