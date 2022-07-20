import 'package:flutter/material.dart';

/// A [StatelessWidget] with some callbacks.
class StatelessWidgetWithCallback extends StatelessWidget {
  /// Creates [StatelessWidgetWithCallback] with non-null [child].
  const StatelessWidgetWithCallback({
    Key? key,
    required this.child,
    this.buildCallback,
    this.postFrameCallback,
  })  : builder = null,
        assert(child != null),
        super(key: key);

  /// Creates [StatelessWidgetWithCallback] with non-null [builder].
  const StatelessWidgetWithCallback.builder({
    Key? key,
    required this.builder,
    this.buildCallback,
    this.postFrameCallback,
  })  : child = null,
        assert(builder != null),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The function which is used to obtain the stateful child widget.
  final WidgetBuilder? builder;

  /// The callback that will be invoked when [State.build] is called.
  final void Function()? buildCallback;

  /// The callback that will be scheduled for the end of this frame.
  final void Function()? postFrameCallback;

  @override
  Widget build(BuildContext context) {
    assert(child != null || builder != null);

    buildCallback?.call();
    if (postFrameCallback != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => postFrameCallback?.call());
    }

    if (child != null) {
      return child!;
    }
    return builder!(context);
  }
}

/// A [StatefulWidget] with some callbacks.
class StatefulWidgetWithCallback extends StatefulWidget {
  /// Creates [StatefulWidgetWithCallback] with non-null [child].
  const StatefulWidgetWithCallback({
    Key? key,
    required this.child,
    this.initStateCallback,
    this.didChangeDependenciesCallback,
    this.didUpdateWidgetCallback,
    this.reassembleCallback,
    this.buildCallback,
    this.activateCallback,
    this.deactivateCallback,
    this.disposeCallback,
    this.permanentFrameCallback,
    this.postFrameCallbackForInitState,
    this.postFrameCallbackForDidChangeDependencies,
    this.postFrameCallbackForDidUpdateWidget,
    this.postFrameCallbackForBuild,
  })  : builder = null,
        assert(child != null),
        super(key: key);

  /// Creates [StatefulWidgetWithCallback] with non-null [builder].
  const StatefulWidgetWithCallback.builder({
    Key? key,
    required this.builder,
    this.initStateCallback,
    this.didChangeDependenciesCallback,
    this.didUpdateWidgetCallback,
    this.reassembleCallback,
    this.buildCallback,
    this.activateCallback,
    this.deactivateCallback,
    this.disposeCallback,
    this.permanentFrameCallback,
    this.postFrameCallbackForInitState,
    this.postFrameCallbackForDidChangeDependencies,
    this.postFrameCallbackForDidUpdateWidget,
    this.postFrameCallbackForBuild,
  })  : child = null,
        assert(builder != null),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The function which is used to obtain the stateful child widget.
  final StatefulWidgetBuilder? builder;

  /// The callback that will be invoked when [State.initState] is called.
  final void Function()? initStateCallback;

  /// The callback that will be invoked when [State.didChangeDependencies] is called.
  final void Function()? didChangeDependenciesCallback;

  /// The callback that will be invoked when [State.didUpdateWidget] is called.
  final void Function()? didUpdateWidgetCallback;

  /// The callback that will be invoked when [State.reassemble] is called.
  final void Function()? reassembleCallback;

  /// The callback that will be invoked when [State.build] is called.
  final void Function()? buildCallback;

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
  State<StatefulWidgetWithCallback> createState() => _StatefulWidgetWithCallbackState();
}

class _StatefulWidgetWithCallbackState extends State<StatefulWidgetWithCallback> {
  @override
  void initState() {
    super.initState();
    widget.initStateCallback?.call();
    if (widget.permanentFrameCallback != null) {
      // Note: Persistent frame callbacks cannot be unregistered.
      // Once registered, they are called for every frame for the
      // lifetime of the application.
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
  void didUpdateWidget(covariant StatefulWidgetWithCallback oldWidget) {
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
    var child = widget.child, builder = widget.builder;
    assert(child != null || builder != null);

    widget.buildCallback?.call();
    if (widget.postFrameCallbackForBuild != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForBuild?.call());
    }

    if (child != null) {
      return child;
    }
    return builder!(context, setState);
  }
}
