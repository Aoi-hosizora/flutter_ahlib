import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ActionController, () {
    test('an empty ctrl', () {
      var controller = ActionController();

      expect(controller.getAction(''), null);
      expect(controller.containAction(''), false);
      expect(controller.invoke(''), null);
    });

    test('use null in ctrl', () {
      var controller = ActionController();
      controller.addAction('1', null);
      controller.addAction(null, () => '1');
      controller.addAction(null, null);

      expect(controller.getAction('1'), null);
      expect(controller.containAction('1'), true);
      expect(controller.invoke('1'), null);

      expect(controller.getAction(null), null);
      expect(controller.containAction(null), true);
      expect(controller.invoke(null), null);

      controller.removeAction('1');
      controller.removeAction(null);

      expect(controller.getAction('1'), null);
      expect(controller.containAction('1'), false);
      expect(controller.invoke('1'), null);

      expect(controller.getAction(null), null);
      expect(controller.containAction(null), false);
      expect(controller.invoke(null), null);
    });

    test('a normal ctrl', () {
      var controller = ActionController();
      controller.addAction('1', () => null);
      controller.addAction('2', () => 2);
      controller.addAction('3', () => () => 3);

      // expect(controller.getAction('1'), () => null);
      expect(controller.containAction('1'), true);
      expect(controller.invoke('1'), null);

      // expect(controller.getAction('2'), () => 2);
      expect(controller.containAction('2'), true);
      expect(controller.invoke<int>('2'), 2);

      // expect(controller.getAction('3'), () => () => 3);
      expect(controller.containAction('3'), true);
      expect(controller.invoke<int Function()>('3')(), 3);
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
}
