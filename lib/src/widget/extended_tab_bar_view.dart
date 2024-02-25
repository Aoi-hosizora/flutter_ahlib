// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/util/dart_extension.dart';

// Note: This file is based on Flutter's source code, and is modified by AoiHosizora (GitHub: @Aoi-hosizora).
//
// Some code in this file keeps the same as the following source code:
// - TabBarView: https://github.com/flutter/flutter/blob/2.10.5/packages/flutter/lib/src/material/tabs.dart
// - TabBarView: https://github.com/flutter/flutter/blob/3.7.7/packages/flutter/lib/src/material/tabs.dart

/// An extended [TabBarView], which supports [viewportFraction], [clipBehavior] and [padEnds],
/// and the behavior is extended by [warpTabIndex] and [assertForPages].
class ExtendedTabBarView extends StatefulWidget {
  const ExtendedTabBarView({
    Key? key,
    required this.children,
    this.controller,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,

    // <<< The following fields are added by AoiHosizora
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
    this.padEnds = true,
    this.warpTabIndex = true,
    this.assertForPages = true,
  }) : super(key: key);

  final TabController? controller;
  final List<Widget> children;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;

  // <<< The following fields are added by AoiHosizora

  /// The fraction of the viewport that each page should occupy.
  ///
  /// Defaults to 1.0, which means each page fills the viewport in the scrolling direction.
  final double viewportFraction;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// Whether to add padding to both ends of the list.
  ///
  /// If this is set to true and [viewportFraction] < 1.0, padding will be added such that
  /// the first and last child slivers will be in the center of the viewport when scrolled
  /// all the way to the start or end, respectively. If [viewportFraction] >= 1.0, this
  /// property has no effect.
  final bool padEnds;

  /// Whether to warp the index of tab views when index is changing, default to true, which is
  /// the default behavior of builtin [TabBarView].
  final bool warpTabIndex;

  /// Whether to throw assert error when [children] length does not match with [TabController],
  /// default to true.
  ///
  /// Note that the scroll [physics] must be deal with manually if this property is set to false.
  final bool assertForPages;

  @override
  State<ExtendedTabBarView> createState() => ExtendedTabBarViewState();
}

// The class accessibility is modified by AoiHosizora.
/// The state of [ExtendedTabBarView].
class ExtendedTabBarViewState extends State<ExtendedTabBarView> {
  TabController? _controller;
  late PageController _pageController;
  late List<Widget> _children;
  late List<Widget> _childrenWithKey;
  int? _currentIndex;
  int _warpUnderwayCount = 0;

  // This property is added by AoiHosizora.
  /// Returns the current internal [PageController].
  PageController get pageController {
    return _pageController;
  }

  // This property is added by AoiHosizora.
  final _pageControllerListeners = <VoidCallback>[];

  // This method is added by AoiHosizora.
  /// Adds listener to internal [PageController]. Note that you should use this method rather than [PageController.addListener] in order to
  /// make listeners migrate-able when pageController is replaced as viewportFraction is changed.
  void addListenerToPageController(VoidCallback listener) {
    _pageControllerListeners.add(listener);
    pageController.addListener(listener);
  }

  // This method is added by AoiHosizora.
  /// Removes listener to internal [PageController]. Note that you should use this method rather than [PageController.removeListener] in order to
  /// make listeners migrate-able when pageController is replaced as viewportFraction is changed.
  void removeListenerFromPageController(VoidCallback listener) {
    _pageControllerListeners.remove(listener);
    pageController.removeListener(listener);
  }

