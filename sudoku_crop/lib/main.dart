import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:extended_math/extended_math.dart';
import 'dart:developer' as dev;
import 'package:linalg/linalg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MaterialApp(home: ResizeImage()));
}

File _image;
File _screenshot;

final picker = ImagePicker();

double _value = 0;
double _scaleValue = 1;
double _scale = 1;
bool status = true;
List<int> byteImage = [];

Offset off1 = Offset(0, 0);
Offset off2 = Offset(0, 50);
Offset off3 = Offset(50, 50);
Offset off4 = Offset(50, 0);

List<List<double>> initialMatrixList =
    List.generate(9, (i) => [0, 0, 0, 0, 0, 0, 0, 0, 1], growable: false);
List<List<double>> offsetMatrixList =
    List.generate(4, (i) => [0, 0], growable: false);

List<double> homographyList = [];

List<double> homographyMatrixList = [
  1,
  0,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  0,
  1
];
List<double> homographyColumnList;

class ResizeImage extends StatefulWidget {
  @override
  _ResizeImageState createState() => _ResizeImageState();
}

class _ResizeImageState extends State<ResizeImage> {
  ScreenshotController screenshotController = ScreenshotController();
  void calculate() {
    print(Matrix4.fromList(homographyMatrixList));
    int k = 0;
    offsetMatrixList = [
      [off1.dx, off1.dy],
      [off2.dx, off2.dy],
      [off3.dx, off3.dy],
      [off4.dx, off4.dy]
    ];
    List<List<double>> perspectivePoints = [
      [0, 0],
      [0, 200],
      [200, 200],
      [200, 0]
    ];

    for (int i = 0; i < 8; i = i + 2) {
      double x = offsetMatrixList[k][0];
      double y = offsetMatrixList[k][1];
      double p = perspectivePoints[k][0];
      double q = perspectivePoints[k][1];
      initialMatrixList[i] = [-x, -y, -1, 0, 0, 0, x * p, y * p, p];
      k = k + 1;
    }
    k = 0;
    for (int i = 1; i < 8; i = i + 2) {
      double x = offsetMatrixList[k][0];
      double y = offsetMatrixList[k][1];
      double p = perspectivePoints[k][0];
      double q = perspectivePoints[k][1];
      initialMatrixList[i] = [0, 0, 0, -x, -y, -1, x * q, y * q, q];
      k = k + 1;
    }
    Matrix initialMatrix = Matrix(initialMatrixList);
    Matrix inverseInitialMatrix = initialMatrix.inverse();

    List<List<double>> solutionList = [
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [0],
      [1]
    ];

    Matrix solutionMatrix = Matrix(solutionList);

    Matrix productMatrix = inverseInitialMatrix * solutionMatrix;
    homographyColumnList = productMatrix.columnVector(0).toList();
    print(homographyColumnList);
    homographyColumnList.insert(2, 0);
    homographyColumnList.insert(6, 0);
    homographyColumnList.insert(8, 0);
    homographyColumnList.insert(9, 0);
    homographyColumnList.insert(10, 1);
    homographyColumnList.insert(11, 0);
    homographyColumnList.insert(14, 0);
    print(homographyColumnList);

    print("h");
    print(Matrix4.fromList(homographyColumnList));
  }

