import 'package:exam_app/pages/home_page.dart';
import 'package:exam_app/stores/exam/exam_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class QuestionButton extends StatelessWidget {
  final int questionNo;

  QuestionButton({required this.questionNo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ExamStore>().goToQuestion(questionNo);
      },
      child: Observer(
        builder: (context) {
          return Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: context.watch<ExamStore>().answers![questionNo] != null
                  ? Color.fromARGB(255, 0, 157, 3)
                  : HomePage.iconBool
                      ? Colors.white
                      : Colors.black12,
            ),
            alignment: Alignment.center,
            child: Text(
              "${questionNo + 1}",
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}
