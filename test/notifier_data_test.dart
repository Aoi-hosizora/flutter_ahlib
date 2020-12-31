import 'package:flutter_ahlib/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotifiableData', () {
    test('one data key', () {
      var testReceiver = SimpleNotifyReceiver('test');
      var indicator = 0;
      var f = () => indicator++;

      expect(AuthState.instance.registerDefault(f, testReceiver), true);
      expect(AuthState.instance.registerDefault(f, testReceiver), false);
      expect(AuthState.instance.registerDefault(f, testReceiver, force: true), true);

      expect(indicator, 0);
      AuthState.instance.notify('');
      expect(indicator, 1);
      AuthState.instance.notify('.');
      expect(indicator, 1);
      AuthState.instance.notifyDefault();
      expect(indicator, 2);
      AuthState.instance.notifyAll();
      expect(indicator, 3);
      AuthState.instance.unregisterDefault(testReceiver);

      expect(indicator, 3);
      AuthState.instance.notify('');
      expect(indicator, 3);
      AuthState.instance.notify('.');
      expect(indicator, 3);
      AuthState.instance.notifyDefault();
      expect(indicator, 3);
      AuthState.instance.notifyAll();
      expect(indicator, 3);
    });

    test('multiple data key', () {
      var testReceiver = SimpleNotifyReceiver('test');
      var indicator = 0;
      var f = () => indicator++;

      expect(AuthState.instance.register(f, testReceiver, '1'), true);
      expect(AuthState.instance.register(f, testReceiver, '2'), true);

      expect(indicator, 0);
      AuthState.instance.notify('');
      expect(indicator, 0);
      AuthState.instance.notifyDefault();
      expect(indicator, 0);
      AuthState.instance.notify('1');
      expect(indicator, 1);
      AuthState.instance.notify('2');
      expect(indicator, 2);
      AuthState.instance.notifyAll();
      expect(indicator, 4);
      AuthState.instance.notify('.');
      expect(indicator, 4);

      AuthState.instance.unregister(testReceiver, '1');
      AuthState.instance.notify('1');
      expect(indicator, 4);
      AuthState.instance.notify('2');
      expect(indicator, 5);
      AuthState.instance.notifyAll();
      expect(indicator, 6);

      AuthState.instance.unregisterAll(testReceiver);
      AuthState.instance.notifyAll();
      expect(indicator, 6);
    });
  });
}

class AuthState extends NotifiableData {
  AuthState._();

  static AuthState _instance;

  static AuthState get instance {
    return _instance ??= AuthState._();
  }

  String token = ''; // data field 1
  String username = ''; // data field 2
}
