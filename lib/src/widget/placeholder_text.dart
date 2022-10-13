import 'package:flutter/material.dart';

/// A state enum used to describe the current state of [PlaceholderText].
enum PlaceholderState {
  normal, // 1. not empty
  loading, // 2. empty && loading
  nothing, // 3. empty && !loading && !error
  error, // 4. empty && !loading && error
}

/// A [PlaceholderText.state] changed callback function, with old state and new state.
typedef PlaceholderStateChangedCallback = void Function(PlaceholderState oldState, PlaceholderState newState);

/// A display setting of [PlaceholderText]. Note that the properties of this class are all non-nullable.
class PlaceholderSetting {
  const PlaceholderSetting({
    // text
    this.loadingText = 'Loading...',
    this.nothingText = 'Nothing',
    this.nothingRetryText = 'Retry',
    this.unknownErrorText = 'Unknown error',
    this.errorRetryText = 'Retry',
    // icon
    this.nothingIcon = Icons.clear_all,
    this.errorIcon = Icons.error,
    // padding
    this.textPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    this.iconPadding = const EdgeInsets.all(5),
    this.buttonPadding = const EdgeInsets.all(5),
    this.progressPadding = const EdgeInsets.all(27.5),
    this.progressTextPadding = const EdgeInsets.all(14),
    // style
    this.textStyle = const TextStyle(fontSize: 20), // TODO use Theme.of(context).textTheme instead
    this.errorTextMaxLines = 15,
    this.errorTextOverflow = TextOverflow.ellipsis,
    this.buttonTextStyle = const TextStyle(fontSize: 14),
    this.buttonStyle = const ButtonStyle(),
    this.iconSize = 50,
    this.iconColor = Colors.grey,
    this.progressSize = 45,
    this.progressStrokeWidth = 4.4,
    // show loading xxx
    this.showLoadingProgress = true,
    this.showLoadingText = true,
    // show nothing xxx
    this.showNothingIcon = true,
    this.showNothingText = true,
    this.showNothingRetry = true,
    // show error xxx
    this.showErrorIcon = true,
    this.showErrorText = true,
    this.showErrorRetry = true,
  });

  /// Translates the current setting to Chinese and returns the new [PlaceholderSetting].
  PlaceholderSetting copyWithChinese({
    String loadingText = '加载中...',
    String nothingText = '无内容',
    String nothingRetryText = '重试',
    String unknownErrorText = '未知错误',
    String errorRetryText = '重试',
  }) {
    return PlaceholderSetting(
      loadingText: loadingText,
      nothingText: nothingText,
      nothingRetryText: nothingRetryText,
      unknownErrorText: unknownErrorText,
      errorRetryText: errorRetryText,
      nothingIcon: nothingIcon,
      errorIcon: errorIcon,
      textPadding: textPadding,
      iconPadding: iconPadding,
      buttonPadding: buttonPadding,
      progressPadding: progressPadding,
      progressTextPadding: progressTextPadding,
      textStyle: textStyle,
      errorTextMaxLines: errorTextMaxLines,
      errorTextOverflow: errorTextOverflow,
      buttonTextStyle: buttonTextStyle,
      buttonStyle: buttonStyle,
      iconSize: iconSize,
      iconColor: iconColor,
      progressSize: progressSize,
      progressStrokeWidth: progressStrokeWidth,
      showLoadingProgress: showLoadingProgress,
      showLoadingText: showLoadingText,
      showNothingIcon: showNothingIcon,
      showNothingText: showNothingText,
      showNothingRetry: showNothingRetry,
      showErrorIcon: showErrorIcon,
      showErrorText: showErrorText,
      showErrorRetry: showErrorRetry,
    );
  }

  /// Translates the current setting to Japanese and returns the new [PlaceholderSetting].
  PlaceholderSetting copyWithJapanese({
    String loadingText = '読み込み中...',
    String nothingText = '何も見つかりませんでした',
    String nothingRetryText = '再試行',
    String unknownErrorText = '未知エラー',
    String errorRetryText = '再試行',
  }) {
    return PlaceholderSetting(
      loadingText: loadingText,
      nothingText: nothingText,
      nothingRetryText: nothingRetryText,
      unknownErrorText: unknownErrorText,
      errorRetryText: errorRetryText,
      nothingIcon: nothingIcon,
      errorIcon: errorIcon,
      textPadding: textPadding,
      iconPadding: iconPadding,
      buttonPadding: buttonPadding,
      progressPadding: progressPadding,
      progressTextPadding: progressTextPadding,
      textStyle: textStyle,
      errorTextMaxLines: errorTextMaxLines,
      errorTextOverflow: errorTextOverflow,
      buttonTextStyle: buttonTextStyle,
      buttonStyle: buttonStyle,
      iconSize: iconSize,
      iconColor: iconColor,
      progressSize: progressSize,
      progressStrokeWidth: progressStrokeWidth,
      showLoadingProgress: showLoadingProgress,
      showLoadingText: showLoadingText,
      showNothingIcon: showNothingIcon,
      showNothingText: showNothingText,
      showNothingRetry: showNothingRetry,
      showErrorIcon: showErrorIcon,
      showErrorText: showErrorText,
      showErrorRetry: showErrorRetry,
    );
  }

  // text
  final String loadingText;
  final String nothingText;
  final String nothingRetryText;
  final String unknownErrorText;
  final String errorRetryText;

  // icon
  final IconData nothingIcon;
  final IconData errorIcon;

