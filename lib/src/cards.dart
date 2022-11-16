import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'animations.dart';
import 'controller.dart';
import 'swipe_info.dart';

typedef ForwardCallback = Function(int index, SwipeInfo info);
typedef BackCallback = Function(int index, SwipeInfo info);
typedef EndCallback = Function();

/// card
class FlashCardPlus extends StatefulWidget {
  /// card size
  final Size size;

  /// card list
  final List<Widget> cards;

  final Widget? leftIcon;
  final Widget? rightIcon;

  /// forward callback method
  final ForwardCallback? onForward;

  /// backward callback method
  final BackCallback? onBack;

  /// end callback method
  final EndCallback? onEnd;

  /// card controller
  final FlashCardController? controller;

  /// Control the Y axis
  final bool lockYAxis;

  /// Enable drag and drop
  final bool enableDrag;

  /// forward animation direction
  final SwipeDirection? forwardAnimDirection;

  /// backward animation direction
  final SwipeDirection? backAnimDirection;

  /// How quick should it be slided? less is slower. 10 is a bit slow. 20 is a quick enough.
  final double slideSpeed;

  /// How long does it have to wait until the next slide is sliable? less is quicker. 100 is fast enough. 500 is a bit slow.
  final int delaySlideFor;

  const FlashCardPlus({
    super.key,
    required this.cards,
    this.leftIcon,
    this.rightIcon,
    this.controller,
    this.onForward,
    this.onBack,
    this.onEnd,
    this.lockYAxis = false,
    this.enableDrag = true,
    this.slideSpeed = 20,
    this.delaySlideFor = 500,
    this.size = const Size(380, 400),
    this.forwardAnimDirection,
    this.backAnimDirection,
  }) : assert(cards.length > 0);

  @override
  FlashCardPlusState createState() => FlashCardPlusState();
}

