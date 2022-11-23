import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/page/image/extended_photo_gallery.dart';
import 'package:flutter_ahlib_example/page/image/local_or_cached_network_image_provider.dart';
import 'package:flutter_ahlib_example/page/image/reloadable_photo_view.dart';
import 'package:flutter_ahlib_example/page/list/append_indicator.dart';
import 'package:flutter_ahlib_example/page/list/pagination_nosliver_data_view.dart';
import 'package:flutter_ahlib_example/page/list/pagination_sliver_data_view.dart';
import 'package:flutter_ahlib_example/page/list/refreshable_nosliver_data_view.dart';
import 'package:flutter_ahlib_example/page/list/refreshable_sliver_data_view.dart';
import 'package:flutter_ahlib_example/page/util/extended_logger.dart';
import 'package:flutter_ahlib_example/page/util/flutter_extension.dart';
import 'package:flutter_ahlib_example/page/widget/animated_fab.dart';
import 'package:flutter_ahlib_example/page/widget/app_bar_action_button.dart';
import 'package:flutter_ahlib_example/page/widget/custom_ink_feature.dart';
import 'package:flutter_ahlib_example/page/widget/custom_ink_response.dart';
import 'package:flutter_ahlib_example/page/widget/custom_page_route.dart';
import 'package:flutter_ahlib_example/page/widget/custom_single_child_layout.dart';
import 'package:flutter_ahlib_example/page/widget/extended_nested_scroll_view.dart';
import 'package:flutter_ahlib_example/page/widget/extended_scrollbar.dart';
import 'package:flutter_ahlib_example/page/widget/icon_text.dart';
import 'package:flutter_ahlib_example/page/widget/lazy_indexed_stack.dart';
import 'package:flutter_ahlib_example/page/widget/nested_page_view_notifier.dart';
import 'package:flutter_ahlib_example/page/widget/new_button_style.dart';
import 'package:flutter_ahlib_example/page/widget/placeholder_text.dart';
import 'package:flutter_ahlib_example/page/widget/popup_dialog_option.dart';
import 'package:flutter_ahlib_example/page/widget/preloadable_page_view.dart';
import 'package:flutter_ahlib_example/page/widget/sliver_delegate.dart';
import 'package:flutter_ahlib_example/page/widget/table_whole_row_ink_well.dart';
import 'package:flutter_ahlib_example/page/widget/text_group.dart';
import 'package:flutter_ahlib_example/page/widget/text_selection_config.dart';
import 'package:flutter_ahlib_example/page/widget/video_progress_indicator.dart';
import 'package:flutter_ahlib_example/page/widget/widget_with_callback.dart';

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
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }

  Widget _button(String title, Widget page) {
    return ElevatedButton(
      child: Text(title),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => page,
          ),
        );
      },
    );
  }

  Widget _listView({required List<Widget> children, EdgeInsets padding = EdgeInsets.zero}) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Ahlib Example'),
      ),
      body: _listView(
        padding: const EdgeInsets.all(6),
        children: [
          _button('TestPage', const TestPage()),
          Align(
            alignment: Alignment.center,
            child: _text('Widget Examples'),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _button('PlaceholderText', const PlaceholderTextPage()),
              _button('IconText', const IconTextPage()),
              _button('PopupDialogOption', const PopupDialogOptionPage()),
              _button('AnimatedFab', const AnimatedFabPage()),
              _button('LazyIndexedStack', const LazyIndexedStackPage()),
              _button('SliverDelegate', const SliverDelegatePage()),
              _button('TextGroup', const TextGroupPage()),
              _button('NestedPageViewNotifier', const NestedPageViewNotifierPage()),
              _button('CustomInkFeature', const CustomInkFeaturePage()),
              _button('NewButtonStyle', const NewButtonThemePage()),
              _button('PreloadablePageView', const PreloadablePageViewPage()),
              _button('TextSelectionConfig', const TextSelectionConfigPage()),
              _button('CustomInkResponse', const CustomInkResponsePage()),
              _button('TableWholeRowInkWell', const TableWholeRowInkWellPage()),
              _button('WidgetWithCallback', const WidgetWithCallbackPage()),
              _button('ExtendedScrollbar', const ExtendedScrollbarPage()),
              _button('ExtendedNestedScrollView', const ExtendedNestedScrollViewPage()),
              _button('VideoProgressIndicator', const VideoProgressIndicatorPage()),
              _button('CustomSingleChildLayout', const CustomSingleChildLayoutPage()),
              _button('AppBarActionButton', const AppBarActionButtonPage()),
              _button('CustomPageRoute', const CustomPageRoutePage()),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: _text('List Examples'),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _button('AppendIndicator', const AppendIndicatorPage()),
              _button('RefreshableNoSliverDataView', const RefreshableNoSliverDataViewPage()),
              _button('RefreshableSliverDataView', const RefreshableSliverDataViewPage()),
              _button('PaginationNoSliverDataView', const PaginationNoSliverDataViewPage()),
              _button('PaginationSliverDataView', const PaginationSliverDataViewPage()),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: _text('Image Examples'),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _button('LocalOrCachedNetworkImageProvider', const LocalOrCachedNetworkImageProviderPage()),
              _button('ReloadablePhotoView', const ReloadablePhotoViewPage()),
              _button('ExtendedPhotoGallery', const ExtendedPhotoGalleryPage()),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: _text('Util Examples'),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _button('FlutterExtension', const FlutterExtensionPage()),
              _button('ExtendedLogger', const ExtendedLoggerPage()),
            ],
          ),
        ],
      ),
    );
  }
}