  // padding
  final EdgeInsets textPadding;
  final EdgeInsets iconPadding;
  final EdgeInsets buttonPadding;
  final EdgeInsets progressPadding;
  final EdgeInsets progressTextPadding;

  // style
  final TextStyle textStyle;
  final int errorTextMaxLines;
  final TextOverflow errorTextOverflow;
  final TextStyle buttonTextStyle;
  final ButtonStyle buttonStyle;
  final double iconSize;
  final Color iconColor;
  final double progressSize;
  final double progressStrokeWidth;

  // show loading xxx
  final bool showLoadingProgress;
  final bool showLoadingText;

  // show nothing xxx
  final bool showNothingIcon;
  final bool showNothingText;
  final bool showNothingRetry;

  // show error xxx
  final bool showErrorIcon;
  final bool showErrorText;
  final bool showErrorRetry;
}

/// A placeholder text mainly used with [ListView] when using network request, includes four states:
/// normal, loading, nothing, error.
class PlaceholderText extends StatefulWidget {
  const PlaceholderText({
    Key? key,
    required this.childBuilder,
    this.onRefresh,
    this.onRetryForNothing,
    this.onRetryForError,
    this.errorText,
    required this.state,
    this.onChanged,
    this.setting = const PlaceholderSetting(),
  }) : super(key: key);

  /// Creates [PlaceholderText] with given parameters, this method uses given fields to get the [state].
  const PlaceholderText.from({
    Key? key,
    required Widget Function(BuildContext) childBuilder,
    void Function()? onRefresh,
    void Function()? onRetryForNothing,
    void Function()? onRetryForError,
    String? errorText,
    PlaceholderState? forceState,
    required bool isEmpty,
    required bool isLoading,
    PlaceholderStateChangedCallback? onChanged,
    PlaceholderSetting setting = const PlaceholderSetting(),
    // TODO error priority field !!!, data existed when error aroused
  }) : this(
          key: key,
          childBuilder: childBuilder,
          onRefresh: onRefresh,
          onRetryForNothing: onRetryForNothing,
          onRetryForError: onRetryForError,
          errorText: errorText,
          onChanged: onChanged,
          setting: setting,
          state: forceState ?? // use given forced state
              (isEmpty == false
                  ? PlaceholderState.normal // not empty
                  : isLoading == true
                      ? PlaceholderState.loading // empty && loading
                      : errorText != null && errorText != ''
                          ? PlaceholderState.error // empty && !loading && error
                          : PlaceholderState.nothing), // empty && !loading && !error
        );

  /// The child builder of this widget.
  final Widget Function(BuildContext) childBuilder;

  /// The refresh handler to perform retry logic. Note that this is the fallback value for
  /// [onRetryForNothing] and [onRetryForError].
  final void Function()? onRefresh;

  /// The refresh handler to perform retry logic, for nothing.
  final void Function()? onRetryForNothing;

  /// The refresh handler to perform retry logic, for error.
  final void Function()? onRetryForError;

  /// The current error message, shown when current [state] is [PlaceholderState.error].
  final String? errorText;

  /// The current state of this widget.
  final PlaceholderState state;

  /// The callback function when [state] changed.
  final PlaceholderStateChangedCallback? onChanged;

  /// The display setting of this widget.
  final PlaceholderSetting setting;

  @override
  _PlaceholderTextState createState() => _PlaceholderTextState();
}

class _PlaceholderTextState extends State<PlaceholderText> {
  PlaceholderState? _lastState; // store the last state

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
      widget.onChanged?.call(_lastState!, widget.state);
      _lastState = widget.state;
    }

    switch (widget.state) {
      // ======
      // normal
      // ======
      case PlaceholderState.normal:
        return widget.childBuilder(context);
      // =======
      // loading
      // =======
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
                    child: CircularProgressIndicator(
                      strokeWidth: widget.setting.progressStrokeWidth,
                    ),
                  ),
                ),
              if (widget.setting.showLoadingText)
                Padding(
                  padding: widget.setting.progressTextPadding,
                  child: Text(
                    widget.setting.loadingText,
                    textAlign: TextAlign.center,
                    style: widget.setting.textStyle,
                  ),
                ),
            ],
          ),
        );
      // =======
      // nothing
      // =======
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
                  child: OutlinedButton(
                    child: Text(
                      widget.setting.nothingRetryText,
                      style: widget.setting.buttonTextStyle,
                    ),
                    onPressed: () {
                      (widget.onRetryForNothing ?? widget.onRefresh)?.call();
                      if (mounted) setState(() {});
                    },
                    style: widget.setting.buttonStyle,
                  ),
                ),
            ],
          ),
        );
      // =====
      // error
      // =====
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          (widget.errorText?.isNotEmpty == true) ? widget.errorText! : widget.setting.unknownErrorText,
                          textAlign: TextAlign.center,
                          style: widget.setting.textStyle,
                          maxLines: widget.setting.errorTextMaxLines,
                          overflow: widget.setting.errorTextOverflow,
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.setting.showErrorRetry)
                Padding(
                  padding: widget.setting.buttonPadding,
                  child: OutlinedButton(
                    child: Text(
                      widget.setting.errorRetryText,
                      style: widget.setting.buttonTextStyle,
                    ),
                    onPressed: () {
                      (widget.onRetryForError ?? widget.onRefresh)?.call();
                      if (mounted) setState(() {});
                    },
                    style: widget.setting.buttonStyle,
                  ),
                ),
            ],
          ),
        );
      // ===========
      // unreachable
      // ===========
      default:
        return const SizedBox(height: 0); // dummy
    }
  }
}
