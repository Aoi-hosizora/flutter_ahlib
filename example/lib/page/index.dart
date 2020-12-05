import 'package:flutter/material.dart';
import 'package:flutter_ahlib_example/page/widget/drawer_list_view.dart';
import 'package:flutter_ahlib_example/page/widget/dummy_view.dart';
import 'package:flutter_ahlib_example/page/widget/icon_text.dart';
import 'package:flutter_ahlib_example/page/widget/lazy_indexed_stack.dart';
import 'package:flutter_ahlib_example/page/widget/placeholder_text.dart';
import 'package:flutter_ahlib_example/page/widget/popup_menu.dart';
import 'package:flutter_ahlib_example/page/widget/scroll_fab.dart';
import 'package:flutter_ahlib_example/page/widget/sliver_container.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Widget _text(String text) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _button(String title, Widget page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: OutlineButton(
        child: Text(title),
        onPressed: page == null
            ? () {}
            : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => page,
                  ),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Ahlib Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _text('Widgets Example'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _button('PlaceholderText', PlaceholderTextPage()),
                _button('DrawerListView', DrawerListViewPage()),
                _button('IconText', IconTextPage()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _button('PopupMenu', PopupMenuPage()),
                _button('ScrollFloatingActionButton', ScrollFloatingActionButtonPage()),
                _button('SliverContainer', SliverContainerPage()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _button('DummyView', DummyViewPage()),
                _button('LazyIndexedStack', LazyIndexedStackPage()),
              ],
            ),
            _text('Lists Example'),
            _button('...', null),
            _text('Image Example'),
            _button('...', null),
          ],
        ),
      ),
    );
  }
}
