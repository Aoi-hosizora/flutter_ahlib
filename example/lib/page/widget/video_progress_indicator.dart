import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class VideoProgressIndicatorPage extends StatefulWidget {
  const VideoProgressIndicatorPage({Key? key}) : super(key: key);

  @override
  State<VideoProgressIndicatorPage> createState() => _VideoProgressIndicatorPageState();
}

class _VideoProgressIndicatorPageState extends State<VideoProgressIndicatorPage> {
  var _progress = const VideoProgress(duration: 10000, position: 2000, buffered: 5000);
  var _black = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoProgressIndicator Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Non-null progress, allow scrubbing'),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: _black ? Colors.black : null,
              ),
              child: VideoProgressIndicator(
                progress: _progress,
                allowScrubbing: true,
                onScrubStart: () {
                  printLog('onScrubStart');
                },
                onScrubbing: (position) {
                  printLog('onScrubbing $position');
                  _progress = _progress.copyWith(position: position);
                  if (mounted) setState(() {});
                },
                onScrubEnd: () {
                  printLog('onScrubEnd');
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Non-null progress, allow scrubbing, with padding'),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: _black ? Colors.black : null,
              ),
              child: VideoProgressIndicator(
                padding: const EdgeInsets.symmetric(vertical: 5),
                progress: _progress,
                allowScrubbing: true,
                onScrubStart: () {
                  printLog('onScrubStart 2');
                },
                onScrubbing: (position) {
                  printLog('onScrubbing 2 $position');
                  _progress = _progress.copyWith(position: position);
                  if (mounted) setState(() {});
                },
                onScrubEnd: () {
                  printLog('onScrubEnd');
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Non-null progress, disallow scrubbing'),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: _black ? Colors.black : null,
              ),
              child: VideoProgressIndicator(
                progress: _progress,
                allowScrubbing: false,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Null progress, allow scrubbing'),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: _black ? Colors.black : null,
              ),
              child: const VideoProgressIndicator(
                progress: null,
                allowScrubbing: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Null progress, disallow scrubbing'),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: _black ? Colors.black : null,
              ),
              child: const VideoProgressIndicator(
                progress: null,
                allowScrubbing: false,
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Black background'),
              value: _black,
              onChanged: (v) {
                _black = v ?? false;
                if (mounted) setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
