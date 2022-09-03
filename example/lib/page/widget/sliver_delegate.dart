import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class SliverDelegatePage extends StatefulWidget {
  const SliverDelegatePage({Key? key}) : super(key: key);

  @override
  _SliverDelegatePageState createState() => _SliverDelegatePageState();
}

class _SliverDelegatePageState extends State<SliverDelegatePage> {
  bool _useHeaderBuilder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SliverDelegate Example'),
        actions: [
          IconButton(
            icon: Text(_useHeaderBuilder ? 'Builder' : 'Child'),
            onPressed: () {
              _useHeaderBuilder = !_useHeaderBuilder;
              if (mounted) setState(() {});
            },
          )
        ],
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
              delegate: !_useHeaderBuilder
                  ? SliverHeaderDelegate(
                      child: PreferredSize(
                        preferredSize: const Size.fromHeight(30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          color: Colors.red,
                          child: const Center(
                            child: Text('SliverHeaderDelegate'),
                          ),
                        ),
                      ),
                    )
                  : SliverHeaderDelegate.builder(
                      minHeight: 30,
                      maxHeight: 30,
                      builder: (_, __, ___) => PreferredSize(
                        preferredSize: const Size.fromHeight(30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          color: Colors.red,
                          child: const Center(
                            child: Text('SliverHeaderDelegate.builder'),
                          ),
                        ),
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
                    8,
                    (i) => ListTile(title: Text('item $i'), onTap: () {}),
                  ),
                  separator: const Divider(height: 1, thickness: 1),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
              SliverList(
                delegate: SliverSeparatedListBuilderDelegate(
                  (c, i) => ListTile(title: Text('item $i'), onTap: () {}),
                  childCount: 8,
                  separatorBuilder: (c, i) => Divider(height: 1, thickness: i.toDouble()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
