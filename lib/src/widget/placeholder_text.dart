import 'package:flutter/foundation.dart';
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
typedef VoidCallbackWidgetBuilder = Widget Function(BuildContext context, VoidCallback callback);

/// A widget builder function, with widget builder parameter.
typedef WidgetBuilderWidgetBuilder = Widget Function(BuildContext context, WidgetBuilder childBuilder);

/// A [PlaceholderText.state] changed callback function, with old state and new state.
typedef PlaceholderStateChangedCallback = void Function(PlaceholderState oldState, PlaceholderState newState);

/// An inherited widget that associates an [PlaceholderSetting] with a subtree.
class PlaceholderTextTheme extends InheritedWidget {
  const PlaceholderTextTheme({
    Key? key,
    required this.setting,
    required Widget child,
  }) : super(key: key, child: child);

  /// The data associated with the subtree.
  final PlaceholderSetting setting;

  /// Returns the data most closely associated with the given context.
  static PlaceholderSetting? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<PlaceholderTextTheme>();
    return result?.setting;
  }

  @override
  bool updateShouldNotify(covariant PlaceholderTextTheme oldWidget) {
    return oldWidget.setting != setting; // without considering builders
  }
}

/// A display setting of [PlaceholderText]. Note that null fields will be filled with the
/// corresponding fields in [PlaceholderTextTheme.setting], if the field is still null,
/// [PlaceholderSetting.defaultSetting] will be used instead.
class PlaceholderSetting with Diagnosticable {
  const PlaceholderSetting({
    // animation
    this.useAnimatedSwitcher,
    this.switchDuration,
    this.switchReverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.switchTransitionBuilder,
    this.switchLayoutBuilder,
    // text
    this.loadingText,
    this.nothingText,
    this.nothingRetryText,
    this.unknownErrorText,
    this.errorRetryText,
    // icon
    this.nothingIcon,
    this.errorIcon,
    // padding
    this.textPadding,
    this.iconPadding,
    this.buttonPadding,
    this.progressPadding,
    this.wholePaddingUnlessNormal,
    // style
    this.textStyle,
    this.textMaxLines,
    this.textOverflow,
    this.buttonTextStyle,
    this.buttonStyle,
    this.iconSize,
    this.iconColor,
    this.progressSize,
    this.progressStrokeWidth,
    // show xxx
    this.showLoadingProgress,
    this.showLoadingText,
    this.showNothingIcon,
    this.showNothingText,
    this.showNothingRetry,
    this.showErrorIcon,
    this.showErrorText,
    this.showErrorRetry,
    // custom builder
    this.customLoadingProgressBuilder,
    this.customLoadingTextBuilder,
    this.customNothingIconBuilder,
    this.customNothingTextBuilder,
    this.customNothingRetryBuilder,
    this.customErrorIconBuilder,
    this.customErrorTextBuilder,
    this.customErrorRetryBuilder,
    this.customNormalStateBuilder,
    this.customSwitcherBuilder,
  });

  /// Constructs and returns the default setting value, which will be used when some fields
  /// are null in both [PlaceholderText.setting] and [PlaceholderTextTheme.setting].
  static PlaceholderSetting defaultSetting(BuildContext context) {
    return PlaceholderSetting(
      // animation
      useAnimatedSwitcher: false,
      switchDuration: const Duration(milliseconds: 200),
      switchReverseDuration: null,
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.linear,
      switchTransitionBuilder: AnimatedSwitcher.defaultTransitionBuilder,
      switchLayoutBuilder: AnimatedSwitcher.defaultLayoutBuilder,
      // text
      loadingText: 'Loading...',
      nothingText: 'Nothing',
      nothingRetryText: 'Retry',
      unknownErrorText: 'Unknown error',
      errorRetryText: 'Retry',
      // icon
      nothingIcon: Icons.clear_all,
      errorIcon: Icons.error,
      // padding
      textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      iconPadding: const EdgeInsets.all(5),
      buttonPadding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      progressPadding: const EdgeInsets.fromLTRB(5, 10, 5, 30),
      wholePaddingUnlessNormal: EdgeInsets.zero,
      // style
      textStyle: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 20, fontWeight: FontWeight.normal),
      textMaxLines: 15,
      textOverflow: TextOverflow.ellipsis,
      buttonTextStyle: Theme.of(context).textTheme.button?.copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
      buttonStyle: Theme.of(context).outlinedButtonTheme.style?.copyWith(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      iconSize: 50,
      iconColor: Colors.grey,
      progressSize: 50,
      progressStrokeWidth: 4.5,
      // show xxx
      showLoadingProgress: true,
      showLoadingText: true,
      showNothingIcon: true,
      showNothingText: true,
      showNothingRetry: true,
      showErrorIcon: true,
      showErrorText: true,
      showErrorRetry: true,
      // custom builder
      customLoadingProgressBuilder: null,
      customLoadingTextBuilder: null,
      customNothingIconBuilder: null,
      customNothingTextBuilder: null,
      customNothingRetryBuilder: null,
      customErrorIconBuilder: null,
      customErrorTextBuilder: null,
      customErrorRetryBuilder: null,
      customNormalStateBuilder: null,
      customSwitcherBuilder: null,
    );
  }

