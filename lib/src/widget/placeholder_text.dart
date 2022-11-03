import 'package:flutter/material.dart';

/// A state enum used to describe the current state of [PlaceholderText].
enum PlaceholderState {
  normal, // isEmpty == false
  loading, // isLoading == true
  error, // errorText != null && errorText != ''
  nothing, // isEmpty == true
}

/// A rule enum used to describe how to decide [PlaceholderState] in [PlaceholderText.from].
enum PlaceholderDisplayRule {
  /// Shows data first, even if currently it is loading, or error text is not empty.
  /// 1. !empty => normal
  /// 2. empty && loading => loading
  /// 3. empty && !loading && error => error
  /// 4. empty && !loading && !error => nothing
  dataFirst,

  /// Shows loading first, and then shows data, even if currently data is not empty.
  /// 1. loading => loading
  /// 2. !loading && !empty => normal
  /// 3. !loading && empty && error => error
  /// 4. !loading && empty && !error => nothing
  loadingFirst,

  /// Shows loading first, and then shows error, even if currently data is not empty.
  /// 1. loading => loading
  /// 2. !loading && error => error
  /// 3. !loading && !error && !empty => normal
  /// 4. !loading && !error && empty => nothing
  errorFirst,
}

/// A widget builder function, with void callback parameter.
typedef CallbackWidgetBuilder = Widget Function(BuildContext context, VoidCallback callback);

/// A [PlaceholderText.state] changed callback function, with old state and new state.
typedef PlaceholderStateChangedCallback = void Function(PlaceholderState oldState, PlaceholderState newState);

/// TODO set as global theme, use PlaceholderTextTheme ???

