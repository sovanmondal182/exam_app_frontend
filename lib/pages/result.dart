import 'package:flutter/material.dart';
import 'package:exam_app/network/exam_apis.dart';

class ResultPage extends StatelessWidget {
  ResultPage({Key? key, required this.score}) : super(key: key);

  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Container(
        child: Center(
          child: Text(
            "Your Score:" + score.toString(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
