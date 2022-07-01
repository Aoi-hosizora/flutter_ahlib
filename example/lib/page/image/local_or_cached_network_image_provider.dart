import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class LocalOrCachedNetworkImageProviderPage extends StatefulWidget {
  const LocalOrCachedNetworkImageProviderPage({Key? key}) : super(key: key);

  @override
  _LocalOrCachedNetworkImageProviderPageState createState() => _LocalOrCachedNetworkImageProviderPageState();
}

class _LocalOrCachedNetworkImageProviderPageState extends State<LocalOrCachedNetworkImageProviderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalOrCachedNetworkImageProvider Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image(
                  image: LocalOrCachedNetworkImageProvider(
                    file: () async => null,
                    url: () async => 'https://neilpatel.com/wp-content/uploads/2017/08/colors.jpg',
                    onFileLoading: () => print('onFileLoading (url)'),
                    onFileLoaded: () => print('onFileLoaded (url)'),
                    onUrlLoading: () => print('onNetworkLoading (url)'),
                    onUrlLoaded: () => print('onNetworkLoaded (url)'),
                    onError: () => print('onError (url)'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Image(
                  image: LocalOrCachedNetworkImageProvider(
                    file: () async => File('/sdcard/DCIM/test.jpg'),
                    url: () async => null,
                    onFileLoading: () => print('onFileLoading (file)'),
                    onFileLoaded: () => print('onFileLoaded (file)'),
                    onUrlLoading: () => print('onNetworkLoading (file)'),
                    onUrlLoaded: () => print('onNetworkLoaded (file)'),
                    onError: () => print('onError (file)'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
