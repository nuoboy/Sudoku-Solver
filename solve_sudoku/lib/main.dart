import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'solve.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(body: MyApp())));
}

File file;
int width;
int height;
img.Image image;
img.Image crop;
bool state = false;
bool gridState = false;
List<int> imi;
List<List<int>> cropList = [];
List<String> predictions = [];
List<List<String>> sudoku = List.generate(
    9, (i) => ["", "", "", "", "", "", "", "", ""],
    growable: false);
List<List<List<String>>> solutions=[];

void read() async {
  FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(file);
  TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
  VisionText readText = await recognizeText.processImage(ourImage);

  for (TextBlock block in readText.blocks) {
    for (TextLine line in block.lines) {
      for (TextElement word in line.elements) {
        print(word.text);
      }
    }
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void getFile() async {
    file = await FilePicker.getFile();
  }

  void transform() async{
    var decodedImage = await decodeImageFromList(file.readAsBytesSync());
    decodedImage=Transform.scale(scale: null)

  }
  
  void puzzleCrop() async {
    cropList = [];
    var decodedImage = await decodeImageFromList(file.readAsBytesSync());
    width = decodedImage.width;
    height = decodedImage.height;
    image = img.decodeImage(file.readAsBytesSync());

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        img.Image croppedImage = img.copyCrop(image, j * (width ~/ 9),
            i * (height ~/ 9), width ~/ 9, height ~/ 9);
        List<int> encodedImage = img.encodePng(croppedImage);
        await readCrop(encodedImage);
        cropList.add(encodedImage);
      }
      print("--------------------------------");
      print(predictions);
    }
    state = true;
    setState(() {});
    print(cropList.length);
    print(predictions.length);
    print("=========================================");
  }

  Future readCrop(List<int> tile) async {
    final directory = await getApplicationDocumentsDirectory();
    File cropping = File('${directory.path}/amal.png');
    cropping.writeAsBytesSync(tile);
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!1");
    print(cropping.length());

    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(cropping);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    String word = readText.text.toString();

    predictions.add(readText.text.trim());
  }

  void gridMaker() {
    int k = 0;
    print("pppppppp");
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        sudoku[i][j] = predictions[k];
        k = k + 1;
      }
    }
    print(sudoku);
    gridState = true;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RaisedButton(
            child: Text("Pick"),
            onPressed: getFile,
          ),
//        RaisedButton(
//          child: Text("Read"),
//          onPressed: read,
//        ),
          RaisedButton(
            child: Text("Crop"),
            onPressed: puzzleCrop,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Make"),
                onPressed: () {
                  gridMaker();
                  solveSudoku();
                  setState(() {

                  });
                },
              ),
              RaisedButton(
                child: Text("Solve"),
                onPressed: () {
                  print(amal);
                  sudoku=amal;
                  setState(() {});
                  print(sudoku);
                },
              ),
            ],
          ),
          (state)
              ? Container(
                  color: Colors.white,
                  height: 300,
                  width: 400,
                  child: ListView.builder(
                    itemCount: cropList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Image.memory(cropList[index]),
                          Text(predictions[index]),
                        ],
                      );
                    },
                  ),
                )
              : Text("Nooooooooo"),
          (gridState)
              ? Container(
                  color: Colors.grey,
                  child: Table(
                    border: TableBorder.all(color: Colors.black, width: 2),
                    children: [
                      TableRow(children: [
                        for (String value in sudoku[0])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                      TableRow(children: [
                        for (String value in sudoku[1])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                      TableRow(children: [
                        for (String value in sudoku[2])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                      TableRow(children: [
                        for (String value in sudoku[3])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                      TableRow(children: [
                        for (String value in sudoku[4])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                      TableRow(children: [
                        for (String value in sudoku[5])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                      TableRow(children: [
                        for (String value in sudoku[6])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                      TableRow(children: [
                        for (String value in sudoku[7])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                      TableRow(children: [
                        for (String value in sudoku[8])
                          TableCell(
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.gabriela(
                                fontSize: 30,
                              ),
                            ),
                          ),
                      ]),
                    ],
                  ),
                )
              : Text("No Table for ya")
        ],
      ),
    );
  }
}
