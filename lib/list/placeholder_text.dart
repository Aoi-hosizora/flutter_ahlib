import 'package:flutter/material.dart';

/// `normal`: !isEmpty
/// `loading`: isLoading
/// `error`: errorText != null && errorText.isNotEmpty
/// `empty`: isEmpty
enum PlaceHolderState {
  normal,
  loading,
  nothing,
  error,
}

typedef StateChangedCallback = void Function(PlaceHolderState);

class ListPlaceHolderText extends StatefulWidget {
  const ListPlaceHolderText({
    Key key,
    @required this.child,
    @required this.onRefresh,
    @required this.state,
    this.errorText,
    this.onChanged,
    // text
    this.loadingText,
    this.nothingText,
    this.retryText,
  })  : assert(child != null),
        assert(state != null),
        super(key: key);

  ListPlaceHolderText.from({
    @required Widget child,
    @required void Function() onRefresh,
    String errorText,
    @required bool isEmpty,
    @required bool isLoading,
    StateChangedCallback onChanged,
    // text
    String loadingText,
    String nothingText,
    String retryText,
  }) : this(
          child: child,
          onRefresh: onRefresh,
          state: !isEmpty
              ? PlaceHolderState.normal
              : isLoading
                  ? PlaceHolderState.loading
                  : errorText != null && errorText.isNotEmpty ? PlaceHolderState.error : PlaceHolderState.nothing,
          errorText: errorText,
          onChanged: onChanged,
          loadingText: loadingText,
          nothingText: nothingText,
          retryText: retryText,
        );

  final Widget child;
  final void Function() onRefresh;
  final PlaceHolderState state;
  final String errorText;
  final StateChangedCallback onChanged;
  final String loadingText;
  final String nothingText;
  final String retryText;

  @override
  _ListPlaceHolderTextState createState() => _ListPlaceHolderTextState();
}

class _ListPlaceHolderTextState extends State<ListPlaceHolderText> {
  PlaceHolderState _lastState;
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
      case PlaceHolderState.normal:
        return widget.child;
      case PlaceHolderState.loading:
        return Center(
          child: Text(
            widget.loadingText ?? 'Loading...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        );
      case PlaceHolderState.nothing:
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
                  widget.nothingText ?? 'Nothing',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: OutlineButton(
                  child: Text(widget.retryText ?? 'Retry'),
                  onPressed: () {
                    widget.onRefresh?.call();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        );
      case PlaceHolderState.error:
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
                  child: Text(widget.retryText ?? 'Retry'),
                  onPressed: () {
                    widget.onRefresh?.call();
                    if (mounted) {
                      setState(() {});
                    }
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
