import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linalg/linalg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'main.dart';

double widthImage = 0;
double heightImage = 0;

Offset offset1 = Offset(0, 0);
Offset offset2;
Offset offset3;
Offset offset4;

class CropPage extends StatefulWidget {
  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  void getImageParams() async {
    var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    heightImage = decodedImage.height.toDouble();
    widthImage = decodedImage.width.toDouble();
  }

  @override
  void initState() {
    getImageParams();
    offset1 = Offset(0, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Stack(
              children: [
                Positioned(
                  top: -30,
                  child: Container(
                      width: double.infinity,
                      height: 600,
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.contain,
                      )),
                ),
                Column(
                  children: [
                    Container(height: 75,),
                    Container(
                        width: double.infinity,
                        height: 600,
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.contain,
                        )),
                  ],
                ),
                CustomPaint(
                  painter: CurvePainter(),
                ),
                Positioned(
                  left: offset1.dx,
                  top: offset1.dy,
                  child: GestureDetector(
                    onPanUpdate: (x) {
                      offset1 = offset1 + Offset(x.delta.dx, x.delta.dy);
                      print(offset1);
                      setState(() {});
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      color: Colors.green,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.crop),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green[800];
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;

    var path = Path();
    path.lineTo(size.width, size.height);

//    canvas.drawLine(off1 + Offset(40, 40), off2 + Offset(40, 0), paint);
//    canvas.drawLine(off2 + Offset(40, 0), off3 + Offset(0, 0), paint);
//    canvas.drawLine(off3 + Offset(0, 0), off4 + Offset(0, 40), paint);
//    canvas.drawLine(off4 + Offset(0, 40), off1 + Offset(40, 40), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SnapClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.addPolygon([
//      off1 + Offset(20, 20),
//      off1 + Offset(20, 60),
//      off1 + Offset(60, 60),
//      off1 + Offset(60, 20)
    ], true);

//    path.quadraticBezierTo(
//        3 * size.width / 4, size.height - 120, size.width, size.height - 40);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
