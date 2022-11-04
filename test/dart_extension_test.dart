import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoolExtension', () {
    test('ifTrue', () {
      var r = 0;
      r = true.ifTrue(() => 1)!;
      expect(r, 1);
      r = true.ifTrue(() => 1, () => 2)!;
      expect(r, 1);
      r = false.ifTrue(() => 1) == null ? -1 : 1;
      expect(r, -1);
      r = false.ifTrue(() => 1, () => 2)!;
      expect(r, 2);
    });

    test('ifFalse', () {
      var r = 0;
      r = false.ifFalse(() => 1)!;
      expect(r, 1);
      r = false.ifFalse(() => 1, () => 2)!;
      expect(r, 1);
      r = true.ifFalse(() => 1) == null ? -1 : 1;
      expect(r, -1);
      r = true.ifFalse(() => 1, () => 2)!;
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
    test('repeat', () {
      expect([].repeat(1), []);
      expect([1].repeat(0), [1]);
      expect([1, 2].repeat(2), [1, 2, 1, 2]);
      expect(<dynamic>[1, 2, null].repeat(3), [1, 2, null, 1, 2, null, 1, 2, null]);
    });

    test('separate', () {
      expect([].separate(0), []);
      expect([1].separate(0), [1]);
      expect([1, 2].separate(0), [1, 0, 2]);
      expect(<dynamic>[1, 2, 3].separate(null), [1, null, 2, null, 3]);
      expect([1, 2, 3, 4, 5].separate(0), [1, 0, 2, 0, 3, 0, 4, 0, 5]);
    });

    test('separateWithBuilder', () {
      expect([1, 2, 3, 4, 5].separateWithBuilder((_) => 0), [1, 0, 2, 0, 3, 0, 4, 0, 5]);
    });

    test('firstOrNull, lastOrNull', () {
      expect([].firstOrNull, null);
      expect([1].firstOrNull, 1);
      expect([1, 2].firstOrNull, 1);
      expect(<dynamic>[1, 2, null].firstOrNull, 1);
      expect(<dynamic>[null, null].firstOrNull, null);

      expect([].lastOrNull, null);
      expect([1].lastOrNull, 1);
      expect([1, 2].lastOrNull, 2);
      expect(<dynamic>[1, 2, null].lastOrNull, null);
      expect(<dynamic>[null, null].lastOrNull, null);
    });
  });

  group('LetExtension', () {
    test('let', () {
      expect(0.let((int v) => v), 0); // let<int>
      expect(0.let((int v) => 1), 1); // let<int>
      expect('x'.let((String v) => v * 2), 'xx'); // let<String>

      bool? i = false;
      bool value = false;
      () {
        i?.let((bool v) => value = !v); // let<bool>
        expect(value, true);
        i = null;
        i?.let((bool v) => value = false); // let<bool>
        expect(value, true);
      }();
    });

    test('futureLet', () async {
      expect(await Future.value(0).futureLet((int v) => v), 0); // futureLet<int>
      expect(await Future.value(0).futureLet((int v) => 1), 1); // futureLet<int>
      expect(await Future.value('x').futureLet((String v) => v * 2), 'xx'); // futureLet<String>
      expect(await (await Future.value('x').futureLet((String v) async => await Future.delayed(const Duration(milliseconds: 100), () => v * 2))), 'xx'); // futureLet<Future<String>>

      Future<bool?> i = Future.value(false);
      await i.futureLet((bool v) => i = Future.value(!v)); // futureLet<bool>
      expect(await i, true);
      i = Future<bool?>.value(null);
      bool value = false;
      await i.futureLet((bool v) => value = true); // futureLet<bool>
      expect(value, false);
    });
  });
}
