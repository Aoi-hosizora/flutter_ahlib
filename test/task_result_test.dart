import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ahlib/flutter_ahlib_util.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> expectThrow(FutureOr<void> Function() f, dynamic o) async {
  try {
    await f();
  } catch (e) {
    // print(e);
    if (o is Function(dynamic)) {
      o(e);
    } else {
      expect(e, o);
    }
    return;
  }
  fail('should throw exception');
}

Future<T> v<T>(T t) async {
  await Future.delayed(const Duration(milliseconds: 200));
  return t;
}

Future<void> Function(T) f<T>(FutureOr<void> Function(T) f) {
  return (i) async {
    await Future.delayed(const Duration(milliseconds: 200));
    await f(i);
  };
}

void main() {
  group('TaskResult', () {
    test('expect and unwrap', () async {
      var ok = const Ok(2); // Ok<int, Object>
      var err = const Err('emergency failure'); // Err<Object, String>

      // properties on Ok
      expect(ok.data, 2);
      expect(ok.error == null, true);
      expect(ok.isOk, true);
      expect(ok.isErr, false);
      expect(ok.toString(), 'AsyncResult.ok(2)');
      expect(ok.hashCode, hashValues(2, null));
      expect(ok == const Ok<int, Object>(2), true);

      // properties on Err
      expect(err.data == null, true);
      expect(err.error, 'emergency failure');
      expect(err.isOk, false);
      expect(err.isErr, true);
      expect(err.toString(), 'AsyncResult.err(emergency failure)');
      expect(err.hashCode, hashValues(null, 'emergency failure'));
      expect(err == const Err<Object, String>('emergency failure'), true);

      // expect/unwrap on Ok
      expect(ok.expect('testing expect'), 2);
      expect(ok.unwrap(), 2);
      expect(ok.unwrapOr(1), 2);
      expect(ok.unwrapOrElse((e) => 1), 2);
      expect(await ok.unwrapOrElseAsync((e) => v(1)), 2);
      await expectThrow(() => ok.expectErr('testing expectErr'), 'testing expectErr');
      await expectThrow(() => ok.unwrapErr(), 2);

      // expect/unwrap on Err
      await expectThrow(() => err.expect('testing expect'), 'testing expect');
      await expectThrow(() => err.unwrap(), 'emergency failure');
      expect(err.unwrapOr(1), 1);
      expect(err.unwrapOrElse((e) => e.length), 17);
      expect(await err.unwrapOrElseAsync((e) => v(e.length)), 17);
      expect(err.expectErr('testing expectErr'), 'emergency failure');
      expect(err.unwrapErr(), 'emergency failure');
    });

    test('fromFunc and inspect', () async {
      var x = resultFromFunc(() => int.parse('4')); // TaskResult<int, Object>
      var y = resultFromFunc(() => int.parse('x')); // TaskResult<int, Object>
      var ax = resultFromAsyncFunc(() => Future.value(int.parse('4'))); // Future<TaskResult<int, Object>>
      var ay = resultFromAsyncFunc(() => Future.value(int.parse('x'))); // Future<TaskResult<int, Object>>

      // inspect/map
      var tmpX = '';
      var tmpY = '';
      expect(x.inspect((i) => tmpX = 'origin: $i').map((i) => i * i * i).expect('failed to parse'), 64);
      expect(tmpX, 'origin: 4');
      await expectThrow(() => y.inspect((i) => tmpY = 'origin: $i').map((i) => i * i * i).expect('failed to parse'), 'failed to parse');
      expect(tmpY, '');

      // inspectErr/mapErr
      tmpX = '';
      tmpY = '';
      await expectThrow(() => x.inspectErr((e) => tmpX = 'error: ${e.runtimeType}').mapErr((e) => '${e.runtimeType}' * 2).expectErr('success to parse'), 'success to parse');
      expect(tmpX, '');
      expect(y.inspectErr((e) => tmpY = 'error: ${e.runtimeType}').mapErr((e) => '${e.runtimeType}' * 2).expectErr('success to parse'), 'FormatExceptionFormatException');
      expect(tmpY, 'error: FormatException');

      // inspect/map on Future (also for testing extension)
      tmpX = '';
      tmpY = '';
      expect(await ax.inspect((i) => tmpX = 'origin: $i').map((i) => i * i * i).expect('failed to parse'), 64);
      expect(tmpX, 'origin: 4');
      await expectThrow(() async => await ay.inspect((i) => tmpY = 'origin: $i').map((i) => i * i * i).expect('failed to parse'), 'failed to parse');
      expect(tmpY, '');

      // inspectErr/mapErr on Future (also for testing extension)
      tmpX = '';
      tmpY = '';
      await expectThrow(() async => await ax.inspectErr((e) => tmpX = 'error: ${e.runtimeType}').mapErr((e) => '${e.runtimeType}' * 2).expectErr('success to parse'), 'success to parse');
      expect(tmpX, '');
      expect(await ay.inspectErr((e) => tmpY = 'error: ${e.runtimeType}').mapErr((e) => '${e.runtimeType}' * 2).expectErr('success to parse'), 'FormatExceptionFormatException');
      expect(tmpY, 'error: FormatException');

      // inspectAsync/mapAsync on Future (also for testing extension)
      tmpX = '';
      tmpY = '';
      expect(await ax.inspectAsync(f((i) => tmpX = 'origin: $i')).mapAsync((i) => v(i * i * i)).expect('failed to parse'), 64);
      expect(tmpX, 'origin: 4');
      await expectThrow(() async => await ay.inspectAsync(f((i) => tmpY = 'origin: $i')).mapAsync((i) => v(i * i * i)).expect('failed to parse'), 'failed to parse');
      expect(tmpY, '');

      // inspectErrAsync/mapErrAsync on Future (also for testing extension)
      tmpX = '';
      tmpY = '';
      await expectThrow(() async => await ax.inspectErrAsync(f((e) => tmpX = 'error: ${e.runtimeType}')).mapErrAsync((e) => v('${e.runtimeType}' * 2)).expectErr('success to parse'), 'success to parse');
      expect(tmpX, '');
      expect(await ay.inspectErrAsync(f((e) => tmpY = 'error: ${e.runtimeType}')).mapErrAsync((e) => v('${e.runtimeType}' * 2)).expectErr('success to parse'), 'FormatExceptionFormatException');
      expect(tmpY, 'error: FormatException');

      // other callings on Future<Ok> (for testing extension)
      expect(await ax.data, 4);
      expect(await ax.error, null);
      expect(await ax.isOk, true);
      expect(await ax.isErr, false);
      expect(await ax.expect('test expect'), 4);
      expect(await ax.unwrap(), 4);
      expect(await ax.unwrapOr(1), 4);
      expect(await ax.unwrapOrElse((e) => 1), 4);
      expect(await ax.unwrapOrElseAsync((e) => v(1)), 4);
      await expectThrow(() async => await ax.expectErr('testing expectErr'), 'testing expectErr');
      await expectThrow(() async => await ax.unwrapErr(), 4);

      // other callings on Future<Err> (for testing extension)
      expect(await ay.data, null);
      expect((await ay.error).runtimeType.toString(), 'FormatException');
      expect(await ay.isOk, false);
      expect(await ay.isErr, true);
      await expectThrow(() async => await ay.expect('test expect'), 'test expect');
      await expectThrow(() async => await ay.unwrap(), (e) => expect(e.runtimeType.toString(), 'FormatException'));
      expect(await ay.unwrapOr(1), 1);
      expect(await ay.unwrapOrElse((e) => e.runtimeType.toString().length), 15);
      expect(await ay.unwrapOrElseAsync((e) => v(e.runtimeType.toString().length)), 15);
      expect((await ay.expectErr('testing expectErr')).runtimeType.toString(), 'FormatException');
      expect((await ay.unwrapErr()).runtimeType.toString(), 'FormatException');
    });

    test('map', () async {
      var x = const Ok<String, String>('foo');
      var y = const Err<String, String>('bar');
      var ax = v(const Ok<String, String>('foo'));
      var ay = v(const Err<String, String>('bar'));

      // map series on Ok
      expect(x.map((i) => i.length).unwrap(), 3);
      expect(x.mapOr(42, (i) => i.length).unwrap(), 3);
      expect(x.mapOrElse((i) => i.length * 2, (i) => i.length).unwrap(), 3);
      expect(x.mapErr((i) => i.length).unwrap(), 'foo');
      await expectThrow(() => x.mapErr((i) => i.length).unwrapErr(), 'foo');

      // map series on Err
      await expectThrow(() => y.map((i) => i.length).unwrap(), 'bar');
      expect(y.mapOr(42, (i) => i.length).unwrap(), 42);
      expect(y.mapOrElse((i) => i.length * 2, (i) => i.length).unwrap(), 6);
      await expectThrow(() => y.mapErr((i) => i.length).unwrap(), 3);
      expect(y.mapErr((i) => i.length).unwrapErr(), 3);

      // mapAsync series on Ok
      expect(await x.mapAsync((i) => v(i.length)).unwrap(), 3);
      expect(await x.mapOrAsync(42, (i) => v(i.length)).unwrap(), 3);
      expect(await x.mapOrElseAsync((i) => v(i.length * 2), (i) async => i.length).unwrap(), 3);
      expect(await x.mapErrAsync((i) => v(i.length)).unwrap(), 'foo');
      await expectThrow(() async => await x.mapErrAsync((i) => v(i.length)).unwrapErr(), 'foo');

      // mapAsync series on Err
      await expectThrow(() async => await y.mapAsync((i) => v(i.length)).unwrap(), 'bar');
      expect(await y.mapOrAsync(42, (i) => v(i.length)).unwrap(), 42);
      expect(await y.mapOrElseAsync((i) => v(i.length * 2), (i) => v(i.length)).unwrap(), 6);
      await expectThrow(() async => await y.mapErrAsync((i) => v(i.length)).unwrap(), 3);
      expect(await y.mapErrAsync((i) => v(i.length)).unwrapErr(), 3);

      // map series on Future<Ok> (for testing extension)
      expect(await ax.map((i) => i.length).unwrap(), 3);
      expect(await ax.mapOr(42, (i) => i.length).unwrap(), 3);
      expect(await ax.mapOrElse((i) => i.length * 2, (i) => i.length).unwrap(), 3);
      expect(await ax.mapErr((i) => i.length).unwrap(), 'foo');
      await expectThrow(() async => await ax.mapErr((i) => i.length).unwrapErr(), 'foo');

      // mapAsync series on Future<Err> (for testing extension)
      await expectThrow(() async => await ay.mapAsync((i) => v(i.length)).unwrap(), 'bar');
      expect(await ay.mapOrAsync(42, (i) => v(i.length)).unwrap(), 42);
      expect(await ay.mapOrElseAsync((i) => v(i.length * 2), (i) => v(i.length)).unwrap(), 6);
      await expectThrow(() async => await ay.mapErrAsync((i) => v(i.length)).unwrap(), 3);
      expect(await ay.mapErrAsync((i) => v(i.length)).unwrapErr(), 3);
    });

    test('and and or', () async {
      // and/or
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

      // andThen/orElse on Ok/Err
      sq(int x) => Ok<int, int>(x * x);
      err(int x) => Err<int, int>(x);
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

      // andThenAsync/orElseAsync on Ok/Err (part of andThen/orElse)
      sqAsync(int x) => v(Ok<int, int>(x * x));
      errAsync(int x) => v(Err<int, int>(x));
      expect(await const Ok<int, int>(2).andThenAsync(sqAsync).andThenAsync(sqAsync), const Ok<int, int>(16));
      expect(await const Ok<int, int>(2).andThenAsync(errAsync).andThenAsync(errAsync), const Err<int, int>(2));
      expect(await const Err<int, int>(3).andThenAsync(sqAsync).andThenAsync(sqAsync), const Err<int, int>(3));
      expect(await const Err<int, int>(3).andThenAsync(errAsync).andThenAsync(errAsync), const Err<int, int>(3));
      expect(await const Ok<int, int>(2).orElseAsync(sqAsync).orElseAsync(sqAsync), const Ok<int, int>(2));
      expect(await const Ok<int, int>(2).orElseAsync(errAsync).orElseAsync(errAsync), const Ok<int, int>(2));
      expect(await const Err<int, int>(3).orElseAsync(sqAsync).orElseAsync(sqAsync), const Ok<int, int>(9));
      expect(await const Err<int, int>(3).orElseAsync(errAsync).orElseAsync(errAsync), const Err<int, int>(3));

      // and/or on Future (for testing extension)
      expect(await v(x1).and(y1), const Err<String, String>('late error'));
      expect(await v(x2).and(y2), const Err<String, String>('early error'));
      expect(await v(x3).and(y3), const Err<String, String>('not a 2'));
      expect(await v(x4).and(y4), const Ok<String, String>('different result type'));
      expect(await v(z1).or(w1), const Ok<int, String>(2));
      expect(await v(z2).or(w2), const Ok<int, String>(2));
      expect(await v(z3).or(w3), const Err<int, String>('late error'));
      expect(await v(z4).or(w4), const Ok<int, String>(2));

      // andThen/orElse/andThenAsync/orElseAsync on Future (for testing extension)
      expect(await v(const Ok<int, int>(2)).andThen(sq).andThen(sq), const Ok<int, int>(16));
      expect(await v(const Ok<int, int>(2)).andThen(err).andThen(err), const Err<int, int>(2));
      expect(await v(const Err<int, int>(3)).andThen(sq).andThen(sq), const Err<int, int>(3));
      expect(await v(const Err<int, int>(3)).andThen(err).andThen(err), const Err<int, int>(3));
      expect(await v(const Ok<int, int>(2)).orElse(sq).orElse(sq), const Ok<int, int>(2));
      expect(await v(const Ok<int, int>(2)).orElse(err).orElse(err), const Ok<int, int>(2));
      expect(await v(const Err<int, int>(3)).orElse(sq).orElse(sq), const Ok<int, int>(9));
      expect(await v(const Err<int, int>(3)).orElse(err).orElse(err), const Err<int, int>(3));
      expect(await v(const Ok<int, int>(2)).andThenAsync(sqAsync).andThenAsync(sqAsync), const Ok<int, int>(16));
      expect(await v(const Ok<int, int>(2)).andThenAsync(errAsync).andThenAsync(errAsync), const Err<int, int>(2));
      expect(await v(const Err<int, int>(3)).andThenAsync(sqAsync).andThenAsync(sqAsync), const Err<int, int>(3));
      expect(await v(const Err<int, int>(3)).andThenAsync(errAsync).andThenAsync(errAsync), const Err<int, int>(3));
      expect(await v(const Ok<int, int>(2)).orElseAsync(sqAsync).orElseAsync(sqAsync), const Ok<int, int>(2));
      expect(await v(const Ok<int, int>(2)).orElseAsync(errAsync).orElseAsync(errAsync), const Ok<int, int>(2));
      expect(await v(const Err<int, int>(3)).orElseAsync(sqAsync).orElseAsync(sqAsync), const Ok<int, int>(9));
      expect(await v(const Err<int, int>(3)).orElseAsync(errAsync).orElseAsync(errAsync), const Err<int, int>(3));
    });
  });
}
