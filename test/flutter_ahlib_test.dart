import 'package:flutter_ahlib/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ActionController, () {
    test('an empty ctrl', () {
      var controller = ActionController();

      expect(controller.getAction(''), null);
      expect(controller.containsAction(''), false);
      expect(controller.invoke(''), null);
    });

    test('use null in ctrl', () {
      var controller = ActionController();
      controller.addAction('1', null);
      controller.addAction(null, () => '1');
      controller.addAction(null, null);

      expect(controller.getAction('1'), null);
      expect(controller.containsAction('1'), true);
      expect(controller.invoke('1'), null);

      expect(controller.getAction(null), null);
      expect(controller.containsAction(null), true);
      expect(controller.invoke(null), null);

      controller.removeAction('1');
      controller.removeAction(null);

      expect(controller.getAction('1'), null);
      expect(controller.containsAction('1'), false);
      expect(controller.invoke('1'), null);

      expect(controller.getAction(null), null);
      expect(controller.containsAction(null), false);
      expect(controller.invoke(null), null);
    });

    test('a normal ctrl', () {
      var controller = ActionController();
      controller.addAction('1', () => null);
      controller.addAction('2', () => 2);
      controller.addAction('3', () => () => 3);

      // expect(controller.getAction('1'), () => null);
      expect(controller.containsAction('1'), true);
      expect(controller.invoke('1'), null);

      // expect(controller.getAction('2'), () => 2);
      expect(controller.containsAction('2'), true);
      expect(controller.invoke<int>('2'), 2);

      // expect(controller.getAction('3'), () => () => 3);
      expect(controller.containsAction('3'), true);
      expect(controller.invoke<int Function()>('3')(), 3);

      expect(controller.invokeWhere((k) => k == '1' || k == '2'), [null, 2]);
    });
  });

  group(Tuple2, () {
    test('constructor', () {
      var t = Tuple2<int, String>(1, '2');
      var t2 = Tuple2<int, String>(1, '2');

      expect(t.item1, 1);
      expect(t.item2, '2');
      expect(t.toString(), '[1, 2]');
      expect(t == t2, true);
    });

    test('tuple to list', () {
      var t = Tuple2.fromList([1, '2']);
      var t2 = Tuple2<int, String>(1, '2');

      expect(t.item1, 1);
      expect(t.item2, '2');
      expect(t.toList(), [1, '2']);
      expect(t == t2, true);
    });
  });

  group(hashObjects, () {
    test('hashObjects', () {
      var h = hashObjects(['123', 456]);
      expect(h, isA<int>());
      h = hashObjects(['123', null]);
      expect(h, isA<int>());
      h = hashObjects([null, null]);
      expect(h, isA<int>());
    });

    test('hash', () {
      var h = hash2('123', 456);
      expect(h, isA<int>());
      h = hash3('123', 456, true);
      expect(h, isA<int>());
      h = hash4('123', 456, true, []);
      expect(h, isA<int>());
      h = hash5('123', 456, true, [], null);
      expect(h, isA<int>());
      h = hash6('123', 456, true, [], null, 0.1);
      expect(h, isA<int>());
    });
  });

  group(filesize, () {
    test('filesize', () {
      expect(filesize(0), "0 B");
      expect(filesize(1023), "1023 B");
      expect(filesize(1024), "1 KB");
      expect(filesize(1030), "1.01 KB");
      expect(filesize(1536), "1.50 KB");
      expect(filesize(2048), "2 KB");
      expect(filesize(1024 * 1024), "1 MB");
      expect(filesize((2.51 * 1024 * 1024).toInt()), "2.51 MB");
      expect(filesize((1024 * 1024 * 1024).toInt()), "1 GB");
      expect(filesize((2.51 * 1024 * 1024 * 1024).toInt()), "2.51 GB");
      expect(filesize((1024 * 1024 * 1024 * 1024).toInt()), "1 TB");
      expect(filesize((1.1 * 1024 * 1024 * 1024 * 1024).toInt()), "1.10 TB");
    });

    test('round', () {
      expect(filesize(1023, 4), "1023 B");
      expect(filesize(1024, 4), "1 KB");
      expect(filesize(1030, 4), "1.0059 KB");
      expect(filesize(1536, 4), "1.5000 KB");
      expect(filesize(2048, 4), "2 KB");
    });

    test('space', () {
      expect(filesize(1023, 0, true), "1023 B");
      expect(filesize(1023, 1, true), "1023 B");
      expect(filesize(1023, 0, false), "1023B");
      expect(filesize(1023, 1, false), "1023B");
    });
  });

  group(NotifiableData, () {
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