  /// Creates a copy of this value but with given fields replaced with the new values.
  PlaceholderSetting copyWith({
    bool? useAnimatedSwitcher,
    Duration? switchDuration,
    Duration? switchReverseDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherTransitionBuilder? switchTransitionBuilder,
    AnimatedSwitcherLayoutBuilder? switchLayoutBuilder,
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
    EdgeInsets? wholePaddingUnlessNormal,
    TextStyle? textStyle,
    int? textMaxLines,
    TextOverflow? textOverflow,
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
    WidgetBuilder? customLoadingProgressBuilder,
    WidgetBuilder? customLoadingTextBuilder,
    WidgetBuilder? customNothingIconBuilder,
    WidgetBuilder? customNothingTextBuilder,
    VoidCallbackWidgetBuilder? customNothingRetryBuilder,
    WidgetBuilder? customErrorIconBuilder,
    WidgetBuilder? customErrorTextBuilder,
    VoidCallbackWidgetBuilder? customErrorRetryBuilder,
    WidgetBuilderWidgetBuilder? customNormalStateBuilder,
    WidgetBuilderWidgetBuilder? customSwitcherBuilder,
  }) {
    return PlaceholderSetting(
      useAnimatedSwitcher: useAnimatedSwitcher ?? this.useAnimatedSwitcher,
      switchDuration: switchDuration ?? this.switchDuration,
      switchReverseDuration: switchReverseDuration ?? this.switchReverseDuration,
      switchInCurve: switchInCurve ?? this.switchInCurve,
      switchOutCurve: switchOutCurve ?? this.switchOutCurve,
      switchTransitionBuilder: switchTransitionBuilder ?? this.switchTransitionBuilder,
      switchLayoutBuilder: switchLayoutBuilder ?? this.switchLayoutBuilder,
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
      wholePaddingUnlessNormal: wholePaddingUnlessNormal ?? this.wholePaddingUnlessNormal,
      textStyle: textStyle ?? this.textStyle,
      textMaxLines: textMaxLines ?? this.textMaxLines,
      textOverflow: textOverflow ?? this.textOverflow,
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
      customLoadingProgressBuilder: customLoadingProgressBuilder ?? this.customLoadingProgressBuilder,
      customLoadingTextBuilder: customLoadingTextBuilder ?? this.customLoadingTextBuilder,
      customNothingIconBuilder: customNothingIconBuilder ?? this.customNothingIconBuilder,
      customNothingTextBuilder: customNothingTextBuilder ?? this.customNothingTextBuilder,
      customNothingRetryBuilder: customNothingRetryBuilder ?? this.customNothingRetryBuilder,
      customErrorIconBuilder: customErrorIconBuilder ?? this.customErrorIconBuilder,
      customErrorTextBuilder: customErrorTextBuilder ?? this.customErrorTextBuilder,
      customErrorRetryBuilder: customErrorRetryBuilder ?? this.customErrorRetryBuilder,
      customNormalStateBuilder: customNormalStateBuilder ?? this.customNormalStateBuilder,
      customSwitcherBuilder: customSwitcherBuilder ?? this.customSwitcherBuilder,
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

  static PlaceholderSetting merge(PlaceholderSetting data, PlaceholderSetting? fallback) {
    return PlaceholderSetting(
      useAnimatedSwitcher: data.useAnimatedSwitcher ?? fallback?.useAnimatedSwitcher,
      switchDuration: data.switchDuration ?? fallback?.switchDuration,
      switchReverseDuration: data.switchReverseDuration ?? fallback?.switchReverseDuration,
      switchInCurve: data.switchInCurve ?? fallback?.switchInCurve,
      switchOutCurve: data.switchOutCurve ?? fallback?.switchOutCurve,
      switchTransitionBuilder: data.switchTransitionBuilder ?? fallback?.switchTransitionBuilder,
      switchLayoutBuilder: data.switchLayoutBuilder ?? fallback?.switchLayoutBuilder,
      loadingText: data.loadingText ?? fallback?.loadingText,
      nothingText: data.nothingText ?? fallback?.nothingText,
      nothingRetryText: data.nothingRetryText ?? fallback?.nothingRetryText,
      unknownErrorText: data.unknownErrorText ?? fallback?.unknownErrorText,
      errorRetryText: data.errorRetryText ?? fallback?.errorRetryText,
      nothingIcon: data.nothingIcon ?? fallback?.nothingIcon,
      errorIcon: data.errorIcon ?? fallback?.errorIcon,
      textPadding: data.textPadding ?? fallback?.textPadding,
      iconPadding: data.iconPadding ?? fallback?.iconPadding,
      buttonPadding: data.buttonPadding ?? fallback?.buttonPadding,
      progressPadding: data.progressPadding ?? fallback?.progressPadding,
      wholePaddingUnlessNormal: data.wholePaddingUnlessNormal ?? fallback?.wholePaddingUnlessNormal,
      textStyle: data.textStyle ?? fallback?.textStyle,
      textMaxLines: data.textMaxLines ?? fallback?.textMaxLines,
      textOverflow: data.textOverflow ?? fallback?.textOverflow,
      buttonTextStyle: data.buttonTextStyle ?? fallback?.buttonTextStyle,
      buttonStyle: data.buttonStyle ?? fallback?.buttonStyle,
      iconSize: data.iconSize ?? fallback?.iconSize,
      iconColor: data.iconColor ?? fallback?.iconColor,
      progressSize: data.progressSize ?? fallback?.progressSize,
      progressStrokeWidth: data.progressStrokeWidth ?? fallback?.progressStrokeWidth,
      showLoadingProgress: data.showLoadingProgress ?? fallback?.showLoadingProgress,
      showLoadingText: data.showLoadingText ?? fallback?.showLoadingText,
      showNothingIcon: data.showNothingIcon ?? fallback?.showNothingIcon,
      showNothingText: data.showNothingText ?? fallback?.showNothingText,
      showNothingRetry: data.showNothingRetry ?? fallback?.showNothingRetry,
      showErrorIcon: data.showErrorIcon ?? fallback?.showErrorIcon,
      showErrorText: data.showErrorText ?? fallback?.showErrorText,
      showErrorRetry: data.showErrorRetry ?? fallback?.showErrorRetry,
      customLoadingProgressBuilder: data.customLoadingProgressBuilder ?? fallback?.customLoadingProgressBuilder,
      customLoadingTextBuilder: data.customLoadingTextBuilder ?? fallback?.customLoadingTextBuilder,
      customNothingIconBuilder: data.customNothingIconBuilder ?? fallback?.customNothingIconBuilder,
      customNothingTextBuilder: data.customNothingTextBuilder ?? fallback?.customNothingTextBuilder,
      customNothingRetryBuilder: data.customNothingRetryBuilder ?? fallback?.customNothingRetryBuilder,
      customErrorIconBuilder: data.customErrorIconBuilder ?? fallback?.customErrorIconBuilder,
      customErrorTextBuilder: data.customErrorTextBuilder ?? fallback?.customErrorTextBuilder,
      customErrorRetryBuilder: data.customErrorRetryBuilder ?? fallback?.customErrorRetryBuilder,
      customNormalStateBuilder: data.customNormalStateBuilder ?? fallback?.customNormalStateBuilder,
      customSwitcherBuilder: data.customSwitcherBuilder ?? fallback?.customSwitcherBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! PlaceholderSetting) {
      return false;
    }
    return other.useAnimatedSwitcher == useAnimatedSwitcher && //
        other.switchDuration == switchDuration &&
        other.switchReverseDuration == switchReverseDuration &&
        other.switchInCurve == switchInCurve &&
        other.switchOutCurve == switchOutCurve &&
        // other.switchTransitionBuilder == switchTransitionBuilder &&
        // other.switchLayoutBuilder == switchLayoutBuilder &&
        other.loadingText == loadingText &&
        other.nothingText == nothingText &&
        other.nothingRetryText == nothingRetryText &&
        other.unknownErrorText == unknownErrorText &&
        other.errorRetryText == errorRetryText &&
        other.nothingIcon == nothingIcon &&
        other.errorIcon == errorIcon &&
        other.textPadding == textPadding &&
        other.iconPadding == iconPadding &&
        other.buttonPadding == buttonPadding &&
        other.progressPadding == progressPadding &&
        other.wholePaddingUnlessNormal == wholePaddingUnlessNormal &&
        other.textStyle == textStyle &&
        other.textMaxLines == textMaxLines &&
        other.textOverflow == textOverflow &&
        other.buttonTextStyle == buttonTextStyle &&
        other.buttonStyle == buttonStyle &&
        other.iconSize == iconSize &&
        other.iconColor == iconColor &&
        other.progressSize == progressSize &&
        other.progressStrokeWidth == progressStrokeWidth &&
        other.showLoadingProgress == showLoadingProgress &&
        other.showLoadingText == showLoadingText &&
        other.showNothingIcon == showNothingIcon &&
        other.showNothingText == showNothingText &&
        other.showNothingRetry == showNothingRetry &&
        other.showErrorIcon == showErrorIcon &&
        other.showErrorText == showErrorText &&
        other.showErrorRetry == showErrorRetry &&
        // other.customLoadingProgressBuilder == customLoadingProgressBuilder &&
        // other.customLoadingTextBuilder == customLoadingTextBuilder &&
        // other.customNothingIconBuilder == customNothingIconBuilder &&
        // other.customNothingTextBuilder == customNothingTextBuilder &&
        // other.customNothingRetryBuilder == customNothingRetryBuilder &&
        // other.customErrorIconBuilder == customErrorIconBuilder &&
        // other.customErrorTextBuilder == customErrorTextBuilder &&
        // other.customErrorRetryBuilder == customErrorRetryBuilder &&
        // other.customNormalStateBuilder == customNormalStateBuilder &&
        // other.customSwitcherBuilder == customSwitcherBuilder &&
        true;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      useAnimatedSwitcher,
      switchDuration,
      switchReverseDuration,
      switchInCurve,
      switchOutCurve,
      // switchTransitionBuilder,
      // switchLayoutBuilder,
      loadingText,
      nothingText,
      nothingRetryText,
      unknownErrorText,
      errorRetryText,
      nothingIcon,
      errorIcon,
      textPadding,
      iconPadding,
      buttonPadding,
      progressPadding,
      wholePaddingUnlessNormal,
      textStyle,
      textMaxLines,
      textOverflow,
      buttonTextStyle,
      buttonStyle,
      iconSize,
      iconColor,
      progressSize,
      progressStrokeWidth,
      showLoadingProgress,
      showLoadingText,
      showNothingIcon,
      showNothingText,
      showNothingRetry,
      showErrorIcon,
      showErrorText,
      showErrorRetry,
      // customLoadingProgressBuilder,
      // customLoadingTextBuilder,
      // customNothingIconBuilder,
      // customNothingTextBuilder,
      // customNothingRetryBuilder,
      // customErrorIconBuilder,
      // customErrorTextBuilder,
      // customErrorRetryBuilder,
      // customNormalStateBuilder,
      // customSwitcherBuilder,
    ]);
  }

