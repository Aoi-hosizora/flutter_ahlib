import 'package:flutter/material.dart';

/// A state used to describe the current state of [PlaceholderText].
enum PlaceholderState {
  normal, // 1. not empty
  loading, // 2. empty && loading
  nothing, // 3. empty && !loading && error
  error, // 4. empty && !loading && !error
}

/// [PlaceholderState] changed callback function, used in [PlaceholderText].
typedef PlaceholderStateChangedCallback = void Function(PlaceholderState oldState, PlaceholderState newState);

/// Display setting for [PlaceholderText].
class PlaceholderSetting {
  const PlaceholderSetting({
    //
    this.loadingText = 'Loading...',
    this.nothingText = 'Nothing',
    this.retryText = 'Retry',
    this.unknownErrorText = 'Unknown error',
    //
    this.nothingIcon = Icons.clear_all,
    this.errorIcon = Icons.error,
    //
    this.textPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    this.iconPadding = const EdgeInsets.all(5),
    this.buttonPadding = const EdgeInsets.all(5),
    this.progressPadding = const EdgeInsets.all(30),
    //
    this.textStyle = const TextStyle(fontSize: 20),
    this.buttonTextStyle = const TextStyle(fontSize: 14),
    this.iconSize = 50,
    this.iconColor = Colors.grey,
    this.progressSize = 40,
    this.buttonBorderSide = const BorderSide(style: BorderStyle.solid, color: Color(0xFFD7D7D7)),
    //
    this.showLoadingProgress = true,
    this.showLoadingText = true,
    //
    this.showNothingIcon = true,
    this.showNothingText = true,
    this.showNothingRetry = true,
    //
    this.showErrorIcon = true,
    this.showErrorText = true,
    this.showErrorRetry = true,
    //
  })  : assert(loadingText != null),
        assert(nothingText != null),
        assert(retryText != null),
        assert(unknownErrorText != null),
        assert(nothingIcon != null),
        assert(errorIcon != null),
        assert(textPadding != null),
        assert(iconPadding != null),
        assert(buttonPadding != null),
        assert(progressPadding != null),
        assert(textStyle != null),
        assert(buttonTextStyle != null),
        assert(iconSize != null),
        assert(iconColor != null),
        assert(progressSize != null),
        assert(buttonBorderSide != null),
        assert(showLoadingProgress != null),
        assert(showLoadingText != null),
        assert(showNothingIcon != null),
        assert(showNothingText != null),
        assert(showNothingRetry != null),
        assert(showErrorIcon != null),
        assert(showErrorText != null),
        assert(showErrorRetry != null);

  /// Use Chinese text as default setting.
  PlaceholderSetting toChinese({
    String loadingText = '加载中...',
    String nothingText = '无内容',
    String retryText = '重试',
    String unknownErrorText = '未知错误',
  }) {
    return PlaceholderSetting(
      loadingText: loadingText,
      nothingText: nothingText,
      retryText: retryText,
      unknownErrorText: unknownErrorText,
      nothingIcon: this.nothingIcon,
      errorIcon: this.errorIcon,
      textPadding: this.textPadding,
      iconPadding: this.iconPadding,
      buttonPadding: this.buttonPadding,
      progressPadding: this.progressPadding,
      textStyle: this.textStyle,
      buttonTextStyle: this.buttonTextStyle,
      iconSize: this.iconSize,
      iconColor: this.iconColor,
      progressSize: this.progressSize,
      buttonBorderSide: this.buttonBorderSide,
      showLoadingProgress: this.showLoadingProgress,
      showLoadingText: this.showLoadingText,
      showNothingIcon: this.showNothingIcon,
      showNothingText: this.showNothingText,
      showNothingRetry: this.showNothingRetry,
      showErrorIcon: this.showErrorIcon,
      showErrorText: this.showErrorText,
      showErrorRetry: this.showErrorRetry,
    );
  }

  /// Use Japanese text as default setting.
  PlaceholderSetting toJapanese({
    String loadingText = '読み込み中...',
    String nothingText = '何も見つかりませんでした',
    String retryText = '再試行',
    String unknownErrorText = '未知エラー',
  }) {
    return PlaceholderSetting(
      loadingText: loadingText,
      nothingText: nothingText,
      retryText: retryText,
      unknownErrorText: unknownErrorText,
      nothingIcon: this.nothingIcon,
      errorIcon: this.errorIcon,
      textPadding: this.textPadding,
      iconPadding: this.iconPadding,
      buttonPadding: this.buttonPadding,
      progressPadding: this.progressPadding,
      textStyle: this.textStyle,
      buttonTextStyle: this.buttonTextStyle,
      iconSize: this.iconSize,
      iconColor: this.iconColor,
      progressSize: this.progressSize,
      buttonBorderSide: this.buttonBorderSide,
      showLoadingProgress: this.showLoadingProgress,
      showLoadingText: this.showLoadingText,
      showNothingIcon: this.showNothingIcon,
      showNothingText: this.showNothingText,
      showNothingRetry: this.showNothingRetry,
      showErrorIcon: this.showErrorIcon,
      showErrorText: this.showErrorText,
      showErrorRetry: this.showErrorRetry,
    );
  }

  // text
  final String loadingText;
  final String nothingText;
  final String retryText;
  final String unknownErrorText;

  // icon
  final IconData nothingIcon;
  final IconData errorIcon;

  // padding
  final EdgeInsets textPadding;
  final EdgeInsets iconPadding;
  final EdgeInsets buttonPadding;
  final EdgeInsets progressPadding;

