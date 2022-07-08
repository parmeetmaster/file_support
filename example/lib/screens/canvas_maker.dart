import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImageGenerator extends StatefulWidget {
  final Random rd;
  final int numColors;

  ImageGenerator()
      : rd = Random(),
        numColors = Colors.primaries.length;

  @override
  _ImageGeneratorState createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  ByteData? imgBytes;
  double kCanvasSize = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RaisedButton(
                  child: Text('Generate image'), onPressed: generateImage),
            ),
            imgBytes != null
                ? Container(
                    color: Colors.grey[200],
                    child: Center(
                        child: Image.memory(
                      Uint8List.view(imgBytes!.buffer),
                      width: kCanvasSize,
                      height: kCanvasSize,
                    )),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void generateImage() async {
    final color = Colors.primaries[widget.rd.nextInt(widget.numColors)];

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(
            Offset(0.0, 0.0), Offset(kCanvasSize, kCanvasSize + 400)));

    final stroke = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, kCanvasSize, kCanvasSize), stroke);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Offset(widget.rd.nextDouble() * kCanvasSize * 0.9,
                widget.rd.nextDouble() * kCanvasSize * 0.9) &
            Size(200, 100),
        paint);
    canvas.drawCircle(
        Offset(
          widget.rd.nextDouble() * kCanvasSize * 0.9,
          widget.rd.nextDouble() * kCanvasSize * 0.9,
        ),
        100.0,
        paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(300, 300);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);
    setState(() {
      imgBytes = pngBytes!;
    });
  }
}
