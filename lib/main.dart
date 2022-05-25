

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: mainpage(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}

class mainpage extends StatefulWidget {
  const mainpage({Key key}) : super(key: key);

  @override
  State<mainpage> createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> with SingleTickerProviderStateMixin {

  AnimationController controller;

   @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    controller.addStatusListener((status) async{
     if (status==AnimationStatus.completed){
       Navigator.pop(context);
       controller.reset();
     }
    },);
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 154, 74, 167),
        title: Text(
          "Attendance App",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            Lottie.asset('assets/dd.json'),
            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                textStyle: TextStyle(fontSize: 18),
              ),
              icon: Icon(Icons.book_online_rounded, size: 22),
              label: Text('Attendance'),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyWidget()),
                );
              },
            ),
          ],
        ),
      ),
      
    );
   
  }
}
 

class MyWidget extends StatefulWidget {
  const MyWidget({Key key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
     {
  

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text(
          "Examination Protal",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          )),
          alignment: Alignment.center,
          child: Column(children: [
            SizedBox(
              height: 100,
              width: 100,
            ),
            Image.asset("assets/exam.png"),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('EXAMINATION',
                      style: GoogleFonts.roboto(fontSize: 18)),
                  onPressed: () {
                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }),
            )
          ])),
    );
  }

 
}
