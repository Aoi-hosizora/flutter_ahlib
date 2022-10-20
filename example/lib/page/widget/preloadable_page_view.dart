import 'package:flutter/material.dart';

class PreloadablePageViewPage extends StatefulWidget {
  const PreloadablePageViewPage({Key? key}) : super(key: key);

  @override
  State<PreloadablePageViewPage> createState() => _PreloadablePageViewPageState();
}

class _PreloadablePageViewPageState extends State<PreloadablePageViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PreloadablePageView example'),
      ),
      body: const Center(
        child: Text('PreloadablePageView'),
      ),
    );
  }
}
