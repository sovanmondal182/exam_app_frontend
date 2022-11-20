import 'dart:async';

import 'package:exam_app/constants/routes.dart';
import 'package:exam_app/models/exam/Exam.dart';
import 'package:exam_app/models/exam/Question.dart';
import 'package:exam_app/network/exam_apis.dart';
import 'package:exam_app/pages/result.dart';
import 'package:exam_app/utils/app/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:timer_count_down/timer_controller.dart';

part 'exam_store.g.dart';

class ExamStore = _ExamStore with _$ExamStore;

abstract class _ExamStore with Store {
  @observable
  Exam? _currentExam;

  @observable
  int currentQuestionNo = 0;

  get currentExam => _currentExam;

  int? totalQuestions;

  @computed
  Question? get currentQuestion => _currentExam?.questions![currentQuestionNo];

  @observable
  ObservableList<String?>? answers;

  bool didLeaveExam = false;

  int leaveExamCount = 0;

  CountdownController? countdownController;

  @computed
  bool get isLastQuestion => currentQuestionNo == totalQuestions! - 1;

  @action
  startExam(
    String examId,
    String studentId,
    String token,
    int duration,
    BuildContext context,
  ) async {
    AppUtils.showLoading("Starting Exam..");
    print(examId);
    print(studentId);
    print(duration);
    print(token);
    _currentExam =
        await ExamApi.getExam(examId, studentId, token, duration.toString());
    totalQuestions = _currentExam?.questions!.length;
    answers = ObservableList();
    answers!.length = totalQuestions!;

    countdownController = CountdownController();

    AppUtils.dismissLoading();

    Navigator.pushNamed(
      context,
      Routes.exam,
    );
  }

  @action
  endExam(BuildContext context, String studentId, String token) async {
    try {
      AppUtils.showLoading("Submitting Exam...");
      List<String?> answersList = [];
      answers?.forEach((element) {
        if (element == null) {
          answersList.add("Not Selected");
        } else {
          answersList.add(element);
        }
      });
      print(answers!.toList());
      print(answersList);
      int submitted = await ExamApi.submitExam(
        studentId,
        _currentExam!.id,
        // answers!.toList(),
        answersList,
        token,
      );

      if (submitted >= 0) {
        Timer(Duration(seconds: 1), () {
          _currentExam = null;
          totalQuestions = null;
          // answers = null;
          answersList = [];
          countdownController!.pause();
          // countdownController = null;
          currentQuestionNo = 0;
        });
        AppUtils.dismissLoading();
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ResultPage(
              score: submitted,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @action
  goToNextQuestion() {
    if (currentQuestionNo != totalQuestions! - 1) currentQuestionNo++;
  }

  @action
  goToPreviousQuestion() {
    if (currentQuestionNo != 0) currentQuestionNo--;
  }

  @action
  goToQuestion(int quesNo) {
    currentQuestionNo = quesNo;
  }

  @action
  setAnswer(int questionNo, String? key) {
    answers![questionNo] = key;
  }
}
