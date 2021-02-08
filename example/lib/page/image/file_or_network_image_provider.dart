import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class FileOrNetworkImageProviderPage extends StatefulWidget {
  @override
  _FileOrNetworkImageProviderPageState createState() => _FileOrNetworkImageProviderPageState();
}

class _FileOrNetworkImageProviderPageState extends State<FileOrNetworkImageProviderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FileOrNetworkImageProvider Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image(
                  image: FileOrNetworkImageProvider(
                    file: () async => null,
                    url: () async => "https://neilpatel.com/wp-content/uploads/2017/08/colors.jpg",
                    onFileLoading: () => print('onFileLoading'),
                    onFileLoaded: () => print('onFileLoaded'),
                    onNetworkLoading: () => print('onNetworkLoading'),
                    onNetworkLoaded: () => print('onNetworkLoaded'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Image(
                  image: FileOrNetworkImageProvider(
                    file: () async => File('/sdcard/android_tools/test.jpg'),
                    url: () async => null,
                    onFileLoading: () => print('onFileLoading'),
                    onFileLoaded: () => print('onFileLoaded'),
                    onNetworkLoading: () => print('onNetworkLoading'),
                    onNetworkLoaded: () => print('onNetworkLoaded'),
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
