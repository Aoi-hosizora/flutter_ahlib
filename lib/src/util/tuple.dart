import 'dart:ui';

// Reference:
// - https://github.com/google/tuple.dart/blob/master/lib/tuple.dart

/// Represents a 1-tuple, which can be used to wrap simple type as referable type.
class Tuple1<T> {
  Tuple1(this.item);

  /// The item of the tuple;
  T item;

  @override
  String toString() => '[$item]';

  @override
  bool operator ==(Object other) {
    return other is Tuple1 && other.item == item;
  }

  @override
  int get hashCode => item.hashCode;
}

/// Represents a 2-tuple, or pair.
class Tuple2<T1, T2> {
  Tuple2(this.item1, this.item2);

  /// The first item of the tuple.
  T1 item1;

  /// The second item of the tuple.
  T2 item2;

  /// Creates a new tuple value with the specified list [items].
  factory Tuple2.fromList(List items) {
    if (items.length != 2) {
      throw ArgumentError('items must have length 2');
    }
    return Tuple2<T1, T2>(items[0] as T1, items[1] as T2);
  }

  /// Creates a [List] containing the items of this [Tuple2].
  List toList({bool growable = false}) => List.from([item1, item2], growable: growable);

  @override
  String toString() => '[$item1, $item2]';

  @override
  bool operator ==(Object other) {
    return other is Tuple2 && other.item1 == item1 && other.item2 == item2;
  }

  @override
  int get hashCode => hashValues(item1.hashCode, item2.hashCode);
}

/// Represents a 3-tuple, or triple.
class Tuple3<T1, T2, T3> {
  Tuple3(this.item1, this.item2, this.item3);

  /// The first item of the tuple.
  T1 item1;

  /// The second item of the tuple.
  T2 item2;

  /// The third item of the tuple.
  T3 item3;

  /// Creates a new tuple value with the specified list [items].
  factory Tuple3.fromList(List items) {
    if (items.length != 3) {
      throw ArgumentError('items must have length 3');
    }
    return Tuple3<T1, T2, T3>(items[0] as T1, items[1] as T2, items[2] as T3);
  }

  /// Creates a [List] containing the items of this [Tuple3].
  List toList({bool growable = false}) => List.from([item1, item2, item3], growable: growable);

  @override
  String toString() => '[$item1, $item2, $item3]';

  @override
  bool operator ==(Object other) {
    return other is Tuple3 && other.item1 == item1 && other.item2 == item2 && other.item3 == item3;
  }

  @override
  int get hashCode => hashValues(item1.hashCode, item2.hashCode, item3.hashCode);
}

/// Represents a 4-tuple, or quadruple.
class Tuple4<T1, T2, T3, T4> {
  Tuple4(this.item1, this.item2, this.item3, this.item4);

  /// The first item of the tuple.
  T1 item1;

  /// The second item of the tuple.
  T2 item2;

  /// The third item of the tuple.
  T3 item3;

  /// The forth item of the tuple.
  T4 item4;

  /// Creates a new tuple value with the specified list [items].
  factory Tuple4.fromList(List items) {
    if (items.length != 4) {
      throw ArgumentError('items must have length 4');
    }
    return Tuple4<T1, T2, T3, T4>(items[0] as T1, items[1] as T2, items[2] as T3, items[3] as T4);
  }

  /// Creates a [List] containing the items of this [Tuple4].
  List toList({bool growable = false}) => List.from([item1, item2, item3, item4], growable: growable);

  @override
  String toString() => '[$item1, $item2, $item3, $item4]';

  @override
  bool operator ==(Object other) {
    return other is Tuple4 && other.item1 == item1 && other.item2 == item2 && other.item3 == item3 && other.item4 == item4;
  }

  @override
  int get hashCode => hashValues(item1.hashCode, item2.hashCode, item3.hashCode, item4.hashCode);
}

/// Represents a 5-tuple, or quintuple.
class Tuple5<T1, T2, T3, T4, T5> {
  Tuple5(this.item1, this.item2, this.item3, this.item4, this.item5);

  /// The first item of the tuple.
  T1 item1;

  /// The second item of the tuple.
  T2 item2;

  /// The third item of the tuple.
  T3 item3;

  /// The forth item of the tuple.
  T4 item4;

  /// The fifth item of the tuple.
  T5 item5;

  /// Creates a new tuple value with the specified list [items].
  factory Tuple5.fromList(List items) {
    if (items.length != 5) {
      throw ArgumentError('items must have length 5');
    }
    return Tuple5<T1, T2, T3, T4, T5>(items[0] as T1, items[1] as T2, items[2] as T3, items[3] as T4, items[4] as T5);
  }

  /// Creates a [List] containing the items of this [Tuple5].
  List toList({bool growable = false}) => List.from([item1, item2, item3, item4, item5], growable: growable);

  @override
  String toString() => '[$item1, $item2, $item3, $item4, $item5]';

  @override
  bool operator ==(Object other) {
    return other is Tuple5 && other.item1 == item1 && other.item2 == item2 && other.item3 == item3 && other.item4 == item4 && other.item5 == item5;
  }

  @override
  int get hashCode => hashValues(item1.hashCode, item2.hashCode, item3.hashCode, item4.hashCode, item5.hashCode);
}

/// Represents a 6-tuple, or sextuple.
class Tuple6<T1, T2, T3, T4, T5, T6> {
  Tuple6(this.item1, this.item2, this.item3, this.item4, this.item5, this.item6);

  /// The first item of the tuple.
  T1 item1;

  /// The second item of the tuple.
  T2 item2;

  /// The third item of the tuple.
  T3 item3;

  /// The forth item of the tuple.
  T4 item4;

  /// The fifth item of the tuple.
  T5 item5;

  /// The sixth item of the tuple.
  T6 item6;

  /// Creates a new tuple value with the specified list [items].
  factory Tuple6.fromList(List items) {
    if (items.length != 6) {
      throw ArgumentError('items must have length 6');
    }
    return Tuple6<T1, T2, T3, T4, T5, T6>(items[0] as T1, items[1] as T2, items[2] as T3, items[3] as T4, items[4] as T5, items[5] as T6);
  }

  /// Creates a [List] containing the items of this [Tuple6].
  List toList({bool growable = false}) => List.from([item1, item2, item3, item4, item5, item6], growable: growable);

  @override
  String toString() => '[$item1, $item2, $item3, $item4, $item5, $item6]';

  @override
  bool operator ==(Object other) {
    return other is Tuple6 && other.item1 == item1 && other.item2 == item2 && other.item3 == item3 && other.item4 == item4 && other.item5 == item5 && other.item6 == item6;
  }

  @override
  int get hashCode => hashValues(item1.hashCode, item2.hashCode, item3.hashCode, item4.hashCode, item5.hashCode, item6.hashCode);
}