/// A display setting of [PlaceholderText]. Note that all the properties of this class are
/// non-nullable, except for widget builders.
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
    this.progressPadding = const EdgeInsets.fromLTRB(25, 5, 25, 30), // TODO test
    // style
    this.textStyle = const TextStyle(fontSize: 20), // TextTheme.headline6
    this.errorTextMaxLines = 15,
    this.errorTextOverflow = TextOverflow.ellipsis,
    this.buttonTextStyle = const TextStyle(fontSize: 14), // TextTheme.button
    this.buttonStyle = const ButtonStyle(),
    this.iconSize = 50,
    this.iconColor = Colors.grey,
    this.progressSize = 45, // TODO test
    this.progressStrokeWidth = 4.4,
    // show xxx
    this.showLoadingProgress = true,
    this.showLoadingText = true,
    this.showNothingIcon = true,
    this.showNothingText = true,
    this.showNothingRetry = true,
    this.showErrorIcon = true,
    this.showErrorText = true,
    this.showErrorRetry = true,
    // custom xxx
    this.customLoadingProgress,
    this.customLoadingText,
    this.customNothingIcon,
    this.customNothingText,
    this.customNothingRetry,
    this.customErrorIcon,
    this.customErrorText,
    this.customErrorRetry,
  });

  /// Creates a copy of this value but with given fields replaced with the new values.
  PlaceholderSetting copyWith({
    String? loadingText,
    String? nothingText,
    String? nothingRetryText,
    String? unknownErrorText,
    String? errorRetryText,
    IconData? nothingIcon,
    IconData? errorIcon,
    EdgeInsets? textPadding,
    EdgeInsets? iconPadding,
    EdgeInsets? buttonPadding,
    EdgeInsets? progressPadding,
    TextStyle? textStyle,
    int? errorTextMaxLines,
    TextOverflow? errorTextOverflow,
    TextStyle? buttonTextStyle,
    ButtonStyle? buttonStyle,
    double? iconSize,
    Color? iconColor,
    double? progressSize,
    double? progressStrokeWidth,
    bool? showLoadingProgress,
    bool? showLoadingText,
    bool? showNothingIcon,
    bool? showNothingText,
    bool? showNothingRetry,
    bool? showErrorIcon,
    bool? showErrorText,
    bool? showErrorRetry,
    WidgetBuilder? customLoadingProgress,
    WidgetBuilder? customLoadingText,
    WidgetBuilder? customNothingIcon,
    WidgetBuilder? customNothingText,
    CallbackWidgetBuilder? customNothingRetry,
    WidgetBuilder? customErrorIcon,
    WidgetBuilder? customErrorText,
    CallbackWidgetBuilder? customErrorRetry,
  }) {
    return PlaceholderSetting(
      loadingText: loadingText ?? this.loadingText,
      nothingText: nothingText ?? this.nothingText,
      nothingRetryText: nothingRetryText ?? this.nothingRetryText,
      unknownErrorText: unknownErrorText ?? this.unknownErrorText,
      errorRetryText: errorRetryText ?? this.errorRetryText,
      nothingIcon: nothingIcon ?? this.nothingIcon,
      errorIcon: errorIcon ?? this.errorIcon,
      textPadding: textPadding ?? this.textPadding,
      iconPadding: iconPadding ?? this.iconPadding,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      progressPadding: progressPadding ?? this.progressPadding,
      textStyle: textStyle ?? this.textStyle,
      errorTextMaxLines: errorTextMaxLines ?? this.errorTextMaxLines,
      errorTextOverflow: errorTextOverflow ?? this.errorTextOverflow,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      progressSize: progressSize ?? this.progressSize,
      progressStrokeWidth: progressStrokeWidth ?? this.progressStrokeWidth,
      showLoadingProgress: showLoadingProgress ?? this.showLoadingProgress,
      showLoadingText: showLoadingText ?? this.showLoadingText,
      showNothingIcon: showNothingIcon ?? this.showNothingIcon,
      showNothingText: showNothingText ?? this.showNothingText,
      showNothingRetry: showNothingRetry ?? this.showNothingRetry,
      showErrorIcon: showErrorIcon ?? this.showErrorIcon,
      showErrorText: showErrorText ?? this.showErrorText,
      showErrorRetry: showErrorRetry ?? this.showErrorRetry,
      customLoadingProgress: customLoadingProgress ?? this.customLoadingProgress,
      customLoadingText: customLoadingText ?? this.customLoadingText,
      customNothingIcon: customNothingIcon ?? this.customNothingIcon,
      customNothingText: customNothingText ?? this.customNothingText,
      customNothingRetry: customNothingRetry ?? this.customNothingRetry,
      customErrorIcon: customErrorIcon ?? this.customErrorIcon,
      customErrorText: customErrorText ?? this.customErrorText,
      customErrorRetry: customErrorRetry ?? this.customErrorRetry,
    );
  }

  /// Translates the current setting to Chinese and returns the new [PlaceholderSetting].
  PlaceholderSetting copyWithChinese({
    String loadingText = '加载中...',
    String nothingText = '无内容',
    String nothingRetryText = '重试',
    String unknownErrorText = '未知错误',
    String errorRetryText = '重试',
  }) {
    return copyWith(
      loadingText: loadingText,
      nothingText: nothingText,
      nothingRetryText: nothingRetryText,
      unknownErrorText: unknownErrorText,
      errorRetryText: errorRetryText,
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
    return copyWith(
      loadingText: loadingText,
      nothingText: nothingText,
      nothingRetryText: nothingRetryText,
      unknownErrorText: unknownErrorText,
      errorRetryText: errorRetryText,
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

  // show xxx
  final bool showLoadingProgress;
  final bool showLoadingText;
  final bool showNothingIcon;
  final bool showNothingText;
  final bool showNothingRetry;
  final bool showErrorIcon;
  final bool showErrorText;
  final bool showErrorRetry;

  // custom xxx
  final WidgetBuilder? customLoadingProgress;
  final WidgetBuilder? customLoadingText;
  final WidgetBuilder? customNothingIcon;
  final WidgetBuilder? customNothingText;
  final CallbackWidgetBuilder? customNothingRetry;
  final WidgetBuilder? customErrorIcon;
  final WidgetBuilder? customErrorText;
  final CallbackWidgetBuilder? customErrorRetry;
}

/// A placeholder text mainly used with [ListView] when using network request, includes four
/// states: normal, loading, nothing, error.
class PlaceholderText extends StatefulWidget {
  /// Creates [PlaceholderText] with [state].
  const PlaceholderText({
    Key? key,
    required this.childBuilder,
    required this.state,
    this.errorText,
    this.onRefresh,
    this.onRetryForNothing,
    this.onRetryForError,
    this.onChanged,
    this.setting = const PlaceholderSetting(),
  }) : super(key: key);

  /// Creates [PlaceholderText] with given parameters, this constructor uses given fields and
  /// [displayRule] to get the [state].
  const PlaceholderText.from({
    Key? key,
    required Widget Function(BuildContext) childBuilder,
    PlaceholderState? forceState,
    required bool isEmpty,
    required bool isLoading,
    String? errorText,
    void Function()? onRefresh,
    void Function()? onRetryForNothing,
    void Function()? onRetryForError,
    PlaceholderStateChangedCallback? onChanged,
    PlaceholderSetting setting = const PlaceholderSetting(),
    PlaceholderDisplayRule displayRule = PlaceholderDisplayRule.dataFirst,
  }) : this(
          key: key,
          childBuilder: childBuilder,
          state: forceState ?? // use given forced state
              (displayRule == PlaceholderDisplayRule.dataFirst
                  ?
                  // !!! dataFirst
                  (isEmpty == false
                      ? PlaceholderState.normal // !empty => normal
                      : isLoading == true
                          ? PlaceholderState.loading // empty && loading => loading
                          : errorText != null && errorText != ''
                              ? PlaceholderState.error // empty && !loading && error => error
                              : PlaceholderState.nothing) // empty && !loading && !error => nothing
                  : displayRule == PlaceholderDisplayRule.loadingFirst
                      ?
                      // !!! loadingFirst
                      (isLoading == true
                          ? PlaceholderState.loading // loading => loading
                          : isEmpty == false
                              ? PlaceholderState.normal // !loading && !empty => normal
                              : errorText != null && errorText != ''
                                  ? PlaceholderState.error // !loading && empty && error => error
                                  : PlaceholderState.nothing) // !loading && empty && !error => nothing
                      :
                      // !!! errorFirst
                      (isLoading == true
                          ? PlaceholderState.loading // loading => loading
                          : errorText != null && errorText != ''
                              ? PlaceholderState.error // !loading && error => error
                              : isEmpty == false
                                  ? PlaceholderState.normal // !loading && !error && !empty => normal
                                  : PlaceholderState.nothing) // !loading && !error && empty => nothing
              ),
          errorText: errorText,
          onRefresh: onRefresh,
          onRetryForNothing: onRetryForNothing,
          onRetryForError: onRetryForError,
          onChanged: onChanged,
          setting: setting,
        );

  /// The child builder of this widget.
  final Widget Function(BuildContext) childBuilder;

  /// The current state of this widget.
  final PlaceholderState state;

  /// The current error message, shown when current [state] is [PlaceholderState.error].
  final String? errorText;

  /// The refresh handler to perform retry logic. Note that this will only be used when
  /// [onRetryForNothing] or [onRetryForError] are null.
  final void Function()? onRefresh;

  /// The refresh handler to perform retry logic, for nothing. If this value is null,
  /// [onRefresh] will be used instead.
  final void Function()? onRetryForNothing;

  /// The refresh handler to perform retry logic, for error. If this value is null,
  /// [onRefresh] will be used instead.
  final void Function()? onRetryForError;

  /// The callback function when [state] changed.
  final PlaceholderStateChangedCallback? onChanged;

  /// The display setting of this widget.
  final PlaceholderSetting setting;

  @override
  _PlaceholderTextState createState() => _PlaceholderTextState();
}

class _PlaceholderTextState extends State<PlaceholderText> {
  // store the last state
  late var _lastState = widget.state;

  @override
  Widget build(BuildContext context) {
    if (_lastState != widget.state) {
      widget.onChanged?.call(_lastState, widget.state);
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
                  child: widget.setting.customLoadingProgress?.call(context) ??
                      SizedBox(
                        height: widget.setting.progressSize,
                        width: widget.setting.progressSize,
                        child: CircularProgressIndicator(
                          strokeWidth: widget.setting.progressStrokeWidth,
                        ),
                      ),
                ),
              if (widget.setting.showLoadingText)
                Padding(
                  padding: widget.setting.textPadding,
                  child: widget.setting.customLoadingText?.call(context) ??
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.subtitle1!,
                        child: Text(
                          widget.setting.loadingText, // TODO overflow ???
                          textAlign: TextAlign.center,
                          style: widget.setting.textStyle,
                        ),
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
                  child: widget.setting.customNothingIcon?.call(context) ??
                      Icon(
                        widget.setting.nothingIcon,
                        size: widget.setting.iconSize,
                        color: widget.setting.iconColor,
                      ),
                ),
              if (widget.setting.showNothingText)
                Padding(
                  padding: widget.setting.textPadding,
                  child: widget.setting.customNothingText?.call(context) ??
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.subtitle1!,
                        child: Text(
                          widget.setting.nothingText, // TODO overflow ???
                          textAlign: TextAlign.center,
                          style: widget.setting.textStyle,
                        ),
                      ),
                ),
              if (widget.setting.showNothingRetry)
                Padding(
                  padding: widget.setting.buttonPadding,
                  child: widget.setting.customNothingRetry?.call(
                        context,
                        () => (widget.onRetryForNothing ?? widget.onRefresh)?.call(),
                      ) ??
                      OutlinedButton(
                        child: Text(
                          widget.setting.nothingRetryText,
                          style: widget.setting.buttonTextStyle,
                        ),
                        style: widget.setting.buttonStyle,
                        onPressed: () => (widget.onRetryForNothing ?? widget.onRefresh)?.call(),
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
                  child: widget.setting.customErrorIcon?.call(context) ??
                      Icon(
                        widget.setting.errorIcon,
                        size: widget.setting.iconSize,
                        color: widget.setting.iconColor,
                      ),
                ),
              if (widget.setting.showErrorText)
                Padding(
                  padding: widget.setting.textPadding,
                  child: widget.setting.customErrorText?.call(context) ??
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: DefaultTextStyle(
                              style: Theme.of(context).textTheme.subtitle1!,
                              child: Text(
                                widget.errorText?.isNotEmpty == true
                                    ? widget.errorText! //
                                    : widget.setting.unknownErrorText,
                                textAlign: TextAlign.center,
                                style: widget.setting.textStyle,
                                maxLines: widget.setting.errorTextMaxLines,
                                overflow: widget.setting.errorTextOverflow,
                              ),
                            ),
                          ),
                        ],
                      ),
                ),
              if (widget.setting.showErrorRetry)
                Padding(
                  padding: widget.setting.buttonPadding,
                  child: widget.setting.customErrorRetry?.call(
                        context,
                        () => (widget.onRetryForError ?? widget.onRefresh)?.call(),
                      ) ??
                      OutlinedButton(
                        child: Text(
                          widget.setting.errorRetryText,
                          style: widget.setting.buttonTextStyle,
                        ),
                        style: widget.setting.buttonStyle,
                        onPressed: () => (widget.onRetryForError ?? widget.onRefresh)?.call(),
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
