import 'package:flutter/material.dart';
import 'package:flutter_ahlib/src/list/type.dart';

/// `normal`: !isEmpty
///
/// `loading`: isLoading
/// 
/// `error`: errorText != null && errorText.isNotEmpty
/// 
/// `empty`: isEmpty
enum PlaceholderState {
  normal,
  loading,
  nothing,
  error,
}

class ListPlaceholderSetting {
  const ListPlaceholderSetting({
    this.loadingText,
    this.nothingText,
    this.retryText,
  });

  final String loadingText;
  final String nothingText;
  final String retryText;
}

class ListPlaceholderText extends StatefulWidget {
  const ListPlaceholderText({
    Key key,
    @required this.child,
    @required this.onRefresh,
    @required this.state,
    this.errorText,
    this.onChanged,
    this.placeholderText,
  })  : assert(child != null),
        assert(state != null),
        super(key: key);

  ListPlaceholderText.from({
    @required Widget child,
    @required void Function() onRefresh,
    String errorText,
    @required bool isEmpty,
    @required bool isLoading,
    StateChangedCallback onChanged,
    ListPlaceholderSetting placeholderText,
  }) : this(
          child: child,
          onRefresh: onRefresh,
          state: !isEmpty
              ? PlaceholderState.normal
              : isLoading
                  ? PlaceholderState.loading
                  : errorText != null && errorText.isNotEmpty ? PlaceholderState.error : PlaceholderState.nothing,
          errorText: errorText,
          onChanged: onChanged,
          placeholderText: placeholderText,
        );

  final Widget child;
  final void Function() onRefresh;
  final PlaceholderState state;
  final String errorText;
  final StateChangedCallback onChanged;
  final ListPlaceholderSetting placeholderText;

  @override
  _ListPlaceholderTextState createState() => _ListPlaceholderTextState();
}

class _ListPlaceholderTextState extends State<ListPlaceholderText> {
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
        return widget.child;
      case PlaceholderState.loading:
        return Center(
          child: Text(
            widget.placeholderText?.loadingText ?? 'Loading...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
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
                  widget.placeholderText?.nothingText ?? 'Nothing',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: OutlineButton(
                  child: Text(widget.placeholderText?.retryText ?? 'Retry'),
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
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: OutlineButton(
                  child: Text(widget.placeholderText?.retryText ?? 'Retry'),
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
        return null;
    }
  }
}
