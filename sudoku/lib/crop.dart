import 'dart:ui';

import 'package:flutter/rendering.dart';

import 'main.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linalg/linalg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;

File _image = imageFile;
File _screenshot;
File _snapShot;

bool stat1 = false;
bool stat2 = false;
bool stat3 = false;
bool stat4 = false;

bool status = true;
List<int> byteImage = [];

Offset off1 = Offset(100, 100);
Offset off2 = Offset(100, 300);
Offset off3 = Offset(300, 300);
Offset off4 = Offset(300, 100);

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
List<int> bitImageList;

class ResizeImage extends StatefulWidget {
  @override
  _ResizeImageState createState() => _ResizeImageState();
}

class _ResizeImageState extends State<ResizeImage> {
  ScreenshotController screenshotController = ScreenshotController();
  ScreenshotController snapShotController = ScreenshotController();

  void calculate() {
    print(Matrix4.fromList(homographyMatrixList));
    int k = 0;
    offsetMatrixList = [
      [off1.dx + 40, off1.dy + 40],
      [off2.dx + 40, off2.dy + 0],
      [off3.dx + 0, off3.dy + 0],
      [off4.dx + 0, off4.dy + 40]
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
  }

  void processImage() {
    img.Image blackAndWhite;
    img.Image image = img.decodeImage(_screenshot.readAsBytesSync());
    blackAndWhite = img.grayscale(image);
    img.Image croppedImage = img.copyCrop(image, 0, 0, 200, 200);
    print(croppedImage.height);
    print(croppedImage.width);
    byteImage = img.encodePng(croppedImage);
    print(byteImage.length);
    status = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    stat1 = false;

    status = true;
    _image = imageFile;
    byteImage = [];

    off1 = Offset(100, 100);
    off2 = Offset(100, 300);
    off3 = Offset(300, 300);
    off4 = Offset(300, 100);

    initialMatrixList =
        List.generate(9, (i) => [0, 0, 0, 0, 0, 0, 0, 0, 1], growable: false);
    offsetMatrixList = List.generate(4, (i) => [0, 0], growable: false);

    homographyList = [];

    homographyMatrixList = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
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
                ? Container(
                    height: 400,
                    child: Stack(
                      children: [
                        Container(
                            width: 400,
                            height: 400,
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Screenshot(
                                  controller: screenshotController,
                                  child: Center(
                                    child: Transform(
                                      transform:
                                          Matrix4.fromList(homographyMatrixList)
                                              .transposed(),
                                      child: Center(
                                        child: Container(
                                          height: 300,
                                          child: Image.file(
                                            _image,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                              onPanStart: (x) {
                                setState(() {
                                  stat1 = true;
                                });
                              },
                              onPanUpdate: (update) {
                                setState(() {
                                  off1 = Offset(off1.dx + update.delta.dx,
                                      off1.dy + update.delta.dy);
                                });
                              },
                              onPanEnd: (x) {
                                setState(() {
                                  stat1 = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                width: 40,
                                height: 40,
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
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                width: 40,
                                height: 40,
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
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                width: 40,
                                height: 40,
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
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                width: 40,
                                height: 40,
                              ),
                            )),
                        (stat1)
                            ? Positioned(
                                left: off1.dx+60,
                                top: off1.dy+60,
                                child: Container(
                                    width: 400,
                                    height: 400,
                                    color: Colors.white,
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Center(
                                            child: Container(
                                              height: 300,
                                              child: Image.file(
                                                _image,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        CustomPaint(
                                          painter: CurvePainter(),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : Container(
                    child: Image.memory(byteImage),
                  ),
            IconButton(
              icon: Icon(Icons.crop),
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
