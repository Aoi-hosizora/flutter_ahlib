import 'package:flutter/material.dart';

/// A state used to describe the current state of [PlaceholderText].
enum PlaceholderState {
  normal, // !isEmpty
  loading, // isLoading
  nothing, // errorText != null && errorText.isNotEmpty
  error, // isEmpty
}

/// [PlaceholderState] changed callback function, used in [PlaceholderText].
typedef PlaceholderStateChangedCallback = void Function(PlaceholderState);

/// Setting for displaying [PlaceholderText].
class PlaceholderSetting {
  const PlaceholderSetting({
    this.loadingText,
    this.nothingText,
    this.retryText,
    this.showProgress,
    this.textStyle,
    this.iconSize,
    this.progressSize,
    this.textPadding,
    this.iconPadding,
    this.buttonPadding,
    this.progressPadding,
  });

  /// Text for loading.
  final String loadingText;

  /// Text for empty list.
  final String nothingText;

  /// Text for retry button.
  final String retryText;

  /// Show progress or not when loading.
  final bool showProgress;

  /// Text style for plain texts.
  final TextStyle textStyle;

  /// Size of icons.
  final double iconSize;

  /// Size of progress when loading.
  final double progressSize;

  /// Padding around text.
  final EdgeInsets textPadding;

  /// Padding around icon.
  final EdgeInsets iconPadding;

  /// Padding around button.
  final EdgeInsets buttonPadding;

  /// Padding around progress when loading.
  final EdgeInsets progressPadding;
}

/// Placeholder text used for mainly [ListView], include loading, nothing, error.
///
/// Handle logic order:
///   `normal` (!isEmpty) ->
///   `loading` (isLoading) ->
///   `error` (errorText != null) ->
///   `nothing` (else).
class PlaceholderText extends StatefulWidget {
  const PlaceholderText({
    Key key,
    @required this.childBuilder,
    this.onRefresh,
    this.errorText,
    @required this.state,
    this.onChanged,
    this.setting,
  })  : assert(childBuilder != null),
        assert(state != null),
        super(key: key);

  PlaceholderText.from({
    Key key,
    @required Widget Function(BuildContext) childBuilder,
    void Function() onRefresh,
    String errorText,
    @required bool isEmpty,
    @required bool isLoading,
    PlaceholderStateChangedCallback onChanged,
    PlaceholderSetting setting,
  }) : this(
          key: key,
          childBuilder: childBuilder,
          onRefresh: onRefresh,
          errorText: errorText,
          state: !isEmpty // check if it has data first
              ? PlaceholderState.normal
              : isLoading // empty, check if is loading
                  ? PlaceholderState.loading
                  : errorText?.isNotEmpty == true // loaded, check if error message is empty
                      ? PlaceholderState.error
                      : PlaceholderState.nothing,
          // empty, loaded, noerr -> nothing
          onChanged: onChanged,
          setting: setting,
        );

  /// Builder for child.
  final Widget Function(BuildContext) childBuilder;

  /// Refresh event for retry.
  final void Function() onRefresh;

  /// Error message, can be empty or null.
  final String errorText;

  /// Placeholder's current state.
  final PlaceholderState state;

  /// Callback when [state] changed.
  final PlaceholderStateChangedCallback onChanged;

  /// Display setting for [PlaceholderText].
  final PlaceholderSetting setting;

  @override
  _PlaceholderTextState createState() => _PlaceholderTextState();
}

class _PlaceholderTextState extends State<PlaceholderText> {
  /// Store the last state, used to check onChanged event.
  PlaceholderState _lastState;

  @override
  void initState() {
    super.initState();
    _lastState = widget.state;
  }

  @override
  Widget build(BuildContext context) {
    if (_lastState != null && _lastState != widget.state) {
      widget.onChanged?.call(widget.state);
      _lastState = widget.state;
    }

    var textStyle = widget.setting?.textStyle ?? TextStyle(fontSize: Theme.of(context).textTheme.headline6.fontSize);
    var iconSize = widget.setting?.iconSize ?? 50;
    var progressSize = widget.setting?.progressSize ?? 40;
    var textPadding = widget.setting?.textPadding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 5);
    var iconPadding = widget.setting?.iconPadding ?? EdgeInsets.all(5);
    var buttonPadding = widget.setting?.buttonPadding ?? EdgeInsets.all(5);
    var progressPadding = widget.setting?.progressPadding ?? EdgeInsets.all(30);

    switch (widget.state) {
      ////////////////////////////////////////////////////////////////
      // normal
      case PlaceholderState.normal:
        return widget.childBuilder(context);
      ////////////////////////////////////////////////////////////////
      // loading
      case PlaceholderState.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.setting?.showProgress == true
                  ? Padding(
                      padding: progressPadding,
                      child: SizedBox(
                        height: progressSize,
                        width: progressSize,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(height: 0),
              Padding(
                padding: textPadding,
                child: Text(
                  widget.setting?.loadingText ?? 'Loading...',
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ),
            ],
          ),
        );
      ////////////////////////////////////////////////////////////////
      // nothing
      case PlaceholderState.nothing:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: iconPadding,
                child: Icon(
                  Icons.clear_all,
                  size: iconSize,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: textPadding,
                child: Text(
                  widget.setting?.nothingText ?? 'Nothing',
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ),
              Padding(
                padding: buttonPadding,
                child: OutlineButton(
                  child: Text(
                    widget.setting?.retryText ?? 'Retry',
                  ),
                  onPressed: () {
                    widget.onRefresh?.call();
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      ////////////////////////////////////////////////////////////////
      // error
      case PlaceholderState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: iconPadding,
                child: Icon(
                  Icons.error,
                  size: iconSize,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: textPadding,
                child: Text(
                  widget.errorText?.isNotEmpty == true ? widget.errorText : 'Unknown',
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ),
              Padding(
                padding: buttonPadding,
                child: OutlineButton(
                  child: Text(
                    widget.setting?.retryText ?? 'Retry',
                  ),
                  onPressed: () {
                    widget.onRefresh?.call();
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      ////////////////////////////////////////////////////////////////
      // unreachable
      default:
        return SizedBox(height: 0);
    }
  }
}
