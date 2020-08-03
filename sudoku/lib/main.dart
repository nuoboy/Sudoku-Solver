import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'routes.dart';

void main() {
  runApp(MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute, home: MainPage()));
}

final picker = ImagePicker();

File imageFile;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void getCamera() async {
    final image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(image.path);
      Navigator.pushNamed(context, "/crop");
    });

  }

  void getGallery() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image.path);
      Navigator.pushNamed(context, "/crop");

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipPath(
                clipper: ClipperClass(),
                child: Container(
                  child: Image.asset(
                    "asset/design.png",
                    fit: BoxFit.fill,
                  ),
                  decoration:
                      BoxDecoration(color: Colors.indigo[900], boxShadow: []),
                  width: double.infinity,
                  height: 300,
                ),
              ),
              SizedBox(
                height: 75,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomPaint(
                    painter: CurvePainter(),
                  ),
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            child: IconButton(
                                onPressed: getCamera,
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.green[800],
                                )),
                          ),
                          Text(
                            "Camera",
                            style: GoogleFonts.cabin(fontSize: 15),
                          )
                        ],
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            child: IconButton(
                                onPressed: getGallery,
                                icon: Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.orange,
                                )),
                          ),
                          Text(
                            "Gallery",
                            style: GoogleFonts.cabin(fontSize: 15),
                          )
                        ],
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            child: IconButton(
                                icon: Icon(
                              Icons.grid_on,
                              size: 40,
                              color: Colors.red,
                            )),
                          ),
                          Text(
                            "Make a Grid",
                            style: GoogleFonts.cabin(fontSize: 15),
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 170,
              ),
              RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)) ,
                    side: BorderSide(color: Colors.blue, width: 2)),
                color: Colors.white,
                onPressed: () {},
                child: Text(
                  "help",
                  style: GoogleFonts.cabin(fontSize: 20,color: Colors.blue),
                ),
              ),
            ],
          ),
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClipperClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width, size.height - 60);
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

//child: Column(
//crossAxisAlignment: CrossAxisAlignment.stretch,
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: [
//Container(
//decoration: BoxDecoration(
//color: Colors.white,
//border: Border.all(color: Colors.white),
//borderRadius: BorderRadius.all(Radius.circular(20))),
//height: 100,
//child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: [
//Container(
//width: 100,
//height: 100,
//child: IconButton(
//padding: EdgeInsets.all(0),
//onPressed: () {},
//icon: Icon(
//Icons.camera_alt,
//size: 100,
//),
//),
//),
//Text(
//"Scan Sudoku",
//style: GoogleFonts.cabin(
//textStyle: TextStyle(
//fontSize: 40, fontWeight: FontWeight.w400)),
//)
//],
//),
//),
//Container(
//decoration: BoxDecoration(
//color: Colors.white,
//border: Border.all(color: Colors.white),
//borderRadius: BorderRadius.all(Radius.circular(20))),
//height: 100,
//child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: [
//Container(
//width: 100,
//height: 100,
//child: IconButton(
//padding: EdgeInsets.all(0),
//onPressed: () {},
//icon: Icon(
//Icons.image,
//size: 100,
//),
//),
//),
//Text(
//"",
//style: GoogleFonts.cabin(
//textStyle: TextStyle(
//fontSize: 40, fontWeight: FontWeight.w400)),
//)
//],
//),
//),
//Container(
//decoration: BoxDecoration(
//color: Colors.white,
//border: Border.all(color: Colors.white),
//borderRadius: BorderRadius.all(Radius.circular(20))),
//height: 100,
//child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: [
//Container(
//width: 100,
//height: 100,
//child: IconButton(
//padding: EdgeInsets.all(0),
//onPressed: () {},
//icon: Icon(
//Icons.camera_alt,
//size: 100,
//),
//),
//),
//Text(
//"Scan Sudoku",
//style: GoogleFonts.cabin(
//textStyle: TextStyle(
//fontSize: 40, fontWeight: FontWeight.w400)),
//)
//],
//),
//),
//
//],