  // animation
  final bool? useAnimatedSwitcher;
  final Duration? switchDuration;
  final Duration? switchReverseDuration;
  final Curve? switchInCurve;
  final Curve? switchOutCurve;
  final AnimatedSwitcherTransitionBuilder? switchTransitionBuilder;
  final AnimatedSwitcherLayoutBuilder? switchLayoutBuilder;

  // text
  final String? loadingText;
  final String? nothingText;
  final String? nothingRetryText;
  final String? unknownErrorText;
  final String? errorRetryText;

  // icon
  final IconData? nothingIcon;
  final IconData? errorIcon;

  // padding
  final EdgeInsets? textPadding;
  final EdgeInsets? iconPadding;
  final EdgeInsets? buttonPadding;
  final EdgeInsets? progressPadding;
  final EdgeInsets? wholePaddingUnlessNormal;

  // style
  final TextStyle? textStyle;
  final int? textMaxLines;
  final TextOverflow? textOverflow;
  final TextStyle? buttonTextStyle;
  final ButtonStyle? buttonStyle;
  final double? iconSize;
  final Color? iconColor;
  final double? progressSize;
  final double? progressStrokeWidth;

  // show xxx
  final bool? showLoadingProgress;
  final bool? showLoadingText;
  final bool? showNothingIcon;
  final bool? showNothingText;
  final bool? showNothingRetry;
  final bool? showErrorIcon;
  final bool? showErrorText;
  final bool? showErrorRetry;

