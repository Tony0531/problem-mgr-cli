import 'package:flutter/material.dart';
import 'user_exam.dart';
import 'user_question.dart';

enum ExamQuestionResult {
  unknown,
  error,
  correct,
}

class UserExamQuestion with ChangeNotifier {
  final UserExam exam;
  final UserQuestion question;
  String get key => question.key;
  String get subject => question.subject;
  String get originExam => question.exam;
  String get originExamKey => question.examKey;

  ExamQuestionResult _result;
  ExamQuestionResult get result => _result;

  UserExamQuestion(this.exam, this.question, this._result)
      : assert(exam != null),
        assert(question != null) {
  }
}
