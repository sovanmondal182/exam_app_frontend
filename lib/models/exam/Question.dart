import 'dart:convert';

class Question {
  final String title;
  final Map<String, dynamic> options;

  Question({
    required this.title,
    required this.options,
  });

  factory Question.fromJson(json) {
    return Question(
      title: json['title'],
      options: json['options'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'options': jsonEncode(options),
      };
}