  // custom builder
  final WidgetBuilder? customLoadingProgressBuilder;
  final WidgetBuilder? customLoadingTextBuilder;
  final WidgetBuilder? customNothingIconBuilder;
  final WidgetBuilder? customNothingTextBuilder;
  final VoidCallbackWidgetBuilder? customNothingRetryBuilder;
  final WidgetBuilder? customErrorIconBuilder;
  final WidgetBuilder? customErrorTextBuilder;
  final VoidCallbackWidgetBuilder? customErrorRetryBuilder;
  final WidgetBuilderWidgetBuilder? customNormalStateBuilder;
  final WidgetBuilderWidgetBuilder? customSwitcherBuilder;
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
    this.setting,
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
    PlaceholderSetting? setting,
    PlaceholderDisplayRule displayRule = PlaceholderDisplayRule.dataFirst,
  }) : this(
          key: key,
          childBuilder: childBuilder,
          state: forceState ?? // use given forced state
              (displayRule == PlaceholderDisplayRule.dataFirst
                  ?
                  // dataFirst
                  (isEmpty == false
                      ? PlaceholderState.normal // !empty => normal
                      : isLoading == true
                          ? PlaceholderState.loading // empty && loading => loading
                          : errorText != null && errorText != ''
                              ? PlaceholderState.error // empty && !loading && error => error
                              : PlaceholderState.nothing) // empty && !loading && !error => nothing
                  : displayRule == PlaceholderDisplayRule.loadingFirst
                      ?
                      // loadingFirst
                      (isLoading == true
                          ? PlaceholderState.loading // loading => loading
                          : isEmpty == false
                              ? PlaceholderState.normal // !loading && !empty => normal
                              : errorText != null && errorText != ''
                                  ? PlaceholderState.error // !loading && empty && error => error
                                  : PlaceholderState.nothing) // !loading && empty && !error => nothing
                      :
                      // errorFirst
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

  /// The display setting of this widget, defaults to `const PlaceholderSetting()`.
  final PlaceholderSetting? setting;

  @override
  _PlaceholderTextState createState() => _PlaceholderTextState();
}

class _PlaceholderTextState extends State<PlaceholderText> {
  @override
  void didUpdateWidget(covariant PlaceholderText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      widget.onChanged?.call(oldWidget.state, widget.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final setting = PlaceholderSetting.merge(
      PlaceholderSetting.merge(
        widget.setting ?? const PlaceholderSetting(),
        PlaceholderTextTheme.of(context),
      ),
      PlaceholderSetting.defaultSetting(context),
    );

    Widget view;
    switch (widget.state) {
      // ======
      // normal
      // ======
      case PlaceholderState.normal:
        view = Builder(
          key: const ValueKey(PlaceholderState.normal),
          builder: widget.childBuilder,
        );
        if (setting.customNormalStateBuilder != null) {
          view = setting.customNormalStateBuilder!.call(context, (c) => view);
        }
        break;
      // =======
      // loading
      // =======
      case PlaceholderState.loading:
        view = Center(
          key: const ValueKey(PlaceholderState.loading),
          child: Padding(
            padding: setting.wholePaddingUnlessNormal!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (setting.showLoadingProgress!)
                  Padding(
                    padding: setting.progressPadding!,
                    child: setting.customLoadingProgressBuilder?.call(context) ??
                        SizedBox(
                          height: setting.progressSize!,
                          width: setting.progressSize!,
                          child: Padding(
                            padding: EdgeInsets.all(setting.progressStrokeWidth! / 2),
                            child: CircularProgressIndicator(
                              strokeWidth: setting.progressStrokeWidth!,
                            ),
                          ),
                        ),
                  ),
                if (setting.showLoadingText!)
                  Padding(
                    padding: setting.textPadding!,
                    child: setting.customLoadingTextBuilder?.call(context) ??
                        DefaultTextStyle(
                          style: Theme.of(context).textTheme.subtitle1!,
                          child: Text(
                            setting.loadingText!,
                            textAlign: TextAlign.center,
                            style: setting.textStyle!,
                            maxLines: setting.textMaxLines!,
                            overflow: setting.textOverflow!,
                          ),
                        ),
                  ),
              ],
            ),
          ),
        );
        break;
      // =======
      // nothing
      // =======
      case PlaceholderState.nothing:
        view = Center(
          key: const ValueKey(PlaceholderState.nothing),
          child: Padding(
            padding: setting.wholePaddingUnlessNormal!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (setting.showNothingIcon!)
                  Padding(
                    padding: setting.iconPadding!,
                    child: setting.customNothingIconBuilder?.call(context) ??
                        Icon(
                          setting.nothingIcon!,
                          size: setting.iconSize!,
                          color: setting.iconColor!,
                        ),
                  ),
                if (setting.showNothingText!)
                  Padding(
                    padding: setting.textPadding!,
                    child: setting.customNothingTextBuilder?.call(context) ??
                        DefaultTextStyle(
                          style: Theme.of(context).textTheme.subtitle1!,
                          child: Text(
                            setting.nothingText!,
                            textAlign: TextAlign.center,
                            style: setting.textStyle!,
                            maxLines: setting.textMaxLines!,
                            overflow: setting.textOverflow!,
                          ),
                        ),
                  ),
                if (setting.showNothingRetry!)
                  Padding(
                    padding: setting.buttonPadding!,
                    child: setting.customNothingRetryBuilder?.call(
                          context,
                          () => (widget.onRetryForNothing ?? widget.onRefresh)?.call(),
                        ) ??
                        OutlinedButton(
                          child: Text(
                            setting.nothingRetryText!,
                            style: setting.buttonTextStyle!,
                          ),
                          style: setting.buttonStyle /* nullable */,
                          onPressed: () => (widget.onRetryForNothing ?? widget.onRefresh)?.call(),
                        ),
                  ),
              ],
            ),
          ),
        );
        break;
      // =====
      // error
      // =====
      case PlaceholderState.error:
        view = Center(
          key: const ValueKey(PlaceholderState.error),
          child: Padding(
            padding: setting.wholePaddingUnlessNormal!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (setting.showErrorIcon!)
                  Padding(
                    padding: setting.iconPadding!,
                    child: setting.customErrorIconBuilder?.call(context) ??
                        Icon(
                          setting.errorIcon!,
                          size: setting.iconSize!,
                          color: setting.iconColor!,
                        ),
                  ),
                if (setting.showErrorText!)
                  Padding(
                    padding: setting.textPadding!,
                    child: setting.customErrorTextBuilder?.call(context) ??
                        DefaultTextStyle(
                          style: Theme.of(context).textTheme.subtitle1!,
                          child: Text(
                            widget.errorText?.isNotEmpty == true
                                ? widget.errorText! //
                                : setting.unknownErrorText!,
                            textAlign: TextAlign.center,
                            style: setting.textStyle!,
                            maxLines: setting.textMaxLines!,
                            overflow: setting.textOverflow!,
                          ),
                        ),
                  ),
                if (setting.showErrorRetry!)
                  Padding(
                    padding: setting.buttonPadding!,
                    child: setting.customErrorRetryBuilder?.call(
                          context,
                          () => (widget.onRetryForError ?? widget.onRefresh)?.call(),
                        ) ??
                        OutlinedButton(
                          child: Text(
                            setting.errorRetryText!,
                            style: setting.buttonTextStyle!,
                          ),
                          style: setting.buttonStyle /* nullable */,
                          onPressed: () => (widget.onRetryForError ?? widget.onRefresh)?.call(),
                        ),
                  ),
              ],
            ),
          ),
        );
        break;
      // ===========
      // unreachable
      // ===========
      default:
        view = const SizedBox.shrink(); // dummy
        break;
    }

    if (setting.customSwitcherBuilder != null) {
      return setting.customSwitcherBuilder!.call(context, (c) => view);
    }
    if (!setting.useAnimatedSwitcher!) {
      return view;
    }
    return AnimatedSwitcher(
      child: view,
      duration: setting.switchDuration!,
      reverseDuration: setting.switchReverseDuration ?? setting.switchDuration!,
      switchInCurve: setting.switchInCurve!,
      switchOutCurve: setting.switchOutCurve!,
      transitionBuilder: setting.switchTransitionBuilder!,
      layoutBuilder: setting.switchLayoutBuilder!,
    );
  }
}

