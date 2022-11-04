import 'package:flutter_ahlib/flutter_ahlib_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tuple', () {
    test('constructor', () {
      var t = Tuple2<int, String>(1, '2');
      var t2 = Tuple2<int, String>(1, '2');

      expect(t.item1, 1);
      expect(t.item2, '2');
      expect(t.toString(), '[1, 2]');
      expect(t == t2, true);
    });

    test('tuple to list', () {
      var t = Tuple2.fromList([1, '2']);
      var t2 = Tuple2<int, String>(1, '2');

      expect(t.item1, 1);
      expect(t.item2, '2');
      expect(t.toList(), [1, '2']);
      expect(t == t2, true);
    });
  });

  group('hash', () {
    test('hashObjects', () {
      var h = hashObjects(['123', 456]);
      expect(h, isA<int>());
      h = hashObjects(['123', null]);
      expect(h, isA<int>());
      h = hashObjects([null, null]);
      expect(h, isA<int>());
    });

    test('hashN', () {
      var h = hash2('123', 456);
      expect(h, isA<int>());
      h = hash3('123', 456, true);
      expect(h, isA<int>());
      h = hash4('123', 456, true, []);
      expect(h, isA<int>());
      h = hash5('123', 456, true, [], null);
      expect(h, isA<int>());
      h = hash6('123', 456, true, [], null, 0.1);
      expect(h, isA<int>());
    });
  });
}
