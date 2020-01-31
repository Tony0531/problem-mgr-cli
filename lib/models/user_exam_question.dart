import 'package:flutter/material.dart';
import 'user_question.dart';

enum ExamQuestionResult {
  unknown,
  error,
  correct,
}

class UserExamQuestion with ChangeNotifier {
  final UserQuestion _question;
  String get key => _question.key;
  String get subject => _question.subject;
  String get exam => _question.exam;
  String get examKey => _question.examKey;

  UserQuestion get question => _question;

  ExamQuestionResult _result;
  ExamQuestionResult get result => _result;

  UserExamQuestion(this._question, this._result) : assert(_question != null) {
    _question.addExamQuestion(this);
  }

  @override
  void dispose() {
    _question.removeExamQuestion(this);
    super.dispose();
  }
}
