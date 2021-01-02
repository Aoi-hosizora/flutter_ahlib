import 'package:flutter/material.dart';
import 'package:flutter_ahlib_example/page/list/pagination_listview.dart';
import 'package:flutter_ahlib_example/page/list/pagination_sliver_listview.dart';
import 'package:flutter_ahlib_example/page/list/pagination_staggered_gridview.dart';
import 'package:flutter_ahlib_example/page/list/refreshable_listview.dart';
import 'package:flutter_ahlib_example/page/list/refreshable_sliver_listview.dart';
import 'package:flutter_ahlib_example/page/list/refreshable_staggered_gridview.dart';
import 'package:flutter_ahlib_example/page/widget/drawer_list_view.dart';
import 'package:flutter_ahlib_example/page/widget/function_painter.dart';
import 'package:flutter_ahlib_example/page/widget/icon_text.dart';
import 'package:flutter_ahlib_example/page/widget/lazy_indexed_stack.dart';
import 'package:flutter_ahlib_example/page/widget/placeholder_text.dart';
import 'package:flutter_ahlib_example/page/widget/popup_menu.dart';
import 'package:flutter_ahlib_example/page/widget/animated_fab.dart';
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
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _button(String title, Widget page, [RouteSettings settings]) {
    return OutlineButton(
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
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                _button('PlaceholderText', PlaceholderTextPage()),
                _button('DrawerListView', DrawerListViewPage(), RouteSettings(name: '.')),
                _button('IconText', IconTextPage()),
                _button('PopupMenu', PopupMenuPage()),
                _button('AnimatedFab', AnimatedFabPage()),
                _button('LazyIndexedStack', LazyIndexedStackPage()),
                _button('SliverDelegate', SliverDelegatePage()),
                _button('TextGroup', TextGroupPage()),
                _button('TabInPageNotification', TabInPageNotificationPage()),
                _button('FunctionPainter', FunctionPainterPage()),
              ],
            ),
            _text('Lists Example'),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                _button('RefreshableListView', RefreshableListViewPage()),
                _button('RefreshableSliverListView', RefreshableSliverListViewPage()),
                _button('RefreshableStaggeredGridView', RefreshableStaggeredGridViewPage()),
                _button('PaginationListView', PaginationListViewPage()),
                _button('PaginationSliverListView', PaginationSliverListViewPage()),
                _button('PaginationStaggeredGridView', PaginationStaggeredGridViewPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
