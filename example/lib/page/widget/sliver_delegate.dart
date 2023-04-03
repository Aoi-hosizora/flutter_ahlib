import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class SliverDelegatePage extends StatefulWidget {
  const SliverDelegatePage({Key? key}) : super(key: key);

  @override
  _SliverDelegatePageState createState() => _SliverDelegatePageState();
}

class _SliverDelegatePageState extends State<SliverDelegatePage> {
  bool _useHeaderBuilder = false;
  bool _pinned = true;
  bool _nothing = false;
  bool _fewer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SliverDelegate Example'),
        actions: [
          IconButton(
            icon: Text(_pinned ? 'Pinned' : 'NoPinned'),
            onPressed: () {
              _pinned = !_pinned;
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: Text(_nothing
                ? 'Nothing'
                : _fewer
                    ? 'Fewer'
                    : 'More'),
            onPressed: () {
              if (_nothing) {
                _nothing = false;
                _fewer = true;
              } else if (_fewer) {
                _nothing = false;
                _fewer = false;
              } else {
                _nothing = true;
                _fewer = false;
              }
              if (mounted) setState(() {});
            },
          ),
          IconButton(
            icon: Text(_useHeaderBuilder ? 'Builder' : 'Child'),
            onPressed: () {
              _useHeaderBuilder = !_useHeaderBuilder;
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (c, _) => [
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.yellow, Colors.blue],
                ),
              ),
              height: 200,
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(c),
            sliver: SliverPersistentHeader(
              pinned: _pinned,
              floating: true,
              delegate: !_useHeaderBuilder
                  ? SliverHeaderDelegate(
                      child: PreferredSize(
                        preferredSize: const Size.fromHeight(30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
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
        body: _nothing
            ? Center(
                child: Text(
                  'Nothing',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : Builder(
                builder: (c) => Scrollbar(
                  child: CustomScrollView(
                    controller: PrimaryScrollController.of(c),
                    slivers: [
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(c),
                      ),
                      SliverList(
                        delegate: SliverSeparatedListDelegate(
                          List.generate(
                            _fewer ? 5 : 8,
                            (i) => ListTile(title: Text('item $i'), onTap: () {}),
                          ),
                          separator: const Divider(height: 1, thickness: 1),
                        ),
                      ),
                      if (!_fewer) const SliverToBoxAdapter(child: SizedBox(height: 30)),
                      if (!_fewer)
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
      ),
    );
  }
}
