import 'dart:async';

import 'package:flutter/cupertino.dart';

/// A type that represent either ok(success) or err(failure), and is referred from rust's
/// `std::Result`.
///
/// Note that if you want to catch exceptions from async task such as [Future.microtask],
/// you can not only use [runZonedGuarded], but also set the type of returned value to
/// [Future<Result>] and await the [Future] whenever you want.
abstract class TaskResult<T extends Object, E extends Object> {
  /// Creates an ok result, with given nullable data.
  const TaskResult.ok(T this._data) : _error = null;

  /// Creates an err result, with given non-null data.
  const TaskResult.err(E this._error) : _data = null;

  final T? _data;
  final E? _error;

  /// Returns the data of the result, this value will not be null if [isOk] is true.
  T? get data => _data;

  /// Returns the error of the result, this value will not be null if [isErr] is true.
  E? get error => _error;

  /// Returns true if the result is ok, which means [error] is null.
  bool get isOk => _data != null;

  /// Returns true if the result is err, which means [error] is not null.
  bool get isErr => _error != null;

  /// Unwraps the result, returns [data] if ok, otherwise throws given [msg].
  T expect(Object msg) {
    if (isErr) {
      throw msg;
    }
    return data!;
  }

  /// Unwraps the result, returns [data] if ok, otherwise throws [error].
  T unwrap() {
    if (isErr) {
      throw error!;
    }
    return data!;
  }

  /// Unwraps the result, returns [data] if ok, otherwise returns given [defaultValue].
  T unwrapOr(T defaultValue) {
    if (isErr) {
      return defaultValue;
    }
    return data!;
  }

  /// Unwraps the result, returns [data] if ok, otherwise computes it from given [op].
  T unwrapOrElse(T Function(E error) op) {
    if (isErr) {
      return op(error!);
    }
    return data!;
  }

  /// This is the async version of [unwrapOrElse].
  Future<T> unwrapOrElseAsync(FutureOr<T> Function(E error) op) async {
    if (isErr) {
      return await op(error!);
    }
    return data!;
  }

  /// Unwraps the result, returns [error] if err, otherwise throws given [msg].
  E expectErr(Object msg) {
    if (isOk) {
      throw msg;
    }
    return error!;
  }

  /// Unwraps the result, returns [error] if err, otherwise throws [data].
  E unwrapErr() {
    if (isOk) {
      throw data!;
    }
    return error!;
  }

  /// Calls given [op] if ok and returns the result as is.
  TaskResult<T, E> inspect(void Function(T data) op) {
    if (isOk) {
      op(data!);
    }
    return this;
  }

  /// This is the async version of [inspect].
  Future<TaskResult<T, E>> inspectAsync(FutureOr<void> Function(T data) op) async {
    if (isOk) {
      await op(data!);
    }
    return this;
  }

  /// Calls given [op] if err and returns the result as is.
  TaskResult<T, E> inspectErr(void Function(E error) op) {
    if (isErr) {
      op(error!);
    }
    return this;
  }

  /// This is the async version of [inspectErr].
  Future<TaskResult<T, E>> inspectErrAsync(FutureOr<void> Function(E error) op) async {
    if (isErr) {
      await op(error!);
    }
    return this;
  }

  /// Maps the result to result with data computed by given [op].
  TaskResult<U, E> map<U extends Object>(U Function(T data) op) {
    if (isOk) {
      return Ok(op(data!));
    }
    return Err(error!);
  }

  /// This is the async version of [map].
  Future<TaskResult<U, E>> mapAsync<U extends Object>(FutureOr<U> Function(T data) op) async {
    if (isOk) {
      return Ok(await op(data!));
    }
    return Err(error!);
  }

  /// Maps the result to result with data computed by given [defaultValue] value and [op].
  TaskResult<U, E> mapOr<U extends Object>(U defaultValue, U Function(T data) op) {
    if (isErr) {
      return Ok(defaultValue);
    }
    return Ok(op(data!));
  }

