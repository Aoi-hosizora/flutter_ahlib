/// A helper extension for [bool].
extension BoolExtension on bool {
  /// Returns value if condition is true.
  T ifTrue<T>(T Function() func, [T Function() fallbackFunc]) {
    if (this == true) {
      return func?.call();
    }
    return fallbackFunc?.call();
  }

  /// Returns value if condition is false.
  T ifFalse<T>(T Function() func, [T Function() fallbackFunc]) {
    if (this == false) {
      return func?.call();
    }
    return fallbackFunc?.call();
  }

  /// Returns value1 if condition is true, otherwise return value2.
  T ifElse<T>(T Function() ifFunc, T Function() elseFunc) {
    if (this == true) {
      return ifFunc?.call();
    } else if (this == false) {
      return elseFunc?.call();
    }
    return null;
  }
}

/// A helper extension for [List].
extension ListExtension<T> on List<T> {
  /// Returns a new list with separator build by builder between items.
  List<T> separateWithBuilder(T Function(int) builder) {
    assert(builder != null);
    if (this.length == 0) {
      return <T>[];
    }
    return [
      this[0],
      for (var idx = 1; idx < this.length; idx++) ...[
        builder(idx - 1),
        this[idx],
      ],
    ];
  }

  /// Returns a new list with separator between items.
  List<T> separate(T separator) {
    return separateWithBuilder((_) => separator);
  }
}
