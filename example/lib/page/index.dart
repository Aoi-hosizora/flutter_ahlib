import 'package:flutter/material.dart';
import 'package:flutter_ahlib_example/page/widget/drawer_list_view.dart';
import 'package:flutter_ahlib_example/page/widget/dummy_view.dart';
import 'package:flutter_ahlib_example/page/widget/icon_text.dart';
import 'package:flutter_ahlib_example/page/widget/placeholder_text.dart';
import 'package:flutter_ahlib_example/page/widget/popup_menu.dart';
import 'package:flutter_ahlib_example/page/widget/scroll_fab.dart';

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
    return OutlineButton(
      child: Text(title),
      onPressed: page == null
          ? () {}
          : () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => page,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _text('Widgets Example'),
            _button('PlaceholderText', PlaceholderTextPage()),
            _button('DrawerListView', DrawerListViewPage()),
            _button('IconText', IconTextPage()),
            _button('PopupMenu', PopupMenuPage()),
            _button('ScrollFloatingActionButton', ScrollFloatingActionButtonPage()),
            _button('DummyView', DummyViewPage()),
            _text('Lists Example'),
            _button('......', null),
            _text('Image Example'),
            _button('......', null),
          ],
        ),
      ),
    );
  }
}