/// An inherited widget that associates [switched] flag with a subtree, which represents whether
/// a widget was shown previously and is switched out currently, in [AnimatedSwitcher].
///
/// It can be used to control some different behaviors when the specific widget is switched out
/// and replaced by a new widget.
class PreviouslySwitchedWidget extends InheritedWidget {
  const PreviouslySwitchedWidget({
    Key? key,
    required Widget child,
    required this.switched,
  }) : super(key: key, child: child);

  /// The data associated with the subtree.
  final bool switched;

  /// Returns the widget most closely associated with the given context.
  static PreviouslySwitchedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PreviouslySwitchedWidget>();
  }

  /// Determines whether the widget is marked as switched, which means the widget has already switched
  /// out in [AnimatedSwitcher].
  static bool isPrevious(BuildContext context) {
    return of(context)?.switched == true;
  }

  @override
  bool updateShouldNotify(PreviouslySwitchedWidget oldWidget) {
    return switched != oldWidget.switched;
  }
}

/// A switch layout builder for [AnimatedSwitcher], which is almost the same as [AnimatedSwitcher.defaultLayoutBuilder],
/// but this builder wraps [PreviouslySwitchedWidget] with tracked key to specific widgets in [Stack].
///
/// Note that you should use this layout builder when you are using any kinds of [UpdatableDataView],
/// in order to invalidate the [ScrollController] for switched out [Scrollable] and [Scrollbar], and
/// deal with `The provided ScrollController is currently attached to more than one ScrollPosition`
/// kinds of exceptions.
Widget switchLayoutBuilderWithSwitchedFlag(Widget? currentChild, List<Widget> previousChildren) {
  return Stack(
    alignment: Alignment.center,
    children: [
      // previous widgets
      for (var child in previousChildren) //
        child is! KeyedSubtree
            ? child // unreachable, child is almost a KeyedSubtree
            : KeyedSubtree(
                key: child.key,
                child: PreviouslySwitchedWidget(
                  key: child.key, // <<< must set the key to track widget correctly
                  child: child.child,
                  switched: true,
                ),
              ),

      // current widget
      if (currentChild != null)
        currentChild is! KeyedSubtree
            ? currentChild // unreachable, currentChild is almost a KeyedSubtree
            : KeyedSubtree(
                key: currentChild.key,
                child: PreviouslySwitchedWidget(
                  key: currentChild.key, // <<< must set the key to track widget correctly
                  child: currentChild.child,
                  switched: false,
                ),
              ),
    ],
  );
}
