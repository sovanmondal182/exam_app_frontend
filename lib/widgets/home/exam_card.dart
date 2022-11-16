import 'package:exam_app/models/exam/Exam.dart';
import 'package:exam_app/models/student/Student.dart';
import 'package:exam_app/stores/exam/exam_store.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:date_format/date_format.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ExamType {
  Past,
  Present,
  Future,
}

class ExamCard extends StatelessWidget {
  final Exam exam;
  ExamType? examType;

  ExamCard({
    required this.exam,
  });

  onStartExamTapped(BuildContext context) async {
    Student? currentStudent = context.read<StudentStore>().currentStudent;

    if (currentStudent == null) {
      return;
    }

    await context.read<ExamStore>().startExam(exam.id, currentStudent.id,
        currentStudent.token, exam.duration.inMinutes, context);
  }

  detectDate() {
    int currentDate = DateTime.now().toLocal().millisecondsSinceEpoch;
    int startDate = exam.startDate.millisecondsSinceEpoch;
    int endDate = exam.endDate.millisecondsSinceEpoch;

    if (currentDate < startDate) {
      examType = ExamType.Past;
    } else if (currentDate >= startDate && currentDate <= endDate) {
      examType = ExamType.Present;
    } else {
      examType = ExamType.Future;
    }
  }

  @override
  Widget build(BuildContext context) {
    detectDate();
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 190,
        width: 370,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    exam.name,
                    style: TextStyle(
                      fontFamily: "assets/fonts/Roboto-Medium.ttf",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff636e72),
                    ),
                  ),
                  Text(
                    "ID: " + exam.id.substring(19, 24),
                    style: TextStyle(
                      fontFamily: "assets/fonts/Roboto-Medium.ttf",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff636e72),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Color(0xff636e72),
                thickness: 0.5,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 17,
                        color: Color(0xff636e72),
                      ),
                      SizedBox(width: 5),
                      Text(
                        formatDate(
                          exam.startDate,
                          [dd, ' ', M, ', ', HH, ':', nn, ' ', am],
                        ),
                        style: TextStyle(
                          fontFamily: "assets/fonts/Roboto-Medium.ttf",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff636e72),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 17,
                        color: Color(0xff636e72),
                      ),
                      SizedBox(width: 10),
                      Text(
                        formatDate(
                          exam.endDate,
                          [dd, ' ', M, ', ', HH, ':', nn, ' ', am],
                        ),
                        style: TextStyle(
                          fontFamily: "assets/fonts/Roboto-Medium.ttf",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff636e72),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.timelapse,
                    size: 20,
                    color: Color(0xff636e72),
                  ),
                  SizedBox(width: 5),
                  Text(
                    prettyDuration(exam.duration),
                    style: TextStyle(
                      fontFamily: "assets/fonts/Roboto-Medium.ttf",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff636e72),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 20,
                    color: Color(0xff636e72),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "${exam.questionCount} Questions",
                    style: TextStyle(
                      fontFamily: "assets/fonts/Roboto-Medium.ttf",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff636e72),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: examType != ExamType.Present
                        ? () {
                            onStartExamTapped(context);
                          }
                        : () {
                            onStartExamTapped(context);
                          },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: examType != ExamType.Present
                            ? Color(0xff74b9ff)
                            : Color(0xff74b9ff),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Start Exam",
                          style: TextStyle(
                            fontFamily: "assets/fonts/Roboto-Medium.ttf",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