  // If the TabBarView is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController = widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'TabController using the "controller" property, or you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
    }
  }

  @override
  void initState() {
    super.initState();
    _updateChildren();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
    _currentIndex = _controller!.index;
    _pageController = PageController(
      initialPage: _currentIndex!,
      viewportFraction: widget.viewportFraction /* <<< Added by AoiHosizora */,
    );
  }

  @override
  void didUpdateWidget(ExtendedTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewportFraction != oldWidget.viewportFraction) /* <<< Modified by AoiHosizora */ {
      var oldController = _pageController;
      _pageController = PageController(
        initialPage: _currentIndex!,
        viewportFraction: widget.viewportFraction,
      );
      for (var listen in _pageControllerListeners) {
        _pageController.addListener(listen); // migrate old listeners to new page controller
      }
      ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) => oldController.dispose());
    }
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _currentIndex = _controller!.index;
      _pageController.jumpToPage(_currentIndex!);
    }
    if (widget.children != oldWidget.children && _warpUnderwayCount == 0) {
      _updateChildren();
    }
  }

  @override
  void dispose() {
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
    }
    _controller = null;
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  void _updateChildren() {
    _children = widget.children;
    _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList(widget.children);
  }

  void _handleTabControllerAnimationTick() {
    if (_warpUnderwayCount > 0 || !_controller!.indexIsChanging) {
      return; // This widget is driving the controller's animation.
    }

    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      if (widget.warpTabIndex) /* <<< Modified by AoiHosizora */ {
        // warp tab index, which is the default behavior of builtin TabBarView
        _warpToCurrentIndex();
      } else if (_pageController.page != _currentIndex!.toDouble()) {
        // animate to page directly, which acts the same as builtin PageView
        _pageController.animateToPage(_currentIndex!, duration: _controller!.animationDuration, curve: Curves.ease);
      }
    }
  }

  Future<void> _warpToCurrentIndex() async {
    if (!mounted) {
      return Future<void>.value();
    }

    if (_pageController.page == _currentIndex!.toDouble()) {
      return Future<void>.value();
    }

    final Duration duration = _controller!.animationDuration;

    if (duration == Duration.zero) {
      _pageController.jumpToPage(_currentIndex!);
      return Future<void>.value();
    }

    final int previousIndex = _controller!.previousIndex;

    if ((_currentIndex! - previousIndex).abs() == 1) {
      _warpUnderwayCount += 1;
      await _pageController.animateToPage(_currentIndex!, duration: duration, curve: Curves.ease);
      _warpUnderwayCount -= 1;
      return Future<void>.value();
    }

    assert((_currentIndex! - previousIndex).abs() > 1);
    final int initialPage = _currentIndex! > previousIndex ? _currentIndex! - 1 : _currentIndex! + 1;
    final List<Widget> originalChildren = _childrenWithKey;
    setState(() {
      _warpUnderwayCount += 1;

      _childrenWithKey = List<Widget>.of(_childrenWithKey, growable: false);
      final Widget temp = _childrenWithKey[initialPage];
      _childrenWithKey[initialPage] = _childrenWithKey[previousIndex];
      _childrenWithKey[previousIndex] = temp;
    });
    _pageController.jumpToPage(initialPage);

    await _pageController.animateToPage(_currentIndex!, duration: duration, curve: Curves.ease);
    if (!mounted) {
      return Future<void>.value();
    }
    setState(() {
      _warpUnderwayCount -= 1;
      if (widget.children != _children) {
        _updateChildren();
      } else {
        _childrenWithKey = originalChildren;
      }
    });
  }

  // Called when the PageView scrolls
  bool _handleScrollNotification(ScrollNotification notification) {
    if (_warpUnderwayCount > 0) {
      return false;
    }

    if (notification.depth != 0) {
      return false;
    }

    _warpUnderwayCount += 1;
    if (notification is ScrollUpdateNotification && !_controller!.indexIsChanging) {
      if ((_pageController.page! - _controller!.index).abs() > 1.0) {
        _controller!.index = _pageController.page!.round();
        _currentIndex = _controller!.index;
      }
      _controller!.offset = (_pageController.page! - _controller!.index).clamp(-1.0, 1.0);
    } else if (notification is ScrollEndNotification) {
      _controller!.index = _pageController.page!.round();
      _currentIndex = _controller!.index;
      if (!_controller!.indexIsChanging) {
        _controller!.offset = (_pageController.page! - _controller!.index).clamp(-1.0, 1.0);
      }
    }
    _warpUnderwayCount -= 1;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (widget.assertForPages && _controller!.length != widget.children.length) {
        throw FlutterError(
          "Controller's length property (${_controller!.length}) does not match the "
          "number of tabs (${widget.children.length}) present in TabBar's tabs property.",
        );
      }
      return true;
    }());
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: PageView(
        dragStartBehavior: widget.dragStartBehavior,
        clipBehavior: widget.clipBehavior /* <<< Added by AoiHosizora */,
        controller: _pageController /* <<< Added by AoiHosizora */,
        padEnds: widget.padEnds /* <<< Added by AoiHosizora */,
        physics: widget.physics == null //
            ? const PageScrollPhysics().applyTo(const ClampingScrollPhysics())
            : const PageScrollPhysics().applyTo(widget.physics),
        children: _childrenWithKey,
      ),
    );
  }
}
