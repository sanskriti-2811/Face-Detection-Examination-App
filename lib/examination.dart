import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class examination extends StatefulWidget {
  const examination({Key key}) : super(key: key);

  @override
  State<examination> createState() => _examinationState();
}

class _examinationState extends State<examination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Examination",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        
        ),
        centerTitle: true,
      ),
      body: Center(

        child: Column(
          children:[
            Lottie.asset('assets/exam.json'),
            Text('Start Your Exam', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        ),])
      
      ),
    );
  }
}
