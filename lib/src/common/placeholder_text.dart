import 'package:flutter/material.dart';

/// `normal` : `!isEmpty`,
/// `loading` : `isLoading`,
/// `error` : `errorText != null && errorText.isNotEmpty`,
/// `empty` : `isEmpty`
enum PlaceholderState {
  normal,
  loading,
  nothing,
  error,
}

/// Placeholder state changed callback function, used in `PlaceholderText`
typedef PlaceholderStateChangedCallback = void Function(PlaceholderState);

/// Setting for `PlaceholderText` display text and progress
class PlaceholderSetting {
  const PlaceholderSetting({
    this.loadingText,
    this.nothingText,
    this.retryText,
    this.showProgress,
    this.progressSize,
  });

  final String loadingText;
  final String nothingText;
  final String retryText;
  final bool showProgress;
  final double progressSize;
}

/// Placeholder text used for mainly `ListView`,
/// Order: `normal` (!isEmpty) -> `loading` (isLoading) -> `error` (errorText != null) -> `nothing` (else)
class PlaceholderText extends StatefulWidget {
  const PlaceholderText({
    Key key,
    @required this.childBuilder,
    this.onRefresh,
    @required this.state,
    this.errorText,
    this.onChanged,
    this.setting,
  })  : assert(childBuilder != null),
        assert(state != null),
        super(key: key);

  PlaceholderText.from({
    @required Widget Function(BuildContext) childBuilder,
    void Function() onRefresh,
    String errorText,
    @required bool isEmpty,
    @required bool isLoading,
    PlaceholderStateChangedCallback onChanged,
    PlaceholderSetting setting,
  }) : this(
          childBuilder: childBuilder,
          onRefresh: onRefresh,
          state: !isEmpty
              ? PlaceholderState.normal
              : isLoading
                  ? PlaceholderState.loading
                  : errorText != null && errorText.isNotEmpty ? PlaceholderState.error : PlaceholderState.nothing,
          errorText: errorText,
          onChanged: onChanged,
          setting: setting,
        );

  final Widget Function(BuildContext) childBuilder;
  final void Function() onRefresh;
  final PlaceholderState state;
  final String errorText;
  final PlaceholderStateChangedCallback onChanged;
  final PlaceholderSetting setting;

  @override
  _PlaceholderTextState createState() => _PlaceholderTextState();
}

class _PlaceholderTextState extends State<PlaceholderText> {
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

    switch (widget.state) {
      case PlaceholderState.normal:
        return widget.childBuilder(context);
      case PlaceholderState.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.setting?.showProgress ?? false
                  ? Padding(
                      padding: EdgeInsets.all(30),
                      child: SizedBox(
                        height: widget.setting?.progressSize ?? 40,
                        width: widget.setting?.progressSize ?? 40,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(height: 0),
              Text(
                widget.setting?.loadingText ?? 'Loading...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                ),
              ),
            ],
          ),
        );
      case PlaceholderState.nothing:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.clear_all,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  widget.setting?.nothingText ?? 'Nothing',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: OutlineButton(
                  child: Text(widget.setting?.retryText ?? 'Retry'),
                  onPressed: () {
                    widget.onRefresh?.call();
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      case PlaceholderState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  widget.errorText ?? 'Unknown',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: OutlineButton(
                  child: Text(widget.setting?.retryText ?? 'Retry'),
                  onPressed: () {
                    widget.onRefresh?.call();
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      default:
        return SizedBox(height: 0);
    }
  }
}
