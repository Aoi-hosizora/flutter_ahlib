import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class TextSelectionConfigPage extends StatefulWidget {
  const TextSelectionConfigPage({Key? key}) : super(key: key);

  @override
  State<TextSelectionConfigPage> createState() => _TextSelectionConfigPageState();
}

class _TextSelectionConfigPageState extends State<TextSelectionConfigPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextSelectionConfig Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'textColor: Colors.cyan\n'
                'hintTextColor: Colors.amber\n'
                'cursorColor: Colors.blueGrey\n'
                'selectionColor: Colors.purple\n'
                'selectionHandleColor: Colors.pinkAccent\n'
                'enabledBorderColor: Colors.deepPurple\n'
                'focusedBorderColor: Colors.brown',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 12),
              Text(_controller.text),
              const SizedBox(height: 12),
              TextSelectionConfig(
                cursorColor: Colors.blueGrey,
                selectionColor: Colors.purple,
                selectionHandleColor: Colors.green, // no effect
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Hint',
                    hintStyle: TextStyle(color: Colors.amber),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                  ),
                  style: const TextStyle(color: Colors.cyan),
                  selectionControls: TextSelectionWithColorHandle(Colors.pinkAccent) /* this works */,
                  onChanged: (v) {
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