  /// This is the async version of [mapOr].
  Future<TaskResult<U, E>> mapOrAsync<U extends Object>(U defaultValue, FutureOr<U> Function(T data) op) async {
    if (isErr) {
      return Ok(defaultValue);
    }
    return Ok(await op(data!));
  }

  /// Maps the result to result with data computed by given [defaultValue] and [op].
  TaskResult<U, E> mapOrElse<U extends Object>(U Function(E error) defaultValue, U Function(T data) op) {
    if (isErr) {
      return Ok(defaultValue(error!));
    }
    return Ok(op(data!));
  }

  /// This is the async version of [mapOrElse].
  Future<TaskResult<U, E>> mapOrElseAsync<U extends Object>(FutureOr<U> Function(E error) defaultValue, FutureOr<U> Function(T data) op) async {
    if (isErr) {
      return Ok(await defaultValue(error!));
    }
    return Ok(await op(data!));
  }

  /// Maps the result to result with target error computed by given [op].
  TaskResult<T, F> mapErr<F extends Object>(F Function(E error) op) {
    if (isErr) {
      return Err(op(error!));
    }
    return Ok(data!);
  }

  /// This is the async version of [mapOrElse].
  Future<TaskResult<T, F>> mapErrAsync<F extends Object>(FutureOr<F> Function(E error) op) async {
    if (isErr) {
      return Err(await op(error!));
    }
    return Ok(data!);
  }

  /// Returns [res] if ok, otherwise returns [error] in corresponding type.
  TaskResult<U, E> and<U extends Object>(TaskResult<U, E> res) {
    if (isOk) {
      return res;
    }
    return Err(error!);
  }

  /// Returns the result computed by [op], otherwise returns [error] in corresponding type.
  TaskResult<U, E> andThen<U extends Object>(TaskResult<U, E> Function(T data) op) {
    if (isOk) {
      return op(data!);
    }
    return Err(error!);
  }

  /// This is the async version of [andThen].
  Future<TaskResult<U, E>> andThenAsync<U extends Object>(FutureOr<TaskResult<U, E>> Function(T data) op) async {
    if (isOk) {
      return await op(data!);
    }
    return Err(error!);
  }

  /// Returns [res] if err, otherwise returns [data] in corresponding type.
  TaskResult<T, F> or<F extends Object>(TaskResult<T, F> res) {
    if (isErr) {
      return res;
    }
    return Ok(data!);
  }

  /// Returns the result computed by [op], otherwise returns [data] in corresponding type.
  TaskResult<T, F> orElse<F extends Object>(TaskResult<T, F> Function(E error) op) {
    if (isErr) {
      return op(error!);
    }
    return Ok(data!);
  }

  /// This is the async version of [orElse].
  Future<TaskResult<T, F>> orElseAsync<F extends Object>(FutureOr<TaskResult<T, F>> Function(E error) op) async {
    if (isErr) {
      return await op(error!);
    }
    return Ok(data!);
  }

  @override
  String toString() => isOk ? 'AsyncResult.ok($data)' : 'AsyncResult.err($error)';

  @override
  int get hashCode => hashValues(data, error);

  @override
  bool operator ==(Object other) {
    return other is TaskResult<T, E> && other.data == data && other.error == error;
  }
}

/// A type that represent a ok [TaskResult].
class Ok<T extends Object, E extends Object> extends TaskResult<T, E> {
  /// Creates an ok result with given [data].
  const Ok(T data) : super.ok(data);
}

/// A type that represent a err [TaskResult].
class Err<T extends Object, E extends Object> extends TaskResult<T, E> {
  /// Creates an err result with given [error].
  const Err(E error) : super.err(error);
}

/// Returns a result by executing given function and catching current type of exception.
TaskResult<T, E> resultFromFunc<T extends Object, E extends Object>(T Function() func) {
  try {
    return Ok(func());
  } on E catch (e) {
    return Err(e);
  }
}

