import 'package:exam_app/constants/app_theme.dart';
import 'package:exam_app/models/student/Student.dart';
import 'package:exam_app/stores/exam/exam_store.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:exam_app/widgets/exam/exam_buttons.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ExamNavigationButtons extends StatelessWidget {
  final Function onAI;

  ExamNavigationButtons({required this.onAI});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExamButton(
          text: "PREVIOUS",
          onPressed: () {
            context.read<ExamStore>().goToPreviousQuestion();
          },
        ),
        SizedBox(width: 20),
        Observer(
          builder: (context) {
            return context.watch<ExamStore>().isLastQuestion
                ? ExamButton(
                    text: "END EXAM",
                    color: Color.fromARGB(255, 177, 49, 40),
                    onPressed: () async {
                      bool confirmEnd = await confirm(
                        context,
                        title: Text('WARNING'),
                        content: Text('Do you want to submit the exam?'),
                        textOK: Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.red),
                        ),
                        textCancel: Text('CANCEL'),
                      );

                      if (confirmEnd) {
                        Student student =
                            context.read<StudentStore>().currentStudent!;
                        context
                            .read<ExamStore>()
                            .endExam(context, student.id, student.token);
                      }
                    },
                  )
                : ExamButton(
                    color: AppTheme.themeDataDark.highlightColor,
                    text: "NEXT",
                    onPressed: () {
                      context.read<ExamStore>().goToNextQuestion();
                    },
                  );
          },
        ),
      ],
    );
  }
}
