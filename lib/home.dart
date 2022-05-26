import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_app/examination.dart';

import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController name = TextEditingController(text: 'Sanskriti ');
  TextEditingController present = TextEditingController(text: 'present ');

  AnimationController controller;

  @override
  void initState1() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    controller.addStatusListener(
      (status) async {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void dispose1() {
    controller.dispose();
    super.dispose();
  }

  void showDoneDialog() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/done.json',
                repeat: false,
                controller: controller,
                onLoaded: (composition) {
                  controller.forward();
                },
              ),
            ],
          ),
        ),
      );
  final fb = FirebaseDatabase.instance;
  bool loading = true;
  File _image;
  List _output;
  final imagepicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detectimage(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = prediction;
      loading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    super.dispose();
  }

  pickimage_camera() async {
    var image = await imagepicker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  pickimage_gallery() async {
    var image = await imagepicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('mark-attendance');

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Examination Protal',
            style: GoogleFonts.roboto(),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          )),
          height: h,
          width: w,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 150,
                width: 150,
                padding: EdgeInsets.all(10),
                child: Image.asset('assets/scanner.png'),
              ),
              Container(
                  child: Text('Face Detector',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))),
              SizedBox(height: 50),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                          color: Color.fromARGB(255, 143, 49, 115),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text('Capture',
                              style: GoogleFonts.roboto(fontSize: 18)),
                          onPressed: () {
                            pickimage_camera();
                          }),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                          color: Color.fromARGB(255, 143, 49, 115),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text('Gallery',
                              style: GoogleFonts.roboto(fontSize: 18)),
                          onPressed: () {
                            pickimage_gallery();
                          }),
                    ),
                  ],
                ),
              ),
              loading != true
                  ? Container(
                      child: Column(
                        children: [
                          Container(
                            height: 220,
                            // width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Image.file(_image),
                          ),
                          _output != null
                              ? Text(
                                  (_output[0]['label']).toString().substring(2),
                                  style: GoogleFonts.roboto(fontSize: 18))
                              : Text(''),
                          MaterialButton(
                            color: Color.fromARGB(255, 126, 45, 119),
                            onPressed: () {
                              
                              ref.push().set(
                                present.text).asStream();

                               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => examination()),
                );
                            },
                            child: Text(
                              "save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