/// Returns a result by executing given async function and catching current type of exception.
Future<TaskResult<T, E>> resultFromAsyncFunc<T extends Object, E extends Object>(FutureOr<T> Function() func) async {
  try {
    return Ok(await func());
  } on E catch (e) {
    return Err(e);
  }
}

/// An extension of [Future<TaskResult>] type, which has the same methods as [TaskResult].
extension TaskResultFutureExtension<T extends Object, E extends Object> on Future<TaskResult<T, E>> {
  Future<T?> get data => then((r) => r.data);

  Future<E?> get error => then((r) => r.error);

  Future<bool> get isOk => then((r) => r.isOk);

  Future<bool> get isErr => then((r) => r.isErr);

  Future<T> expect(Object msg) => then((r) => r.expect(msg));

  Future<T> unwrap() => then((r) => r.unwrap());

  Future<T> unwrapOr(T defaultValue) => then((r) => r.unwrapOr(defaultValue));

  Future<T> unwrapOrElse(T Function(E error) op) => then((r) => r.unwrapOrElse(op));

  Future<T> unwrapOrElseAsync(FutureOr<T> Function(E error) op) => then((r) => r.unwrapOrElseAsync(op));

  Future<E> expectErr(Object msg) => then((r) => r.expectErr(msg));

  Future<E> unwrapErr() => then((r) => r.unwrapErr());

  Future<TaskResult<T, E>> inspect(void Function(T data) op) => then((r) => r.inspect(op));

  Future<TaskResult<T, E>> inspectAsync(FutureOr<void> Function(T data) op) => then((r) => r.inspectAsync(op));

  Future<TaskResult<T, E>> inspectErr(void Function(E error) op) => then((r) => r.inspectErr(op));

  Future<TaskResult<T, E>> inspectErrAsync(FutureOr<void> Function(E error) op) => then((r) => r.inspectErrAsync(op));

  Future<TaskResult<U, E>> map<U extends Object>(U Function(T data) op) => then((r) => r.map(op));

  Future<TaskResult<U, E>> mapAsync<U extends Object>(FutureOr<U> Function(T data) op) => then((r) => r.mapAsync(op));

  Future<TaskResult<U, E>> mapOr<U extends Object>(U defaultValue, U Function(T data) op) => then((r) => r.mapOr(defaultValue, op));

  Future<TaskResult<U, E>> mapOrAsync<U extends Object>(U defaultValue, FutureOr<U> Function(T data) op) => then((r) => r.mapOrAsync(defaultValue, op));

  Future<TaskResult<U, E>> mapOrElse<U extends Object>(U Function(E error) defaultValue, U Function(T data) op) => then((r) => r.mapOrElse(defaultValue, op));

  Future<TaskResult<U, E>> mapOrElseAsync<U extends Object>(FutureOr<U> Function(E error) defaultValue, FutureOr<U> Function(T data) op) => then((r) => r.mapOrElseAsync(defaultValue, op));

  Future<TaskResult<T, F>> mapErr<F extends Object>(F Function(E error) op) => then((r) => r.mapErr(op));

  Future<TaskResult<T, F>> mapErrAsync<F extends Object>(FutureOr<F> Function(E error) op) async => then((r) => r.mapErrAsync(op));

  Future<TaskResult<U, E>> and<U extends Object>(TaskResult<U, E> res) => then((r) => r.and(res));

  Future<TaskResult<U, E>> andThen<U extends Object>(TaskResult<U, E> Function(T data) op) => then((r) => r.andThen(op));

  Future<TaskResult<U, E>> andThenAsync<U extends Object>(FutureOr<TaskResult<U, E>> Function(T data) op) => then((r) => r.andThenAsync(op));

  Future<TaskResult<T, F>> or<F extends Object>(TaskResult<T, F> res) => then((r) => r.or(res));

  Future<TaskResult<T, F>> orElse<F extends Object>(TaskResult<T, F> Function(E error) op) => then((r) => r.orElse(op));

  Future<TaskResult<T, F>> orElseAsync<F extends Object>(FutureOr<TaskResult<T, F>> Function(E error) op) => then((r) => r.orElseAsync(op));
}