class FlashCardPlusState extends State<FlashCardPlus>
    with TickerProviderStateMixin {
  //  initial card list
  final List<Widget> _cards = [];
  // Card swipe directions
  final List<SwipeInfo> _swipeInfoList = [];
  List<SwipeInfo> get swipeInfoList => _swipeInfoList;

  //  index of frontmost card
  int _frontCardIndex = 0;
  int get frontCardIndex => _frontCardIndex;

  // The position of the frontmost card
  Alignment _frontCardAlignment = CardAlignments.front;
  // The rotation angle of the frontmost card
  double _frontCardRotation = 0.0;
  double _opacity = 0.0;
  // Card Position Transform Animation Controller
  late AnimationController _cardChangeController;
  // Card Position Restoration Animation Controller
  late AnimationController _cardReverseController;
  // Card bounce animation
  late Animation<Alignment> _reboundAnimation;
  // Card bounce animation controller
  late AnimationController _reboundController;
  //  previous card
  Widget _frontCard(BoxConstraints constraints) {
    Widget child =
        _frontCardIndex < _cards.length ? _cards[_frontCardIndex] : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    Widget rotate = Transform.rotate(
      angle: (math.pi / 180.0) * _frontCardRotation,
      child: SizedBox.fromSize(
        size: CardSizes.front(constraints),
        child: Stack(
          children: [
            child,
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: _frontCardRotation > 0 ? _opacity : 0,
                    child: widget.leftIcon,
                  ),
                  // Spacer(),
                  Opacity(
                    opacity: _frontCardRotation < 0 ? _opacity : 0,
                    child: widget.rightIcon,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.frontCardShowAnimation(
                _cardReverseController,
                CardAlignments.front,
                _swipeInfoList[_frontCardIndex],
                widget.backAnimDirection)
            .value,
        child: rotate,
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.frontCardDisappearAnimation(
                _cardChangeController,
                _frontCardAlignment,
                _swipeInfoList[_frontCardIndex],
                widget.forwardAnimDirection)
            .value,
        child: rotate,
      );
    } else {
      return Align(
        alignment: _frontCardAlignment,
        child: rotate,
      );
    }
  }

  // middle card
  Widget _middleCard(BoxConstraints constraints) {
    Widget child = _frontCardIndex < _cards.length - 1
        ? _cards[_frontCardIndex + 1]
        : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.middleCardAlignmentAnimation(
          _cardReverseController,
        ).value,
        child: SizedBox.fromSize(
          size: CardReverseAnimations.middleCardSizeAnimation(
            _cardReverseController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.middleCardAlignmentAnimation(
          _cardChangeController,
        ).value,
        child: SizedBox.fromSize(
          size: CardAnimations.middleCardSizeAnimation(
            _cardChangeController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else {
      return Align(
        alignment: CardAlignments.middle,
        child: SizedBox.fromSize(
          size: CardSizes.middle(constraints),
          child: child,
        ),
      );
    }
  }

  // back card
  Widget _backCard(BoxConstraints constraints) {
    Widget child = _frontCardIndex < _cards.length - 2
        ? _cards[_frontCardIndex + 2]
        : Container();
    bool forward = _cardChangeController.status == AnimationStatus.forward;
    bool reverse = _cardReverseController.status == AnimationStatus.forward;

    if (reverse) {
      return Align(
        alignment: CardReverseAnimations.backCardAlignmentAnimation(
          _cardReverseController,
        ).value,
        child: SizedBox.fromSize(
          size: CardReverseAnimations.backCardSizeAnimation(
            _cardReverseController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else if (forward) {
      return Align(
        alignment: CardAnimations.backCardAlignmentAnimation(
          _cardChangeController,
        ).value,
        child: SizedBox.fromSize(
          size: CardAnimations.backCardSizeAnimation(
            _cardChangeController,
            constraints,
          ).value,
          child: child,
        ),
      );
    } else {
      return Align(
        alignment: CardAlignments.back,
        child: SizedBox.fromSize(
          size: CardSizes.back(constraints),
          child: child,
        ),
      );
    }
  }

  // Determine whether animation is in progress
  bool _isAnimating() {
    return _cardChangeController.status == AnimationStatus.forward ||
        _cardReverseController.status == AnimationStatus.forward;
  }

  // Run card bounce animation
  void _runReboundAnimation(Offset pixelsPerSecond, Size size) {
    _reboundAnimation = _reboundController.drive(
      AlignmentTween(
        begin: _frontCardAlignment,
        end: CardAlignments.front,
      ),
    );

    final double unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final double unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;
    const spring = SpringDescription(mass: 30.0, stiffness: 1.0, damping: 1.0);
    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _reboundController.animateWith(simulation);
    _resetFrontCard();
  }

  // Run card forward animation
  void _runChangeOrderAnimation() {
    if (_isAnimating()) {
      return;
    }

    if (_frontCardIndex >= _cards.length) {
      return;
    }

    _cardChangeController.reset();
    _cardChangeController.forward();
  }

  get runChangeOrderAnimation => _runChangeOrderAnimation;

  // Run card back animation
  void _runReverseOrderAnimation() {
    if (_isAnimating()) {
      return;
    }

    if (_frontCardIndex == 0) {
      _swipeInfoList.clear();
      return;
    }

    _cardReverseController.reset();
    _cardReverseController.forward();
  }

  get runReverseOrderAnimation => _runReverseOrderAnimation;

  // Executed after the forward animation completes
  void _forwardCallback() {
    _frontCardIndex++;
    _resetFrontCard();
    if (widget.onForward != null && widget.onForward is Function) {
      widget.onForward!(
        _frontCardIndex,
        _swipeInfoList[_frontCardIndex - 1],
      );
    }

    if (widget.onEnd != null &&
        widget.onEnd is Function &&
        _frontCardIndex >= _cards.length) {
      widget.onEnd!();
    }
  }

  // Back animation callback
  void _backCallback() {
    _resetFrontCard();
    _swipeInfoList.removeLast();
    if (widget.onBack != null && widget.onBack is Function) {
      int index = _frontCardIndex > 0 ? _frontCardIndex - 1 : 0;
      SwipeInfo info = _swipeInfoList.isNotEmpty
          ? _swipeInfoList[index]
          : SwipeInfo(-1, SwipeDirection.none);

      widget.onBack!(_frontCardIndex, info);
    }
  }

  // Reset the position of the frontmost card
  void _resetFrontCard() {
    _frontCardRotation = 0.0;
    _opacity = 0.0;
    _frontCardAlignment = CardAlignments.front;
    setState(() {});
  }

  // reset all cards
  void reset({List<Widget>? cards}) {
    _cards.clear();
    if (cards != null) {
      _cards.addAll(cards);
    } else {
      _cards.addAll(widget.cards);
    }
    _swipeInfoList.clear();
    _frontCardIndex = 0;
    _resetFrontCard();
  }

  // add card
  void append(List<Widget> cards) {
    _cards.addAll(cards);
  }

  // Stop animations
  void _stop() {
    _reboundController.stop();
    _cardChangeController.stop();
    _cardReverseController.stop();
  }

  // Update the position of the frontmost card
  void _updateFrontCardAlignment(DragUpdateDetails details, Size size) {
    // Card movement speed widget.slideSpeed
    _frontCardAlignment += Alignment(
      details.delta.dx / (size.width / 2) * widget.slideSpeed,
      widget.lockYAxis
          ? 0
          : details.delta.dy / (size.height / 2) * widget.slideSpeed,
    );

    // Set the rotation angle of the frontmost card
    _frontCardRotation = _frontCardAlignment.x;
    _opacity = math.min((_frontCardRotation / 10).abs() * 1.2, 1);
    setState(() {});
  }

  // Determine whether to animate
  void _judgeRunAnimation(DragEndDetails details, Size size) {
    // Card horizontal axis distance limit
    const double limit = 10.0;
    final bool isSwipeLeft = _frontCardAlignment.x < -limit;
    final bool isSwipeRight = _frontCardAlignment.x > limit;

    // Determine whether to run forward animation, otherwise rebound
    if (isSwipeLeft || isSwipeRight) {
      _runChangeOrderAnimation();
      if (isSwipeLeft) {
        _swipeInfoList.add(SwipeInfo(_frontCardIndex, SwipeDirection.left));
      } else {
        _swipeInfoList.add(SwipeInfo(_frontCardIndex, SwipeDirection.right));
      }
    } else {
      _runReboundAnimation(details.velocity.pixelsPerSecond, size);
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize all incoming cards
    _cards.addAll(widget.cards);

    // bind controller
    if (widget.controller != null && widget.controller is FlashCardController) {
      widget.controller!.bindState(this);
    }

    // Initialize the forward animation controller
    _cardChangeController = AnimationController(
      duration: Duration(milliseconds: widget.delaySlideFor),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _forwardCallback();
        }
      });

    // Initialize the backward animation controller
    _cardReverseController = AnimationController(
      duration: Duration(milliseconds: widget.delaySlideFor),
      vsync: this,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          _frontCardIndex--;
        } else if (status == AnimationStatus.completed) {
          _backCallback();
        }
      });

    // Initialize the animation controller for the bounce
    _reboundController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.delaySlideFor),
    )..addListener(() {
        setState(() {
          _frontCardAlignment = _reboundAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _cardReverseController.dispose();
    _cardChangeController.dispose();
    _reboundController.dispose();
    if (widget.controller != null) {
      widget.controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: widget.size,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          /// Use LayoutBuilder to get the size of the container, pass a sub-item to calculate the size of the card
          final Size size = MediaQuery.of(context).size;

          return Stack(
            children: <Widget>[
              _backCard(constraints),
              _middleCard(constraints),
              _frontCard(constraints),

              /// Use a SizedBox to cover the entire area of the parent element
              widget.enableDrag &&
                      _cardChangeController.status != AnimationStatus.forward
                  ? SizedBox.expand(
                      child: GestureDetector(
                        onPanDown: (DragDownDetails details) {
                          _stop();
                        },
                        onPanUpdate: (DragUpdateDetails details) {
                          _updateFrontCardAlignment(details, size);
                        },
                        onPanEnd: (DragEndDetails details) {
                          _judgeRunAnimation(details, size);
                        },
                      ),
                    )
                  : const IgnorePointer(),
            ],
          );
        },
      ),
    );
  }
}
