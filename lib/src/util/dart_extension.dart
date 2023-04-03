/// An extension for [bool].
extension BoolExtension on bool {
  /// Returns value generated by [func] if condition is true.
  T? ifTrue<T>(T Function() func, [T Function()? fallbackFunc]) {
    if (this == true) {
      return func.call();
    }
    return fallbackFunc?.call();
  }

  /// Returns value generated by [func] if condition is false.
  T? ifFalse<T>(T Function() func, [T Function()? fallbackFunc]) {
    if (this == false) {
      return func.call();
    }
    return fallbackFunc?.call();
  }

  /// Returns value1 generated by [ifFunc] if condition is true, otherwise returns value2 generated by [elseFunc].
  T ifElse<T>(T Function() ifFunc, T Function() elseFunc) {
    if (this == true) {
      return ifFunc.call();
    }
    return elseFunc.call();
  }
}

/// An extension for [Iterable].
extension IterableExtension<T> on Iterable<T> {
  /// Returns a new list containing totalCount count of the given list.
  List<T> repeat(int totalCount) {
    if (totalCount <= 1) {
      return toList();
    }
    var newList = <T>[];
    for (int i = 0; i < totalCount; i++) {
      for (var item in this) {
        newList.add(item);
      }
    }
    return newList;
  }

  /// Returns a new list with separator build by [builder], between items.
  List<T> separateWithBuilder(T Function(int) builder) {
    if (isEmpty) {
      return <T>[];
    }
    var list = toList();
    return [
      list[0],
      for (var idx = 1; idx < length; idx++) ...[
        builder(idx - 1),
        list[idx],
      ],
    ];
  }

  /// Returns a new list with separator between items.
  List<T> separate(T separator) {
    return separateWithBuilder((_) => separator);
  }

  /// Returns the first element of the collection, or returns null if the collection is empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element of the collection, or returns null if the collection is empty.
  T? get lastOrNull => isEmpty ? null : last;
}

/// An extension for [List].
extension ListExtension<T> on List<T> {
  /// Replaces items from current list, checked by [condition] and replaced by [replace].
  void replaceWhere(bool Function(T item) condition, T Function(T item) replace, {int count = -1}) {
    var replaced = 0;
    for (var i = 0; i < length; i++) {
      if (condition(this[i])) {
        this[i] = replace(this[i]);
        replaced++;
        if (count >= 1 && replaced >= count) {
          return; // given count is valid && replaced count reaches limit
        }
      }
    }
  }

  /// Replaces the first items from current list, checked by [condition] and replaced by [replace].
  void replaceFirstWhere(bool Function(T item) condition, T Function(T item) replace) {
    return replaceWhere(condition, replace, count: 1);
  }

  /// Updates items from current list, checked by [condition] and updated by [replace].
  void updateWhere(bool Function(T item) condition, void Function(T item) update, {int count = -1}) {
    var updated = 0;
    for (var i = 0; i < length; i++) {
      if (condition(this[i])) {
        update(this[i]);
        updated++;
        if (count >= 1 && updated >= count) {
          return; // given count is valid && updated count reaches limit
        }
      }
    }
  }

  /// Updates the first items from current list, checked by [condition] and updated by [replace].
  void updateFirstWhere(bool Function(T item) condition, void Function(T item) update) {
    updateWhere(condition, update, count: 1);
  }
}

/// Calls given all functions, this function can be used to avoid introducing braces and makes code more compact.
void callAll(List<void Function()> functions) {
  for (var f in functions) {
    f.call();
  }
}

/// An extension for any non-null values.
extension ObjectExtension<T extends Object> on T {
  /// This method works the same as `is` keyword.
  bool is_<U>() {
    return this is U;
  }

  /// This method works the same as `as` keyword.
  ///
  /// Note that if current value type does not match given [U], it will throw _CastError.
  U as_<U>() {
    return this as U;
  }

  /// Casts to [U] type and returns the value if possible, otherwise return null.
  U? asIf<U>() {
    if (this is! U) {
      return null;
    }
    return this as U;
  }

  /// Calls given function when current value is not null.
  R let<R>(R Function(T value) func) {
    return func.call(this);
  }
}

/// An extension for [Future].
extension FutureExtension<T extends Object> on Future<T?> {
  /// Calls given function when current value is not null.
  Future<R?> futureLet<R>(R Function(T value) func) async {
    T? value = await this;
    if (value != null) {
      return func.call(value);
    }
    return null;
  }
}
