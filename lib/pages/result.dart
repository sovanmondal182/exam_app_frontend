import 'package:exam_app/constants/app_theme.dart';
import 'package:exam_app/constants/routes.dart';
import 'package:exam_app/constants/strings.dart';
import 'package:exam_app/models/student/Student.dart';
import 'package:exam_app/pages/home_page.dart';
import 'package:exam_app/stores/exam/assigned_exam_store.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  ResultPage({Key? key, required this.score}) : super(key: key);

  final int score;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              0),
          elevation: 0,
          centerTitle: true,
          title: Text("Result"),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Thank you for taking the exam',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "You Scored " + score.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Student student =
                          context.read<StudentStore>().currentStudent!;

                      context.read<StudentStore>().login(student);
                      context
                          .read<AssignedExamStore>()
                          .getAssignedExams(student.id, student.token);

                      Navigator.pushReplacementNamed(context, Routes.home);
                    },
                    key: Key(Strings.backtoHomeButtonKey),
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: lightTheme.highlightColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          Strings.backtohomwButtonText,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
