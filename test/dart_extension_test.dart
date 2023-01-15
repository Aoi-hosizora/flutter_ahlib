import 'package:flutter_ahlib/flutter_ahlib_util.dart';
import 'package:flutter_test/flutter_test.dart';

void expectThrow(void Function() f, String typeString) {
  try {
    f();
  } catch (e) {
    print(e);
    expect(e.runtimeType.toString(), typeString);
    return;
  }
  fail('should throw exception');
}

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

  group('IterableExtension', () {
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

  group('ListExtension', () {
    test('replaceWhere', () {
      expect([]..replaceWhere((el) => true, (el) => null), []);
      expect([0]..replaceWhere((el) => false, (el) => el * 2), [0]);
      expect([1]..replaceWhere((el) => true, (el) => el * 2), [2]);
      expect([-2, -1, 0, 1, 2]..replaceWhere((el) => el < 0, (el) => -el), [2, 1, 0, 1, 2]);
      expect([-2, -1, 0, 1, 2]..replaceFirstWhere((el) => el > 0, (el) => -el * 10), [-2, -1, 0, -10, 2]);
      expect(<dynamic>[0, '1', 2, '3.4']..replaceWhere((el) => el is String, (el) => int.tryParse(el)), [0, 1, 2, null]);
    });

    test('updateWhere', () {
      expect([]..updateWhere((el) => true, (el) {}), []);
      expect([Tuple1(1)]..updateWhere((el) => true, (el) => el.item *= 2), [Tuple1(2)]);
      expect(
        [Tuple1(-2), Tuple1(-1), Tuple1(0), Tuple1(1), Tuple1(2)]..updateWhere((el) => el.item < 0, (el) => el.item *= -1),
        [Tuple1(2), Tuple1(1), Tuple1(0), Tuple1(1), Tuple1(2)],
      );
      expect(
        [Tuple1(-2), Tuple1(-1), Tuple1(0), Tuple1(1), Tuple1(2)]..updateFirstWhere((el) => el.item > 0, (el) => el.item *= -10),
        [Tuple1(-2), Tuple1(-1), Tuple1(0), Tuple1(-10), Tuple1(2)],
      );
      expect(
        <dynamic>[Tuple1(0), Tuple1<dynamic>('1'), Tuple1(2), Tuple1<dynamic>('3.4')]..updateWhere((el) => el.item is String, (el) => el.item = int.tryParse(el.item)),
        [Tuple1(0), Tuple1(1), Tuple1(2), Tuple1(null)],
      );
    });
  });

  group('ObjectExtension', () {
    test('is & as', () {
      Object objI = 1;
      Object objD = 1.1;
      Object objS = '1';
      Object? objN;
      expect(objI.is_<int>(), true);
      expect(objD.is_<double>(), true);
      expect(objS.is_<String>(), true);
      expect(objI.is_<double>(), false);
      expect(objD.is_<String>(), false);
      expect(objS.is_<int>(), false);
      expect(objN?.is_(), null);

      dynamic dynI = 1;
      dynamic dynD = 1.1;
      dynamic dynS = '1';
      dynamic dynN;
      expect((dynI as Object?)?.as_<int>(), 1);
      expect((dynD as Object?)?.as_<double>(), 1.1);
      expect((dynS as Object?)?.as_<String>(), '1');
      expectThrow(() => dynI?.as_<double>(), '_CastError');
      expectThrow(() => dynD?.as_<String>(), '_CastError');
      expectThrow(() => dynS?.as_<int>(), '_CastError');
      expectThrow(() => dynN as Object, '_CastError'); // type 'Null' is not a subtype of type 'Object' in type cast
      expect((dynN as Object?)?.as_(), null); // => null dynamic to Object?
      expect((dynN as int?)?.as_(), null); // => null dynamic to int?

      expect(objI.asIf<int>(), 1);
      expect(objD.asIf<double>(), 1.1);
      expect(objS.asIf<String>(), '1');
      expect(objI.asIf<double>(), null);
      expect(objD.asIf<String>(), null);
      expect(objS.asIf<int>(), null);
      expect(dynI?.asIf<int>(), 1);
      expect(dynD?.asIf<double>(), 1.1);
      expect(dynS?.asIf<String>(), '1');
      expect(dynI?.asIf<double>(), null);
      expect(dynD?.asIf<String>(), null);
      expect(dynS?.asIf<int>(), null);

      int i = 1;
      double d = 1.1;
      String s = '1';
      int? ni = i;
      double? nd = d;
      String? ns = s;
      expect(i.is_<int?>(), true);
      expect(d.is_<double?>(), true);
      expect(s.is_<String?>(), true);
      expect(ni.is_<int>(), true);
      expect(nd.is_<double>(), true);
      expect(ns.is_<String>(), true);
      expect(ni.as_<int>(), i);
      expect(nd.as_<double>(), d);
      expect(ns.as_<String>(), s);
      ni = null;
      nd = null;
      ns = null;
      expect(ni?.is_<int>(), null);
      expect(nd?.is_<double>(), null);
      expect(ns?.is_<String>(), null);
    });

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
  });

  group('FutureExtension', () {
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
