import 'package:flutter/material.dart';

/// A [Builder] with some callbacks.
class StatelessBuilderWithCallback extends StatelessWidget {
  const StatelessBuilderWithCallback({
    Key? key,
    required this.builder,
    this.postFrameCallback,
  }) : super(key: key);

  /// The function which is used to obtain the stateful child widget.
  final WidgetBuilder builder;

  /// The callback that will be scheduled for the end of this frame.
  final void Function()? postFrameCallback;

  @override
  Widget build(BuildContext context) {
    if (postFrameCallback != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => postFrameCallback?.call()); // TODO
    }
    return builder(context);
  }
}

/// A [StatefulBuilder] with some callbacks.
class StatefulBuilderWithCallback extends StatefulWidget {
  const StatefulBuilderWithCallback({
    Key? key,
    required this.builder,
    this.initStateCallback,
    this.didChangeDependenciesCallback,
    this.didUpdateWidgetCallback,
    this.reassembleCallback,
    this.activateCallback,
    this.deactivateCallback,
    this.disposeCallback,
    this.permanentFrameCallback,
    this.postFrameCallbackForInitState,
    this.postFrameCallbackForDidChangeDependencies,
    this.postFrameCallbackForDidUpdateWidget,
    this.postFrameCallbackForBuild,
  }) : super(key: key);

  /// The function which is used to obtain the stateful child widget.
  final StatefulWidgetBuilder builder;

  /// The callback that will be invoked when [State.initState] is called.
  final void Function()? initStateCallback;

  /// The callback that will be invoked when [State.didChangeDependencies] is called.
  final void Function()? didChangeDependenciesCallback;

  /// The callback that will be invoked when [State.didUpdateWidget] is called.
  final void Function()? didUpdateWidgetCallback;

  /// The callback that will be invoked when [State.reassemble] is called.
  final void Function()? reassembleCallback;

  /// The callback that will be invoked when [State.activate] is called.
  final void Function()? activateCallback;

  /// The callback that will be invoked when [State.deactivate] is called.
  final void Function()? deactivateCallback;

  /// The callback that will be invoked when [State.dispose] is called.
  final void Function()? disposeCallback;

  /// The callback that will be scheduled for the end of each frame, which will be
  /// called after postFrameCallback.
  final void Function()? permanentFrameCallback;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.initState].
  final void Function()? postFrameCallbackForInitState;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.didChangeDependencies].
  final void Function()? postFrameCallbackForDidChangeDependencies;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.didUpdateWidget].
  final void Function()? postFrameCallbackForDidUpdateWidget;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.build].
  final void Function()? postFrameCallbackForBuild;

  @override
  State<StatefulBuilderWithCallback> createState() => _StatefulBuilderWithCallbackState();
}

class _StatefulBuilderWithCallbackState extends State<StatefulBuilderWithCallback> {
  @override
  void initState() {
    super.initState();
    widget.initStateCallback?.call();
    if (widget.permanentFrameCallback != null) {
      WidgetsBinding.instance?.addPersistentFrameCallback((_) => widget.permanentFrameCallback?.call());
    }
    if (widget.postFrameCallbackForInitState != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForInitState?.call());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependenciesCallback?.call();
    if (widget.postFrameCallbackForDidChangeDependencies != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForDidChangeDependencies?.call());
    }
  }

  @override
  void didUpdateWidget(covariant StatefulBuilderWithCallback oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidgetCallback?.call();
    if (widget.postFrameCallbackForDidUpdateWidget != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForDidUpdateWidget?.call());
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.reassembleCallback?.call();
  }

  @override
  void activate() {
    super.activate();
    widget.activateCallback?.call();
  }

  @override
  void deactivate() {
    widget.deactivateCallback?.call();
    super.deactivate();
  }

  @override
  void dispose() {
    widget.disposeCallback?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postFrameCallbackForBuild != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForBuild?.call()); // TODO
    }
    return widget.builder(context, setState);
  }
}
