import 'package:exam_app/models/exam/Question.dart';

class Exam {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final Duration duration;
  final int questionCount;
  List<Question>? questions;
  List<String>? answerKeys;
  String? status;

  Exam({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.questionCount,
    this.questions,
    this.answerKeys,
    this.status,
  });

  factory Exam.fromJson(json) {
    List<Question> questions = [];

    if (json['questions'] != null) {
      json['questions']
          .forEach((question) => questions.add(Question.fromJson(question)));
    }

    return Exam(
      id: json['_id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']).toLocal(),
      endDate: DateTime.parse(json['endDate']).toLocal(),
      duration: Duration(minutes: json['duration']),
      questionCount: json['questionCount'],
      questions: questions,
      answerKeys: json?['answerKeys'],
      status: json?['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startDate': startDate,
        'endDate': endDate,
        'duration': duration,
        'questionCount': questionCount,
        'questions': questions,
        'answerKeys': answerKeys,
        'status': status,
      };
}
