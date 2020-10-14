import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test ActionController', () {
    var controller = ActionController();
    controller.addAction('1', () => print('1'));
    controller.addAction('2', () => 2);
    controller.addAction('3', () => print);

    controller.invoke('1');
    print(controller.invoke('2'));
    controller.invoke<void Function(Object)>('3')('3');
    print(controller.invoke('4'));
  });
}
