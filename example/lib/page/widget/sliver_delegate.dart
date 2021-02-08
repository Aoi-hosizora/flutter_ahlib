import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class SliverDelegatePage extends StatefulWidget {
  @override
  _SliverDelegatePageState createState() => _SliverDelegatePageState();
}

class _SliverDelegatePageState extends State<SliverDelegatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverDelegate Example'),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (c, _) => [
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Colors.yellow,
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(c),
            sliver: SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: SliverAppBarSizedDelegate(
                minHeight: 30,
                maxHeight: 30,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
        body: Builder(
          builder: (c) => CustomScrollView(
            controller: PrimaryScrollController.of(c),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(c),
              ),
              SliverList(
                delegate: SliverSeparatedListDelegate(
                  List.generate(
                    5,
                    (i) => ListTile(title: Text('item $i')),
                  ),
                  separator: Divider(height: 1, thickness: 1),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 30)),
              SliverList(
                delegate: SliverSeparatedListBuilderDelegate(
                  (c, i) => ListTile(title: Text('item $i')),
                  childCount: 5,
                  separatorBuilder: (c, i) => Divider(height: 1, thickness: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
