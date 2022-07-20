import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ScrollbarWithMorePage extends StatefulWidget {
  const ScrollbarWithMorePage({Key? key}) : super(key: key);

  @override
  State<ScrollbarWithMorePage> createState() => _ScrollbarWithMorePageState();
}

class _ScrollbarWithMorePageState extends State<ScrollbarWithMorePage> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScrollbarWithMore Example'),
      ),
      body: ScrollbarWithMore(
        controller: _controller,
        isAlwaysShown: true,
        interactive: true,
        trackVisibility: true,
        showTrackOnHover: true,
        hoverThickness: 5.0,
        thickness: 5.0,
        radius: const Radius.circular(3),
        crossAxisMargin: 3,
        mainAxisMargin: 3,
        scrollbarOrientation: ScrollbarOrientation.right,
        thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> s) {
          if (s.contains(MaterialState.dragged)) {
            return Colors.black54;
          }
          if (s.contains(MaterialState.hovered)) {
            return Colors.black45; // x
          }
          return Colors.black38;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>((_) => Colors.yellow),
        trackBorderColor: MaterialStateProperty.resolveWith<Color?>((_) => Colors.red),
        child: ListView.builder(
          controller: _controller,
          itemCount: 20,
          itemBuilder: (_, i) => ListTile(
            title: Text('Item $i'),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