  // style
  final TextStyle textStyle;
  final TextStyle buttonTextStyle;
  final double iconSize;
  final Color iconColor;
  final double progressSize;
  final BorderSide buttonBorderSide;

  // loading
  final bool showLoadingProgress;
  final bool showLoadingText;

  // nothing
  final bool showNothingIcon;
  final bool showNothingText;
  final bool showNothingRetry;

  // error
  final bool showErrorIcon;
  final bool showErrorText;
  final bool showErrorRetry;
}

/// Placeholder text mainly used for network requesting with [ListView],
/// including normal, loading, nothing, error.
class PlaceholderText extends StatefulWidget {
  const PlaceholderText({
    Key key,
    @required this.childBuilder,
    this.onRefresh,
    this.errorText,
    @required this.state,
    this.onChanged,
    this.setting = const PlaceholderSetting(),
  })  : assert(childBuilder != null),
        assert(state != null),
        assert(setting != null),
        super(key: key);

  const PlaceholderText.from({
    Key key,
    @required Widget Function(BuildContext) childBuilder,
    Function onRefresh,
    String errorText,
    PlaceholderState forceState,
    @required bool isEmpty,
    @required bool isLoading,
    PlaceholderStateChangedCallback onChanged,
    PlaceholderSetting setting = const PlaceholderSetting(),
  }) : this(
          key: key,
          childBuilder: childBuilder,
          onRefresh: onRefresh,
          errorText: errorText,
          state: forceState != null
              ? forceState // force
              : isEmpty == false
                  ? PlaceholderState.normal // not empty
                  : isLoading == true
                      ? PlaceholderState.loading // empty && loading
                      : errorText != null && errorText != ''
                          ? PlaceholderState.error // empty && !loading && error
                          : true == true
                              ? PlaceholderState.nothing // empty && !loading && !error
                              : null,
          onChanged: onChanged,
          setting: setting,
        );

  /// Builder for child.
  final Widget Function(BuildContext) childBuilder;

  /// Refresh handler for retry.
  final Function onRefresh;

  /// Error message (if null, will invoke error state).
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
    _lastState = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_lastState == null) {
      _lastState = widget.state;
    } else if (_lastState != widget.state) {
      widget.onChanged?.call(_lastState, widget.state);
      _lastState = widget.state;
    }

    switch (widget.state) {
      ////////////////////////////////////////////////////////////////
      // normal
      ////////////////////////////////////////////////////////////////
      case PlaceholderState.normal:
        return widget.childBuilder(context);
      ////////////////////////////////////////////////////////////////
      // loading
      ////////////////////////////////////////////////////////////////
      case PlaceholderState.loading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.setting.showLoadingProgress)
                Padding(
                  padding: widget.setting.progressPadding,
                  child: SizedBox(
                    height: widget.setting.progressSize,
                    width: widget.setting.progressSize,
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (widget.setting.showLoadingText)
                Padding(
                  padding: widget.setting.textPadding,
                  child: Text(
                    widget.setting.loadingText,
                    textAlign: TextAlign.center,
                    style: widget.setting.textStyle,
                  ),
                ),
            ],
          ),
        );
      ////////////////////////////////////////////////////////////////
      // nothing
      ////////////////////////////////////////////////////////////////
      case PlaceholderState.nothing:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.setting.showNothingIcon)
                Padding(
                  padding: widget.setting.iconPadding,
                  child: Icon(
                    widget.setting.nothingIcon,
                    size: widget.setting.iconSize,
                    color: widget.setting.iconColor,
                  ),
                ),
              if (widget.setting.showNothingText)
                Padding(
                  padding: widget.setting.textPadding,
                  child: Text(
                    widget.setting.nothingText,
                    textAlign: TextAlign.center,
                    style: widget.setting.textStyle,
                  ),
                ),
              if (widget.setting.showNothingRetry)
                Padding(
                  padding: widget.setting.buttonPadding,
                  child: OutlineButton(
                    child: Text(
                      widget.setting.retryText,
                      style: widget.setting.buttonTextStyle,
                    ),
                    onPressed: () {
                      widget.onRefresh?.call();
                      if (mounted) setState(() {});
                    },
                    borderSide: widget.setting.buttonBorderSide,
                  ),
                ),
            ],
          ),
        );
      ////////////////////////////////////////////////////////////////
      // error
      ////////////////////////////////////////////////////////////////
      case PlaceholderState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.setting.showErrorIcon)
                Padding(
                  padding: widget.setting.iconPadding,
                  child: Icon(
                    widget.setting.errorIcon,
                    size: widget.setting.iconSize,
                    color: widget.setting.iconColor,
                  ),
                ),
              if (widget.setting.showErrorText)
                Padding(
                  padding: widget.setting.textPadding,
                  child: Text(
                    widget.errorText?.isNotEmpty == true ? widget.errorText : widget.setting.unknownErrorText,
                    textAlign: TextAlign.center,
                    style: widget.setting.textStyle,
                  ),
                ),
              if (widget.setting.showErrorRetry)
                Padding(
                  padding: widget.setting.buttonPadding,
                  child: OutlineButton(
                    child: Text(
                      widget.setting.retryText,
                      style: widget.setting.buttonTextStyle,
                    ),
                    onPressed: () {
                      widget.onRefresh?.call();
                      if (mounted) setState(() {});
                    },
                    borderSide: widget.setting.buttonBorderSide,
                  ),
                ),
            ],
          ),
        );
      ////////////////////////////////////////////////////////////////
      // unreachable
      ////////////////////////////////////////////////////////////////
      default:
        return Container();
    }
  }
}
