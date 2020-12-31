import 'package:flutter/material.dart';
import 'package:flutter_ahlib_example/page/widget/drawer_list_view.dart';
import 'package:flutter_ahlib_example/page/widget/icon_text.dart';
import 'package:flutter_ahlib_example/page/widget/lazy_indexed_stack.dart';
import 'package:flutter_ahlib_example/page/widget/placeholder_text.dart';
import 'package:flutter_ahlib_example/page/widget/popup_menu.dart';
import 'package:flutter_ahlib_example/page/widget/scroll_animated_fab.dart';
import 'package:flutter_ahlib_example/page/widget/sliver_delegate.dart';
import 'package:flutter_ahlib_example/page/widget/tab_in_page_notification.dart';
import 'package:flutter_ahlib_example/page/widget/text_group.dart';

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

  Widget _button(String title, Widget page, [RouteSettings settings]) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: OutlineButton(
        child: Text(title),
        onPressed: () {
          if (page != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => page,
                settings: settings,
              ),
            );
          }
        },
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
                _button('DrawerListView', DrawerListViewPage(), RouteSettings(name: '.')),
                _button('IconText', IconTextPage()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _button('PopupMenu', PopupMenuPage()),
                _button('ScrollAnimatedFab', ScrollAnimatedFabPage()),
                _button('LazyIndexedStack', LazyIndexedStackPage()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _button('SliverDelegate', SliverDelegatePage()),
                _button('TextGroup', TextGroupPage()),
                _button('TabInPageNotification', TabInPageNotificationPage()),
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
