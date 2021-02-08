import 'package:flutter_ahlib/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoolExtension', () {
    test('ifTrue', () {
      var r = 0;
      r = true.ifTrue(() => 1);
      expect(r, 1);
      r = true.ifTrue(() => 1, () => 2);
      expect(r, 1);
      r = true.ifFalse(() => 1, () => 2);
      expect(r, 2);
    });

    test('ifFalse', () {
      var r = 0;
      r = false.ifFalse(() => 1);
      expect(r, 1);
      r = false.ifFalse(() => 1, () => 2);
      expect(r, 1);
      r = false.ifTrue(() => 1, () => 2);
      expect(r, 2);
    });

    test('ifElse', () {
      var r = 0;
      r = true.ifElse(() => 1, () => 2);
      expect(r, 1);
      r = false.ifElse(() => 1, () => 2);
      expect(r, 2);
    });
  });

  group('ListExtension', () {
    test('separate', () {
      expect([].separate(0), []);
      expect([1].separate(0), [1]);
      expect([1, 2].separate(0), [1, 0, 2]);
      expect([1, 2, 3].separate(null), [1, null, 2, null, 3]);
      expect([1, 2, 3, 4, 5].separate(0), [1, 0, 2, 0, 3, 0, 4, 0, 5]);
    });

    test('separateWithBuilder', () {
      expect([1, 2, 3, 4, 5].separateWithBuilder((_) => 0), [1, 0, 2, 0, 3, 0, 4, 0, 5]);
    });
  });
}
