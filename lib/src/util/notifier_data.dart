import 'package:flutter/foundation.dart';
import 'package:flutter_ahlib/src/util/tuple.dart';

/// A mixin used for [NotifiableData] to represent receiver type with a String key.
/// You can implement this mixin in a class or use [SimpleNotifyReceiver].
mixin NotifyReceiverMixin {
  /// Represents the receiver key scored in the listener list.
  String get receiverKey;
}

/// A simple notify receiver with [NotifyReceiverMixin].
class SimpleNotifyReceiver with NotifyReceiverMixin {
  const SimpleNotifyReceiver(this.receiverKey) : assert(receiverKey != null);

  /// [receiverKey] in [NotifyReceiverMixin].
  @override
  final String receiverKey;
}

/// [NotifiableData] is a data class with listeners list, which can notify the subscriber when [notify] invoked.
/// Example:
/// ```
/// class AuthState extends NotifiableData {
///   AuthState._();
///   static AuthState _instance;
///   static AuthState get instance {
///     return _instance ??= AuthState._();
///   }
///
///   String token = ''; // data field
/// }
///
/// var testReceiver = SimpleNotifyReceiver('test');
/// AuthState.instance.registerListener(() => doSomething(), testReceiver);
///
/// AuthState.instance.token = 'new token';
/// AuthState.instance.notifyAll();
/// ```
abstract class NotifiableData {
  /// A immutable list of (listener, [NotifyReceiverMixin], dataKey).
  final _listeners = <Tuple3<Function(), NotifyReceiverMixin, String>>[];

  /// Represents the default [dataKey] (an empty string) used for [registerListener], [unregisterListener] and [containsListener],
  /// you can override this getter to use your data key.
  String get defaultDataKey => '';

  /// Registers [listener] with [NotifyReceiverMixin] and [dataKey] to listeners list, both [receiver] and [dataKey] are non-nullable.
  /// When [force] is true, [register] will check the list and throw an exception when find the listener has been existed in the list.
  @protected
  void register(Function() listener, NotifyReceiverMixin receiver, String dataKey, {bool force = false}) {
    assert(force != null);
    assert(receiver != null && dataKey != null);

    if (force) {
      unregister(receiver, dataKey);
    } else {
      assert(
        !contains(receiver, dataKey),
        'Duplicate key in NotifiableData listeners: (${receiver.receiverKey}, $dataKey)',
      );
    }
    _listeners.add(Tuple3(listener, receiver, dataKey));
  }

  /// Unregisters the all listeners by given [NotifyReceiverMixin] and [dataKey], when the [dataKey] is null, it will remove
  /// all listeners only by given [NotifyReceiverMixin].
  @protected
  void unregister(NotifyReceiverMixin receiver, [String dataKey]) {
    assert(receiver != null);
    if (dataKey == null) {
      _listeners.removeWhere((tuple) => tuple.item2.receiverKey == receiver.receiverKey);
    } else {
      _listeners.removeWhere((tuple) => tuple.item2.receiverKey == receiver.receiverKey && tuple.item3 == dataKey);
    }
  }

  /// Checks the listener exists by given [NotifyReceiverMixin] and [dataKey], when the [dataKey] is null, it will check only
  /// by given [NotifyReceiverMixin].
  @protected
  bool contains(NotifyReceiverMixin receiver, [String dataKey]) {
    assert(receiver != null);
    if (dataKey == null) {
      return _listeners.any((tuple) => tuple.item2.receiverKey == receiver.receiverKey);
    } else {
      return _listeners.any((tuple) => tuple.item2.receiverKey == receiver.receiverKey && tuple.item3 == dataKey);
    }
  }

  /// Notifies all listeners by given [dataKey], when the [dataKey] is null, it will notify all listeners.
  @protected
  void notify([String dataKey]) {
    var listeners = _listeners;
    if (dataKey != null) {
      listeners = _listeners.where((tuple) => tuple.item3 == dataKey).toList();
    }
    listeners.forEach((tuple) => tuple.item1?.call());
  }

  /// This is a helper function for [register] when ignored [dataKey] and will use the [defaultDataKey].
  void registerListener(Function() listener, NotifyReceiverMixin receiver, {bool force = false}) {
    register(listener, receiver, defaultDataKey, force: force);
  }

  /// This is a helper function for [unregister] when ignored [dataKey] and will use the [defaultDataKey].
  void unregisterListener(NotifyReceiverMixin receiver) {
    unregister(receiver, defaultDataKey);
  }

  /// This is a helper function for [contains] when ignored [dataKey] and will use the [defaultDataKey].
  void containsListener(NotifyReceiverMixin receiver) {
    contains(receiver, defaultDataKey);
  }

  /// This is a helper function for [notifyAll], it will notify all listeners.
  void notifyAll() {
    return notify();
  }
}
