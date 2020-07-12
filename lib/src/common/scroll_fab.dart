import 'package:flutter_ahlib/src/common/action_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/common/scroll_fab_controller.dart';

/// A fab which include scroll animation, which use `ScrollController` and register `ScrollFabController`
class ScrollFloatingActionButton extends StatefulWidget {
  const ScrollFloatingActionButton({
    Key key,
    this.fabController,
    this.scrollController,
    @required this.fab,
  })  : assert(fab != null),
        super(key: key);

  final ScrollFabController fabController;
  final ScrollController scrollController;
  final Widget fab;

  @override
  _ScrollFloatingActionButtonState createState() => _ScrollFloatingActionButtonState();
}

class _ScrollFloatingActionButtonState extends State<ScrollFloatingActionButton>
    with TickerProviderStateMixin<ScrollFloatingActionButton> {
  bool _showFab = false;
  AnimationController _animeController;
  Animation<double> _fabAnimation;
  final _kFabAnimationOffset = 50;
  final _kFabAnimationDuration = Duration(milliseconds: 250);
  ActionController _actionController;

  @override
  void initState() {
    super.initState();
    _animeController = AnimationController(
      vsync: this,
      duration: _kFabAnimationDuration,
    );
    _fabAnimation = CurvedAnimation(
      parent: _animeController,
      curve: Interval(0, 1, curve: Curves.easeOutBack),
    );
    _actionController = ActionController();

    widget.scrollController?.addListener(_scrollListener);
    widget.fabController?.attach(_animeController);
    widget.fabController?.attachAction(_actionController);

    _actionController.addAction('addListener', () => widget.scrollController?.addListener(_scrollListener));
    _actionController.addAction('removeListener', () => widget.scrollController?.removeListener(_scrollListener));
  }

  @override
  void dispose() {
    _animeController.dispose();
    _actionController.dispose();
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    bool scroll = widget.scrollController.offset >= _kFabAnimationOffset;
    if (scroll != _showFab) {
      _showFab = scroll;
      if (scroll) {
        _animeController.forward();
      } else {
        _animeController.reverse();
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