class AlwaysOverscrollPhysics extends ClampingScrollPhysics {
  const AlwaysOverscrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  AlwaysOverscrollPhysics applyTo(ScrollPhysics? ancestor) {
    return AlwaysOverscrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    return value - position.pixels;
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  final _length = 4;
  late final _tabController = TabController(length: _length, vsync: this);
  final _drawerKey = GlobalKey<CustomDrawerControllerState>();
  var _drawerOpening = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener(
          onNotification: (n) {
            if (n is OverscrollNotification && n.dragDetails != null) {
              if (n.dragDetails!.delta.dx > 0) {
                if (!_drawerOpening) {
                  _drawerOpening = true;
                  if (_tabController.length > 1) {
                    if (mounted) setState(() {});
                  }
                }
                _drawerKey.currentState?.move(n.dragDetails!);
              } else if (_drawerOpening && n.dragDetails!.delta.dx < 0) {
                _drawerKey.currentState?.move(n.dragDetails!);
              }
            }
            if (n is ScrollEndNotification && _drawerOpening) {
              _drawerOpening = false;
              if (_tabController.length > 1) {
                if (mounted) setState(() {});
              }
              _drawerKey.currentState?.settle(n.dragDetails ?? DragEndDetails());
            }
            if (n is OverscrollIndicatorNotification && _drawerOpening) {
              n.disallowIndicator();
            }
            return false;
          },
          child: Scaffold(
            drawerEdgeDragWidth: 50,
            drawer: const Drawer(
              child: Center(
                child: Text('yyy'),
              ),
            ),
            appBar: AppBar(
              title: const Text('TestPage'),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: !_drawerOpening ? const AlwaysScrollableScrollPhysics() : const AlwaysOverscrollPhysics(),
              children: [
                for (var i = 0; i < _length; i++)
                  Row(
                    children: [
                      Container(width: 20, color: Colors.purple),
                      Container(width: 50 - 20, color: Colors.grey),
                      Expanded(
                        child: Container(
                          color: [Colors.red, Colors.yellow, Colors.blue, Colors.green][i % 4],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        CustomDrawerController(
          key: _drawerKey,
          edgeDragWidth: 20,
          alignment: DrawerAlignment.start,
          child: const Drawer(
            child: Center(
              child: Text('xxx'),
            ),
          ),
        ),
      ],
    );
  }
}
