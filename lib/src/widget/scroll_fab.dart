import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/action_controller.dart';
import 'package:flutter_ahlib/src/widget/scroll_fab_controller.dart';

/// Used in [_scrollListener] to check if invoked animation.
final _kFabAnimationOffset = 50;

/// Used for [AnimationController] to invoke an animation.
final _kFabAnimationDuration = Duration(milliseconds: 250);

/// A fab that wraps [FloatingActionButton] and includes [ScrollController] and [ScrollFabController].
class ScrollFloatingActionButton extends StatefulWidget {
  const ScrollFloatingActionButton({
    Key key,
    this.fabController,
    this.scrollController,
    @required this.fab,
  })  : assert(fab != null),
        super(key: key);

  /// Scroll fab controller.
  final ScrollFabController fabController;

  /// Scroll controller.
  final ScrollController scrollController;

  /// Content with [FloatingActionButton].
  final FloatingActionButton fab;

  @override
  _ScrollFloatingActionButtonState createState() => _ScrollFloatingActionButtonState();
}

class _ScrollFloatingActionButtonState extends State<ScrollFloatingActionButton> with TickerProviderStateMixin<ScrollFloatingActionButton> {
  bool _showFab = false;
  AnimationController _animController;
  Animation<double> _fabAnimation;
  ActionController _actionController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: _kFabAnimationDuration,
    );
    _fabAnimation = CurvedAnimation(
      parent: _animController,
      curve: Interval(0, 1, curve: Curves.easeOutBack),
    );
    _actionController = ActionController();

    widget.scrollController?.addListener(_scrollListener);
    widget.fabController?.attachAnim(_animController);
    widget.fabController?.attachAction(_actionController);

    _actionController.addAction('addListener', () => widget.scrollController?.addListener(_scrollListener));
    _actionController.addAction('removeListener', () => widget.scrollController?.removeListener(_scrollListener));
  }

  @override
  void dispose() {
    _animController.dispose();
    _actionController.dispose();
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  /// Listener used in [scrollController].
  void _scrollListener() {
    bool scroll = widget.scrollController.offset >= _kFabAnimationOffset;
    if (scroll != _showFab) {
      _showFab = scroll;
      if (scroll) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _fabAnimation,
      alignment: FractionalOffset.center,
      child: widget.fab,
    );
  }
}
