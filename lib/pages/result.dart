import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  ResultPage({Key? key, required this.score}) : super(key: key);

  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
