import 'package:flutter/material.dart';

/// A [StatelessWidget] with some callbacks.
class StatelessWidgetWithCallback extends StatelessWidget {
  /// Creates [StatelessWidgetWithCallback] with non-null [child].
  const StatelessWidgetWithCallback({
    Key? key,
    required Widget this.child,
    this.buildCallback,
    this.postFrameCallback,
  })  : builder = null,
        super(key: key);

  /// Creates [StatelessWidgetWithCallback] with non-null [builder].
  const StatelessWidgetWithCallback.builder({
    Key? key,
    required WidgetBuilder this.builder,
    this.buildCallback,
    this.postFrameCallback,
  })  : child = null,
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The function which is used to obtain the stateful child widget.
  final WidgetBuilder? builder;

  /// The callback that will be invoked when [State.build] is called.
  final void Function(BuildContext context)? buildCallback;

  /// The callback that will be scheduled for the end of this frame.
  final void Function(BuildContext context)? postFrameCallback;

  @override
  Widget build(BuildContext context) {
    assert(child != null || builder != null);

    buildCallback?.call(context);
    if (postFrameCallback != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => postFrameCallback?.call(context));
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
    required Widget this.child,
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
        super(key: key);

  /// Creates [StatefulWidgetWithCallback] with non-null [builder].
  const StatefulWidgetWithCallback.builder({
    Key? key,
    required StatefulWidgetBuilder this.builder,
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
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The function which is used to obtain the stateful child widget.
  final StatefulWidgetBuilder? builder;

  /// The callback that will be invoked when [State.initState] is called.
  final void Function(BuildContext context, StateSetter setState)? initStateCallback;

  /// The callback that will be invoked when [State.didChangeDependencies] is called.
  final void Function(BuildContext context, StateSetter setState)? didChangeDependenciesCallback;

  /// The callback that will be invoked when [State.didUpdateWidget] is called.
  final void Function(BuildContext context, StateSetter setState)? didUpdateWidgetCallback;

  /// The callback that will be invoked when [State.reassemble] is called.
  final void Function(BuildContext context, StateSetter setState)? reassembleCallback;

  /// The callback that will be invoked when [State.build] is called.
  final void Function(BuildContext context, StateSetter setState)? buildCallback;

  /// The callback that will be invoked when [State.activate] is called.
  final void Function(BuildContext context, StateSetter setState)? activateCallback;

  /// The callback that will be invoked when [State.deactivate] is called.
  final void Function(BuildContext context, StateSetter setState)? deactivateCallback;

  /// The callback that will be invoked when [State.dispose] is called.
  final void Function(BuildContext context, StateSetter setState)? disposeCallback;

  /// The callback that will be scheduled for the end of each frame, which will be
  /// called after postFrameCallback.
  final void Function(BuildContext context, StateSetter setState)? permanentFrameCallback;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.initState].
  final void Function(BuildContext context, StateSetter setState)? postFrameCallbackForInitState;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.didChangeDependencies].
  final void Function(BuildContext context, StateSetter setState)? postFrameCallbackForDidChangeDependencies;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.didUpdateWidget].
  final void Function(BuildContext context, StateSetter setState)? postFrameCallbackForDidUpdateWidget;

  /// The callback that will be scheduled for the end of this frame, which will be
  /// added when [State.build].
  final void Function(BuildContext context, StateSetter setState)? postFrameCallbackForBuild;

  @override
  State<StatefulWidgetWithCallback> createState() => _StatefulWidgetWithCallbackState();
}

class _StatefulWidgetWithCallbackState extends State<StatefulWidgetWithCallback> {
  void _stateSetter(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.initStateCallback?.call(context, _stateSetter);
    if (widget.permanentFrameCallback != null) {
      // Note: Persistent frame callbacks cannot be unregistered.
      // Once registered, they are called for every frame for the
      // lifetime of the application.
      WidgetsBinding.instance?.addPersistentFrameCallback((_) => widget.permanentFrameCallback?.call(context, _stateSetter));
    }
    if (widget.postFrameCallbackForInitState != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForInitState?.call(context, _stateSetter));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependenciesCallback?.call(context, _stateSetter);
    if (widget.postFrameCallbackForDidChangeDependencies != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForDidChangeDependencies?.call(context, _stateSetter));
    }
  }

  @override
  void didUpdateWidget(covariant StatefulWidgetWithCallback oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidgetCallback?.call(context, _stateSetter);
    if (widget.postFrameCallbackForDidUpdateWidget != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForDidUpdateWidget?.call(context, _stateSetter));
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.reassembleCallback?.call(context, _stateSetter);
  }

  @override
  void activate() {
    super.activate();
    widget.activateCallback?.call(context, _stateSetter);
  }

  @override
  void deactivate() {
    widget.deactivateCallback?.call(context, _stateSetter);
    super.deactivate();
  }

  @override
  void dispose() {
    widget.disposeCallback?.call(context, _stateSetter);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.child, builder = widget.builder;
    assert(child != null || builder != null);

    widget.buildCallback?.call(context, _stateSetter);
    if (widget.postFrameCallbackForBuild != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.postFrameCallbackForBuild?.call(context, _stateSetter));
    }

    if (child != null) {
      return child;
    }
    return builder!(context, _stateSetter);
  }
}
