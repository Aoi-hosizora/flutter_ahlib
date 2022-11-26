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
  group('ActionController', () {
    test('an empty ctrl', () {
      var controller = ActionController();

      expect(controller.getAction(''), null);
      expect(controller.containsAction(''), false);
      expect(controller.invoke(''), null);
    });

    test('use null in ctrl', () {
      var controller = ActionController();
      controller.addAction('1', () => null);
      controller.addAction(null, () => '1');
      controller.addAction(null, () => null);

      // expect(controller.getAction('1'), () => null);
      expect(controller.containsAction('1'), true);
      expect(controller.invoke('1'), null);

      // expect(controller.getAction(null), () => null);
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

    test('test parameters', () {
      var controller = ActionController();

      controller.addAction();
      expect(controller.containsAction(), false);
      expect(controller.getAction() == null, true);
      expect(controller.invoke(), null);

      controller.addAction('');
      expect(controller.containsAction(''), false);
      expect(controller.getAction('') == null, true);
      expect(controller.invoke(''), null);

      controller.addAction(() => 1);
      expect(controller.containsAction(), true);
      expect(controller.getAction() == null, false);
      expect(controller.invoke(), 1);

      controller.removeAction();
      expect(controller.containsAction(''), false);
      expect(controller.getAction('') == null, true);
      expect(controller.invoke(''), null);
    });

    test('a normal ctrl', () {
      var controller = ActionController();
      controller.addAction('1', () => null);
      controller.addAction('2', () => 2);
      controller.addAction('3', () => () => 3);

      expect(controller.getAction('1') is Null Function(), true);
      expect(controller.containsAction('1'), true);
      expect(controller.invoke('1'), null);
      expectThrow(() => controller.getAction<int Function()>('1'), '_CastError'); // <<< `as` failed

      expect(controller.getAction('2') is int Function(), true);
      expect(controller.containsAction('2'), true);
      expect(controller.invoke<int>('2'), 2);
      expectThrow(() => controller.invoke<String>('2'), '_CastError'); // <<< `as` failed

      expect(controller.getAction('3') is int Function() Function(), true);
      expect(controller.containsAction('3'), true);
      expect(controller.invoke<int Function()>('3')!(), 3);

      expect(controller.invokeWhere((k) => k == '1' || k == '2'), [null, 2]);

      controller.dispose();
      expect(controller.containsAction('1'), false);
      expect(controller.containsAction('2'), false);
      expect(controller.containsAction('3'), false);
    });
  });
}
