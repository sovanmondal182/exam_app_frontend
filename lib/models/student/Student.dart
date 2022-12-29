import 'dart:convert';

import 'package:exam_app/models/exam/Exam.dart';

class Student {
  String id;
  String fname;
  String lname;
  String token;
  List<dynamic>? assignedExams;

  Student({
    required this.id,
    required this.fname,
    required this.lname,
    required this.token,
    this.assignedExams,
  });

  factory Student.fromJson(var json) {
    return Student(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      token: json['token'],
      assignedExams: json['assignedExams'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fname': fname,
        'lname': lname,
        'token': token,
        'assignedExams': jsonEncode(assignedExams),
      };
}
