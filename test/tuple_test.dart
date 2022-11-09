import 'package:flutter_ahlib/flutter_ahlib_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tuple2', () {
    test('constructor', () {
      var t1 = Tuple2(1, '2');
      var t2 = Tuple2(1, '2');
      var t3 = Tuple2(1, '2 ');

      // ignore: unnecessary_type_check
      expect(t1 is Tuple2<int, String>, true);

      expect(t1.item1, 1);
      expect(t1.item2, '2');
      expect(t1.toString(), '[1, 2]');
      expect(t1.toList(), [1, '2']);
      expect(t1 == t2, true);
      expect(t1 == t3, false);
    });

    test('tuple to list', () {
      var t1 = Tuple2(1, '2');
      var t2 = Tuple2.fromList([1, '2']);
      var t3 = Tuple2<int, String>.fromList([1, '2 ']);

      // ignore: unnecessary_type_check
      expect(t1 is Tuple2<int, String>, true);
      // ignore: unnecessary_type_check
      expect(t2 is Tuple2<dynamic, dynamic>, true);
      // ignore: unnecessary_type_check
      expect(t3 is Tuple2<int, String>, true);

      expect(t2.item1, 1);
      expect(t2.item2, '2');
      expect(t2.toString(), '[1, 2]');
      expect(t2.toList(), [1, '2']);
      expect(t2 == t1, true);
      expect(t2 == t3, false);
    });
  });

  group('Tuple6', () {
    test('constructor', () {
      var t1 = Tuple6(1, '2', 3.0, true, <int>[5], <int>{6});
      var t2 = Tuple6(1, '2', 3.0, true, <int>[5], <int>{6});
      var t3 = Tuple6(1, '2', 3.1, true, <int>[5], <int>{6});

      // ignore: unnecessary_type_check
      expect(t1 is Tuple6<int, String, double, bool, List<int>, Set<int>>, true);

      expect(t1.item1, 1);
      expect(t1.item2, '2');
      expect(t1.item3, 3.0);
      expect(t1.item4, true);
      expect(t1.item5, <int>[5]);
      expect(t1.item6, <int>{6});
      expect(t1.toString(), '[1, 2, 3.0, true, [5], {6}]');
      expect(t1.toList(), [
        1,
        '2',
        3.0,
        true,
        <int>[5],
        <int>{6}
      ]);
      expect(t1 == t2, false); // because of List and Set
      t2.item5 = t1.item5;
      t2.item6 = t1.item6;
      expect(t1 == t2, true);
      expect(t1 == t3, false);
    });

    test('tuple to list', () {
      var t1 = Tuple6(1, '2', 3.0, true, <int>[5], <int>{6});
      var t2 = Tuple6.fromList([
        1,
        '2',
        3.0,
        true,
        <int>[5],
        <int>{6}
      ]);
      var t3 = Tuple6<int, String, double, bool, List<int>, Set<int>>.fromList([
        1,
        '2',
        3.1,
        true,
        <int>[5],
        <int>{6}
      ]);

      // ignore: unnecessary_type_check
      expect(t1 is Tuple6<int, String, double, bool, List<int>, Set<int>>, true);
      // ignore: unnecessary_type_check
      expect(t2 is Tuple6<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>, true);
      // ignore: unnecessary_type_check
      expect(t3 is Tuple6<int, String, double, bool, List<int>, Set<int>>, true);

      expect(t2.item1, 1);
      expect(t2.item2, '2');
      expect(t2.item3, 3.0);
      expect(t2.item4, true);
      expect(t2.item5, <int>[5]);
      expect(t2.item6, <int>{6});
      expect(t2.toString(), '[1, 2, 3.0, true, [5], {6}]');
      expect(t2.toList(), [
        1,
        '2',
        3.0,
        true,
        <int>[5],
        <int>{6}
      ]);
      expect(t2 == t1, false); // because of List and Set
      t1.item5 = t2.item5;
      t1.item6 = t2.item6;
      expect(t2 == t1, true);
      expect(t2 == t3, false);
    });
  });
}
