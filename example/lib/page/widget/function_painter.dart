import 'package:flutter/material.dart';
import 'package:flutter_ahlib/flutter_ahlib.dart';

class FunctionPainterPage extends StatefulWidget {
  @override
  _FunctionPainterPageState createState() => _FunctionPainterPageState();
}

class _FunctionPainterPageState extends State<FunctionPainterPage> {
  @override
  Widget build(BuildContext context) {
    // TODO
    return Scaffold(
      appBar: AppBar(
        title: Text('FunctionPainterPage Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.yellow,
              child: Center(
                child: CustomPaint(
                  painter: FunctionPainter(
                    onPaint: (canvas, size) {
                      canvas.drawLine(
                        Offset(0, 0),
                        Offset(0, 100),
                        Paint()
                          ..strokeWidth = 5
                          ..color = Colors.black,
                      );
                      canvas.drawLine(
                        Offset(0, 100),
                        Offset(100, 100),
                        Paint()
                          ..strokeWidth = 5
                          ..color = Colors.black,
                      );
                      canvas.drawLine(
                        Offset(100, 100),
                        Offset(100, 0),
                        Paint()
                          ..strokeWidth = 5
                          ..color = Colors.black,
                      );
                      canvas.drawLine(
                        Offset(100, 0),
                        Offset(0, 0),
                        Paint()
                          ..strokeWidth = 5
                          ..color = Colors.black,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1),
          Expanded(
            child: BannedIcon(
              banned: true,
              color: Colors.grey,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              lineWidth: 15,
              blinkLineWidth: 8,
              offset: 15,
              size: Size.square(150),
              icon: Icon(
                Icons.check,
                color: Colors.grey,
                size: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
