import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class ScrollbarWithMorePage extends StatefulWidget {
  const ScrollbarWithMorePage({Key? key}) : super(key: key);

  @override
  State<ScrollbarWithMorePage> createState() => _ScrollbarWithMorePageState();
}

class _ScrollbarWithMorePageState extends State<ScrollbarWithMorePage> {
  final _controller = ScrollController();
  var _useTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScrollbarWithMore Example'),
        actions: [
          IconButton(
            icon: Text(_useTheme ? 'Theme' : 'Widget'),
            onPressed: () {
              _useTheme = !_useTheme;
              if (mounted) setState(() {});
            },
          ),
        ],
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          scrollbarTheme: Theme.of(context).scrollbarTheme.copyWith(
                crossAxisMargin: _useTheme ? 5 : null,
                mainAxisMargin: _useTheme ? 5 : null,
                thumbColor: _useTheme ? MaterialStateProperty.all(Colors.blue) : null,
                trackColor: _useTheme ? MaterialStateProperty.all(Colors.orangeAccent) : null,
                trackBorderColor: _useTheme ? MaterialStateProperty.all(Colors.lightGreenAccent) : null,
              ),
        ),
        child: ScrollbarWithMore(
          controller: _controller,
          isAlwaysShown: true,
          interactive: true,
          trackVisibility: true,
          showTrackOnHover: true,
          hoverThickness: 5.0,
          thickness: 5.0,
          radius: const Radius.circular(3),
          crossAxisMargin: _useTheme ? null : 3,
          mainAxisMargin: _useTheme ? null : 3,
          scrollbarOrientation: ScrollbarOrientation.right,
          thumbColor: _useTheme
              ? null
              : MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> s) {
                  if (s.contains(MaterialState.dragged)) {
                    return Colors.black54;
                  }
                  if (s.contains(MaterialState.hovered)) {
                    return Colors.black45; // x
                  }
                  return Colors.black38;
                }),
          trackColor: _useTheme ? null : MaterialStateProperty.resolveWith<Color?>((_) => Colors.yellow),
          trackBorderColor: _useTheme ? null : MaterialStateProperty.resolveWith<Color?>((_) => Colors.red),
          child: ListView.builder(
            controller: _controller,
            itemCount: 20,
            itemBuilder: (_, i) => ListTile(
              title: Text('Item $i'),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}
