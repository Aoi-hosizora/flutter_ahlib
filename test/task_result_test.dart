import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ahlib/flutter_ahlib_util.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> expectThrow(FutureOr<void> Function() f, Object o) async {
  try {
    await f();
    fail('should throw exception');
  } catch (e) {
    expect(e, o);
  }
}

void main() {
  group('TaskResult', () {
    test('expect and unwrap', () async {
      var ok = const Ok(2); // Ok<int, Object>
      var err = const Err('emergency failure'); // Err<Object, String>

      expect(ok.data, 2);
      expect(ok.error == null, true);
      expect(ok.isOk, true);
      expect(ok.isErr, false);
      expect(ok.toString(), 'AsyncResult.ok(2)');
      expect(ok.hashCode, hashValues(2, null));
      expect(ok == const Ok<int, Object>(2), true);

      expect(err.data == null, true);
      expect(err.error, 'emergency failure');
      expect(err.isOk, false);
      expect(err.isErr, true);
      expect(err.toString(), 'AsyncResult.err(emergency failure)');
      expect(err.hashCode, hashValues(null, 'emergency failure'));
      expect(err == const Err<Object, String>('emergency failure'), true);

      expect(ok.expect('testing expect'), 2);
      expect(ok.unwrap(), 2);
      expect(ok.unwrapOr(1), 2);
      expect(ok.unwrapOrElse((e) => 1), 2);
      expect(await ok.unwrapOrElseAsync((e) async => 1), 2);
      await expectThrow(() => ok.expectErr('testing expectErr'), 'testing expectErr');
      await expectThrow(() => ok.unwrapErr(), 2);

      await expectThrow(() => err.expect('testing expect'), 'testing expect');
      await expectThrow(() => err.unwrap(), 'emergency failure');
      expect(err.unwrapOr(1), 1);
      expect(err.unwrapOrElse((e) => e.length), 17);
      expect(await err.unwrapOrElseAsync((e) async => e.length), 17);
      expect(err.expectErr('testing expectErr'), 'emergency failure');
      expect(err.unwrapErr(), 'emergency failure');
    });

    test('fromFunc and inspect', () async {
      var x = resultFromFunc(() => int.parse('4')); // TaskResult<int, Object>
      var y = resultFromFunc(() => int.parse('x')); // TaskResult<int, Object>
      var ax = resultFromAsyncFunc(() => Future.value(int.parse('4'))); // Future<TaskResult<int, Object>>
      var ay = resultFromAsyncFunc(() => Future.value(int.parse('x'))); // Future<TaskResult<int, Object>>

      var tmpX = '';
      var tmpY = '';
      expect(x.inspect((i) => tmpX = 'original: $i').map((i) => i * i * i).expect('failed to parse number'), 64);
      expect(tmpX, 'original: 4');
      await expectThrow(() => y.inspect((i) => tmpY = 'original: $i').map((i) => i * i * i).expect('failed to parse number'), 'failed to parse number');
      expect(tmpY, '');

      tmpX = '';
      tmpY = '';
      await expectThrow(() => x.inspectErr((e) => tmpX = 'error: ${e.runtimeType}').mapErr((e) => e.runtimeType.toString() * 2).expectErr('success to parse number'), 'success to parse number');
      expect(tmpX, '');
      expect(y.inspectErr((e) => tmpY = 'error: ${e.runtimeType}').mapErr((e) => e.runtimeType.toString() * 2).expectErr('success to parse number'), 'FormatExceptionFormatException');
      expect(tmpY, 'error: FormatException');

      tmpX = '';
      tmpY = '';
      expect((await (await (await ax).inspectAsync((i) async => tmpX = 'original: $i')).mapAsync((i) async => i * i * i)).expect('failed to parse number'), 64);
      expect(tmpX, 'original: 4');
      await expectThrow(() async => (await (await y.inspectAsync((i) async => tmpY = 'original: $i')).mapAsync((i) async => i * i * i)).expect('failed to parse number'), 'failed to parse number');
      expect(tmpY, '');

      tmpX = '';
      tmpY = '';
      await expectThrow(() async => (await (await x.inspectErrAsync((e) async => tmpX = 'error: ${e.runtimeType}')).mapErrAsync((e) async => e.runtimeType.toString() * 2)).expectErr('success to parse number'), 'success to parse number');
      expect(tmpX, '');
      expect((await (await (await ay).inspectErrAsync((e) async => tmpY = 'error: ${e.runtimeType}')).mapErrAsync((e) async => e.runtimeType.toString() * 2)).expectErr('success to parse number'), 'FormatExceptionFormatException');
      expect(tmpY, 'error: FormatException');
    });

    test('map and contains', () async {
      var x = const Ok<String, String>('foo');
      var y = const Err<String, String>('bar');

      expect(x.map((i) => i.length).unwrap(), 3);
      expect(x.mapOr(42, (i) => i.length).unwrap(), 3);
      expect(x.mapOrElse((i) => i.length * 2, (i) => i.length).unwrap(), 3);
      expect(x.mapErr((i) => i.length).unwrap(), 'foo');
      await expectThrow(() => x.mapErr((i) => i.length).unwrapErr(), 'foo');

      await expectThrow(() => y.map((i) => i.length).unwrap(), 'bar');
      expect(y.mapOr(42, (i) => i.length).unwrap(), 42);
      expect(y.mapOrElse((i) => i.length * 2, (i) => i.length).unwrap(), 6);
      await expectThrow(() => y.mapErr((i) => i.length).unwrap(), 3);
      expect(y.mapErr((i) => i.length).unwrapErr(), 3);

      expect((await x.mapAsync((i) async => i.length)).unwrap(), 3);
      expect((await x.mapOrAsync(42, (i) async => i.length)).unwrap(), 3);
      expect((await x.mapOrElseAsync((i) async => i.length * 2, (i) async => i.length)).unwrap(), 3);
      expect((await x.mapErrAsync((i) async => i.length)).unwrap(), 'foo');
      await expectThrow(() async => (await x.mapErrAsync((i) async => i.length)).unwrapErr(), 'foo');

      await expectThrow(() async => (await y.mapAsync((i) async => i.length)).unwrap(), 'bar');
      expect((await y.mapOrAsync(42, (i) async => i.length)).unwrap(), 42);
      expect((await y.mapOrElseAsync((i) async => i.length * 2, (i) async => i.length)).unwrap(), 6);
      await expectThrow(() async => (await y.mapErrAsync((i) async => i.length)).unwrap(), 3);
      expect((await y.mapErrAsync((i) async => i.length)).unwrapErr(), 3);
    });

    test('and and or', () async {
      var x1 = const Ok<int, String>(2);
      var y1 = const Err<String, String>('late error');
      expect(x1.and(y1), const Err<String, String>('late error'));

      var x2 = const Err<int, String>('early error');
      var y2 = const Ok<String, String>('foo');
      expect(x2.and(y2), const Err<String, String>('early error'));

      var x3 = const Err<int, String>('not a 2');
      var y3 = const Err<String, String>('late error');
      expect(x3.and(y3), const Err<String, String>('not a 2'));

      var x4 = const Ok<int, String>(2);
      var y4 = const Ok<String, String>('different result type');
      expect(x4.and(y4), const Ok<String, String>('different result type'));

      var z1 = const Ok<int, String>(2);
      var w1 = const Err<int, String>('late error');
      expect(z1.or(w1), const Ok<int, String>(2));

      var z2 = const Err<int, String>('early error');
      var w2 = const Ok<int, String>(2);
      expect(z2.or(w2), const Ok<int, String>(2));

      var z3 = const Err<int, String>('not a 2');
      var w3 = const Err<int, String>('late error');
      expect(z3.or(w3), const Err<int, String>('late error'));

      var z4 = const Ok<int, String>(2);
      var w4 = const Ok<int, String>(100);
      expect(z4.or(w4), const Ok<int, String>(2));

      // ignore: prefer_function_declarations_over_variables
      var sq = (int x) => Ok<int, int>(x * x);
      // ignore: prefer_function_declarations_over_variables
      var err = (int x) => Err<int, int>(x);

      expect(const Ok<int, int>(2).andThen(sq).andThen(sq), const Ok<int, int>(16));
      expect(const Ok<int, int>(2).andThen(sq).andThen(err), const Err<int, int>(4));
      expect(const Ok<int, int>(2).andThen(err).andThen(sq), const Err<int, int>(2));
      expect(const Ok<int, int>(2).andThen(err).andThen(err), const Err<int, int>(2));
      expect(const Err<int, int>(3).andThen(sq).andThen(sq), const Err<int, int>(3));
      expect(const Err<int, int>(3).andThen(sq).andThen(err), const Err<int, int>(3));
      expect(const Err<int, int>(3).andThen(err).andThen(sq), const Err<int, int>(3));
      expect(const Err<int, int>(3).andThen(err).andThen(err), const Err<int, int>(3));

      expect(const Ok<int, int>(2).orElse(sq).orElse(sq), const Ok<int, int>(2));
      expect(const Ok<int, int>(2).orElse(sq).orElse(err), const Ok<int, int>(2));
      expect(const Ok<int, int>(2).orElse(err).orElse(sq), const Ok<int, int>(2));
      expect(const Ok<int, int>(2).orElse(err).orElse(err), const Ok<int, int>(2));
      expect(const Err<int, int>(3).orElse(sq).orElse(sq), const Ok<int, int>(9));
      expect(const Err<int, int>(3).orElse(sq).orElse(err), const Ok<int, int>(9));
      expect(const Err<int, int>(3).orElse(err).orElse(sq), const Ok<int, int>(9));
      expect(const Err<int, int>(3).orElse(err).orElse(err), const Err<int, int>(3));

      // ignore: prefer_function_declarations_over_variables
      var sqAsync = (int x) async => Ok<int, int>(x * x);
      // ignore: prefer_function_declarations_over_variables
      var errAsync = (int x) async => Err<int, int>(x);

      expect(await (await const Ok<int, int>(2).andThenAsync(sqAsync)).andThenAsync(sqAsync), const Ok<int, int>(16));
      expect(await (await const Ok<int, int>(2).andThenAsync(errAsync)).andThenAsync(errAsync), const Err<int, int>(2));
      expect(await (await const Err<int, int>(3).andThenAsync(sqAsync)).andThenAsync(sqAsync), const Err<int, int>(3));
      expect(await (await const Err<int, int>(3).andThenAsync(errAsync)).andThenAsync(errAsync), const Err<int, int>(3));

      expect(await (await const Ok<int, int>(2).orElseAsync(sqAsync)).orElseAsync(sqAsync), const Ok<int, int>(2));
      expect(await (await const Ok<int, int>(2).orElseAsync(errAsync)).orElseAsync(errAsync), const Ok<int, int>(2));
      expect(await (await const Err<int, int>(3).orElseAsync(sqAsync)).orElseAsync(sqAsync), const Ok<int, int>(9));
      expect(await (await const Err<int, int>(3).orElseAsync(errAsync)).orElseAsync(errAsync), const Err<int, int>(3));
    });
  });
}
