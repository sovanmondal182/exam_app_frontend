import 'package:flutter/material.dart';

class ExamCheatingAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "WARNING",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "We have detected you are cheating. Your exam has been terminated!",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
