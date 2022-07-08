import 'package:flutter/material.dart';
import 'package:flutter_ahlib_example/page/image/local_or_cached_network_image_provider.dart';
import 'package:flutter_ahlib_example/page/image/reloadable_photo_view_gallery.dart';
import 'package:flutter_ahlib_example/page/list/append_indicator.dart';
import 'package:flutter_ahlib_example/page/list/pagination_listview.dart';
import 'package:flutter_ahlib_example/page/list/pagination_sliver_listview.dart';
import 'package:flutter_ahlib_example/page/list/pagination_masonry_gridview.dart';
import 'package:flutter_ahlib_example/page/list/refreshable_listview.dart';
import 'package:flutter_ahlib_example/page/list/refreshable_sliver_listview.dart';
import 'package:flutter_ahlib_example/page/list/refreshable_masonry_gridview.dart';
import 'package:flutter_ahlib_example/page/widget/custom_ink_feature.dart';
import 'package:flutter_ahlib_example/page/widget/drawer_list_view.dart';
import 'package:flutter_ahlib_example/page/widget/icon_text.dart';
import 'package:flutter_ahlib_example/page/widget/lazy_indexed_stack.dart';
import 'package:flutter_ahlib_example/page/widget/new_button_style.dart';
import 'package:flutter_ahlib_example/page/widget/placeholder_text.dart';
import 'package:flutter_ahlib_example/page/widget/popup_list_menu.dart';
import 'package:flutter_ahlib_example/page/widget/animated_fab.dart';
import 'package:flutter_ahlib_example/page/widget/sliver_delegate.dart';
import 'package:flutter_ahlib_example/page/widget/tab_in_page_notification.dart';
import 'package:flutter_ahlib_example/page/widget/text_group.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Widget _text(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _button(String title, Widget page, [RouteSettings? settings]) {
    return ElevatedButton(
      child: Text(title),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => page,
            settings: settings,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Ahlib Example'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(6),
          shrinkWrap: true,
          children: [
            Align(
              alignment: Alignment.center,
              child: _text('Widgets Example'),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                _button('PlaceholderText', const PlaceholderTextPage()),
                _button('DrawerListView', const DrawerListViewPage(), const RouteSettings(name: '.')),
                _button('IconText', const IconTextPage()),
                _button('PopupListMenu', const PopupListMenuPage()),
                _button('AnimatedFab', const AnimatedFabPage()),
                _button('LazyIndexedStack', const LazyIndexedStackPage()),
                _button('SliverDelegate', const SliverDelegatePage()),
                _button('TextGroup', const TextGroupPage()),
                _button('TabInPageNotification', const TabInPageNotificationPage()),
                _button('CustomInkFeature', const CustomInkFeaturePage()),
                _button('NewButtonStyle', const NewButtonThemePage()),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: _text('Lists Example'),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                _button('AppendIndicator', const AppendIndicatorPage()),
                _button('RefreshableListView', const RefreshableListViewPage()),
                _button('RefreshableSliverListView', const RefreshableSliverListViewPage()),
                _button('RefreshableMasonryGridView', const RefreshableMasonryGridViewPage()),
                _button('PaginationListView', const PaginationListViewPage()),
                _button('PaginationSliverListView', const PaginationSliverListViewPage()),
                _button('PaginationMasonryGridView', const PaginationMasonryGridViewPage()),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: _text('Images Example'),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                _button('LocalOrCachedNetworkImageProvider', const LocalOrCachedNetworkImageProviderPage()),
                _button('ReloadablePhotoViewGallery', const ReloadablePhotoViewGalleryPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