  void processImage() {
    img.Image blackAndWhite;
    img.Image image = img.decodeImage(_screenshot.readAsBytesSync());
    blackAndWhite=img.grayscale(image);
    print("here");
    print(blackAndWhite.getPixel(20,20));
    img.Image croppedImage = img.copyCrop(image, 0, 0, 200, 200);
    print(croppedImage.height);
    print(croppedImage.width);
    byteImage = img.encodePng(croppedImage);
    print(byteImage.length);
    status = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            (status)
                ? Stack(
                    children: [
                      Container(
                          width: 400,
                          height: 400,
                          color: Colors.black,
                          child: Stack(
                            children: [
                              Screenshot(
                                controller: screenshotController,
                                child: Transform(
                                    transform:
                                        Matrix4.fromList(homographyMatrixList)
                                            .transposed(),
                                    child: Image.asset("assets/test2.jpg")),
                              ),
                              CustomPaint(
                                painter: CurvePainter(),
                              ),
                            ],
                          )),
                      Positioned(
                          left: off1.dx,
                          top: off1.dy,
                          child: GestureDetector(
                            onPanUpdate: (update) {
                              setState(() {
                                off1 = Offset(off1.dx + update.delta.dx,
                                    off1.dy + update.delta.dy);
                              });
                            },
                            child: Container(
                              child: Text("1"),
                              width: 50,
                              height: 50,
                              color: Colors.grey.withOpacity(.5),
                            ),
                          )),
                      Positioned(
                          left: off2.dx,
                          top: off2.dy,
                          child: GestureDetector(
                            onPanUpdate: (update) {
                              setState(() {
                                off2 = Offset(off2.dx + update.delta.dx,
                                    off2.dy + update.delta.dy);
                              });
                            },
                            child: Container(
                              child: Text("2"),
                              width: 50,
                              height: 50,
                              color: Colors.yellow.withOpacity(.5),
                            ),
                          )),
                      Positioned(
                          left: off3.dx,
                          top: off3.dy,
                          child: GestureDetector(
                            onPanUpdate: (update) {
                              setState(() {
                                off3 = Offset(off3.dx + update.delta.dx,
                                    off3.dy + update.delta.dy);
                              });
                            },
                            child: Container(
                              child: Text("3"),
                              width: 50,
                              height: 50,
                              color: Colors.green.withOpacity(.5),
                            ),
                          )),
                      Positioned(
                          left: off4.dx,
                          top: off4.dy,
                          child: GestureDetector(
                            onPanUpdate: (update) {
                              setState(() {
                                off4 = Offset(off4.dx + update.delta.dx,
                                    off4.dy + update.delta.dy);
                              });
                            },
                            child: Container(
                              child: Text("4"),
                              width: 50,
                              height: 50,
                              color: Colors.orange.withOpacity(.5),
                            ),
                          )),
                    ],
                  )
                : Container(
                    child: Image.memory(byteImage),
                  ),
            RaisedButton(
              child: Text("Print"),
              onPressed: () {
                print(off1.dx.toString() + "  " + off1.dy.toString());
                print(off2.dx.toString() + "  " + off2.dy.toString());
                print(off3.dx.toString() + "  " + off3.dy.toString());
                print(off4.dx.toString() + "  " + off4.dy.toString());
              },
            ),
            RaisedButton(
              child: Text("Find homography"),
              onPressed: calculate,
            ),
            RaisedButton(
              child: Text("Change Perspective"),
              onPressed: () {
                homographyMatrixList = homographyColumnList;
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text("Take a Pic"),
              onPressed: () {
                screenshotController
                    .capture(delay: Duration(milliseconds: 10))
                    .then((File img) async {
                  setState(() {
                    _screenshot = img;
                    processImage();
                  });
                });
              },
            ),
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

    canvas.drawLine(off1, off2, paint);
    canvas.drawLine(off2, off3, paint);
    canvas.drawLine(off3, off4, paint);
    canvas.drawLine(off4, off1, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//    List<List<double>> m = [
//      [-10, -20, -1, 0, 0, 0, 0, 0, 0],
//      [0, 0, 0, -10, -20, -1, 0, 0, 0],
//      [-45, -5, -1, 0, 0, 0, 2250, 250, 50],
//      [0, 0, 0, -45, -5, -1, 0, 0, 0],
//      [-40, -45, -1, 0, 0, 0, 40.0 * 50.0, 45.0 * 50.0, 50],
//      [0, 0, 0, -40, -45, -1, 40.0 * 50, 45.0 * 50, 50],
//      [-5, -35, -1, 0, 0, 0, 0, 0, 0],
//      [0, 0, 0, -5, -35, -1, 250, 35.0 * 50, 50],
//      [0, 0, 0, 0, 0, 0, 0, 0, 1]
//    ];
