/// A mixin used for [NotifiableData] to represent receiver type with a [String] key.
mixin NotifyReceiverMixin {
  /// The receiver key stored in the listener list.
  String get receiverKey;
}

/// A simple notify receiver with [NotifyReceiverMixin].
class SimpleNotifyReceiver with NotifyReceiverMixin {
  const SimpleNotifyReceiver(this.receiverKey) : assert(receiverKey != null);

  /// [receiverKey] in [NotifyReceiverMixin].
  @override
  final String receiverKey;
}

/// A listener key used in [NotifiableData._listeners].
class _ListenerKey {
  const _ListenerKey(this.action, this.receiver, this.dataKey);

  final Function() action;
  final NotifyReceiverMixin receiver;
  final String dataKey;
}

/// An abstract data class with listeners list, which can notify the subscribers when [notify] invoked. Here subscribers (receivers) can have
/// different listener distinguished by dataKeys. There are three types of methods: [notify], [notifyDefault] and [notifyAll].
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
/// var testReceiver = SimpleNotifyReceiver('test'); // receiver
///
/// AuthState.instance.registerDefault(() => doSomething(), testReceiver); // register
/// AuthState.instance.token = 'new token';
/// AuthState.instance.notifyDefault(); // notify
/// ```
abstract class NotifiableData {
  final _listeners = <_ListenerKey>[]; // with receiver and dataKey

  // ==============================
  // xxx (use receiver and dataKey)
  // ==============================

  /// Register a listener using non-nullable [receiver] and [dataKey], returns false if duplicate entry exists.
  bool register(Function() listener, NotifyReceiverMixin receiver, String dataKey, {bool force = false}) {
    assert(force != null);
    assert(listener != null);
    assert(receiver != null && dataKey != null);

    if (force) {
      unregister(receiver, dataKey);
    }
    if (!contains(receiver, dataKey)) {
      _listeners.add(_ListenerKey(listener, receiver, dataKey));
      return true;
    }
    return false;
  }

  /// Unregisters a listener using non-nullable [receiver] and [dataKey].
  void unregister(NotifyReceiverMixin receiver, String dataKey) {
    assert(receiver != null && dataKey != null);
    _listeners.removeWhere((tuple) => tuple.receiver.receiverKey == receiver.receiverKey && tuple.dataKey == dataKey);
  }

  /// Checks existence of listener using non-nullable [receiver] and [dataKey].
  bool contains(NotifyReceiverMixin receiver, String dataKey) {
    assert(receiver != null && dataKey != null);
    return _listeners.any((tuple) => tuple.receiver.receiverKey == receiver.receiverKey && tuple.dataKey == dataKey);
  }

  /// Notifies all receivers using non-nullable [dataKey].
  void notify(String dataKey) {
    assert(dataKey != null);
    _listeners.where((tuple) => tuple.dataKey == dataKey).forEach((tuple) => tuple.action?.call());
  }

  // =============================================
  // xxxDefault (use receiver and default dataKey)
  // =============================================

  /// The default data key, used in [registerDefault], [unregisterDefault], [containsDefault] and [notifyDefault].
  String get defaultDataKey => '';

  /// Registers a listener using non-nullable [receiver] and [defaultDataKey], see [register].
  bool registerDefault(Function() listener, NotifyReceiverMixin receiver, {bool force = false}) {
    return register(listener, receiver, defaultDataKey, force: force);
  }

  /// Unregisters a listener using non-nullable [receiver] and [defaultDataKey], see [unregister].
  void unregisterDefault(NotifyReceiverMixin receiver) {
    unregister(receiver, defaultDataKey);
  }

  /// Checks existence of listener using non-nullable [receiver] and [defaultDataKey], see [contains].
  void containsDefault(NotifyReceiverMixin receiver) {
    contains(receiver, defaultDataKey);
  }

  /// Notifies all receivers using [defaultDataKey], see [notify].
  void notifyDefault() {
    return notify(defaultDataKey);
  }

  // =====================
  // xxxAll (use receiver)
  // =====================

  /// Unregisters all the listeners using non-nullable [receiver].
  void unregisterAll(NotifyReceiverMixin receiver) {
    assert(receiver != null);
    _listeners.removeWhere((tuple) => tuple.receiver.receiverKey == receiver.receiverKey);
  }

  /// Checks existence of listeners using non-nullable [receiver].
  bool containsAny(NotifyReceiverMixin receiver) {
    assert(receiver != null);
    return _listeners.any((tuple) => tuple.receiver.receiverKey == receiver.receiverKey);
  }

  /// Notifies all receivers.
  void notifyAll() {
    _listeners.forEach((tuple) => tuple.action?.call());
  }
}
