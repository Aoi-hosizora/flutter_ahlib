import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';
import 'package:flutter_ahlib_example/main.dart';

class IconTextPage extends StatefulWidget {
  const IconTextPage({Key? key}) : super(key: key);

  @override
  _IconTextPageState createState() => _IconTextPageState();
}

class _IconTextPageState extends State<IconTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IconText Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(),
            InkWell(
              onTap: () => printLog('l2r'),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: IconText(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  icon: Icon(Icons.check),
                  text: Text('Check (l2r)'),
                  alignment: IconTextAlignment.l2r,
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () => printLog('r2l'),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: IconText(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  icon: Icon(Icons.check),
                  text: Text('Check (r2l)'),
                  alignment: IconTextAlignment.r2l,
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () => printLog('t2b'),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: IconText(
                  icon: Icon(Icons.check),
                  text: Text('Check (t2b)'),
                  alignment: IconTextAlignment.t2b,
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () => printLog('b2t'),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: IconText(
                  icon: Icon(Icons.check),
                  text: Text('Check (b2t)'),
                  alignment: IconTextAlignment.b2t,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () => printLog('l2r'),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: IconText(
                    icon: const Icon(Icons.check),
                    text: Flexible(
                      child: Text(
                        'Check' * 75,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    textPadding: EdgeInsets.zero,
                    alignment: IconTextAlignment.l2r,
                  ),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () => printLog('r2l'),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: IconText(
                    icon: const Icon(Icons.check),
                    text: Flexible(
                      child: Text(
                        'Check' * 75,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    textPadding: EdgeInsets.zero,
                    alignment: IconTextAlignment.r2l,
                  ),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                onTap: () => printLog('l2r texts'),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: IconText.texts(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    icon: const Icon(Icons.check),
                    texts: [
                      Flexible(
                        child: Text(
                          'long text ' * 20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text('Check (l2r texts)'),
                    ],
                    alignment: IconTextAlignment.l2r,
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
