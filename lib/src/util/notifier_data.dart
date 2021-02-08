/// A mixin used for [NotifiableData] to represent the receiver type with a [String] receiver key.
mixin NotifyReceiverMixin {
  /// The receiver key stored in the callback list.
  String get receiverKey;
}

/// A simple notify receiver with [NotifyReceiverMixin].
class SimpleNotifyReceiver with NotifyReceiverMixin {
  const SimpleNotifyReceiver(
    this.receiverKey,
  ) : assert(receiverKey != null);

  /// The receiver key of the receiver.
  @override
  final String receiverKey;
}

/// A callback key used in [NotifiableData._callbacks], includes three parts: receiver, dataKey and callback.
class _CallbackKey {
  const _CallbackKey(this.receiver, this.dataKey, this.callback);

  final NotifyReceiverMixin receiver;
  final String dataKey;
  final Function() callback; // distinguish by function reference
}

/// An abstract data class with callbacks list, which can notify the subscribers when [notify] invoked. Here subscribers (receivers) can have
/// different callbacks distinguished by different dataKeys. There are three types of methods: [notify], [notifyDefault] and [notifyAll].
///
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
/// // register callback to default dataKey "" and SimpleNotifyReceiver
/// AuthState.instance.registerDefault(SimpleNotifyReceiver('test'), () => doSomething());
/// AuthState.instance.token = 'new token';
/// AuthState.instance.notifyDefault(); // notify
/// ```
abstract class NotifiableData {
  final _callbacks = <_CallbackKey>[];

  // ==============================
  // xxx (use receiver and dataKey)
  // ==============================

  /// Registers a callback using non-null [receiver] and [dataKey], returns false if not force and exists duplicate entry.
  bool register(NotifyReceiverMixin receiver, String dataKey, Function() callback, {bool force = false}) {
    assert(receiver != null && dataKey != null);
    assert(callback != null);
    assert(force != null);

    var exist = contains(receiver, dataKey);
    if (exist && force) {
      unregister(receiver, dataKey); // force to register, unregister first
    }
    if (!exist || force) {
      _callbacks.add(_CallbackKey(receiver, dataKey, callback));
      return true;
    }
    return false;
  }

  /// Unregisters a callback using non-null [receiver] and [dataKey].
  void unregister(NotifyReceiverMixin receiver, String dataKey) {
    assert(receiver != null && dataKey != null);
    _callbacks.removeWhere((t) => t.receiver.receiverKey == receiver.receiverKey && t.dataKey == dataKey);
  }

  /// Checks existence of callback using non-null [receiver] and [dataKey].
  bool contains(NotifyReceiverMixin receiver, String dataKey) {
    assert(receiver != null && dataKey != null);
    return _callbacks.any((t) => t.receiver.receiverKey == receiver.receiverKey && t.dataKey == dataKey);
  }

  /// Notifies all receivers and calls all callbacks using non-null [dataKey].
  void notify(String dataKey) {
    assert(dataKey != null);
    _callbacks.where((t) => t.dataKey == dataKey).forEach((t) => t.callback?.call());
  }

  // =============================================
  // xxxDefault (use receiver and default dataKey)
  // =============================================

  /// The default data key, can be override, used in [registerDefault], [unregisterDefault], [containsDefault] and [notifyDefault].
  String get defaultDataKey => '';

  /// Registers a callback using non-null [receiver] and [defaultDataKey], see [register].
  bool registerDefault(NotifyReceiverMixin receiver, Function() callback, {bool force = false}) {
    return register(receiver, defaultDataKey, callback, force: force);
  }

  /// Unregisters a callback using non-null [receiver] and [defaultDataKey], see [unregister].
  void unregisterDefault(NotifyReceiverMixin receiver) {
    unregister(receiver, defaultDataKey);
  }

  /// Checks existence of callback using non-null [receiver] and [defaultDataKey], see [contains].
  void containsDefault(NotifyReceiverMixin receiver) {
    contains(receiver, defaultDataKey);
  }

  /// Notifies all receivers and calls all callbacks using [defaultDataKey], see [notify].
  void notifyDefault() {
    return notify(defaultDataKey);
  }

  // =====================
  // xxxAll (use receiver)
  // =====================

  /// Unregisters all the callbacks using non-null [receiver].
  void unregisterAll(NotifyReceiverMixin receiver) {
    assert(receiver != null);
    _callbacks.removeWhere((t) => t.receiver.receiverKey == receiver.receiverKey);
  }

  /// Checks existence of callbacks using non-null [receiver].
  bool containsAny(NotifyReceiverMixin receiver) {
    assert(receiver != null);
    return _callbacks.any((t) => t.receiver.receiverKey == receiver.receiverKey);
  }

  /// Notifies all receivers and calls all callbacks.
  void notifyAll() {
    _callbacks.forEach((t) => t.callback?.call());
  }
}
