import 'package:flutter/material.dart';
import 'question.dart';

enum ExamQuestionResult {
  unknown,
  error,
  correct,
}

class UserExamQuestion with ChangeNotifier {
  final Question _question;
  String get key => _question.globalKey;
  String get subject => _question.exam.subject;
  String get exam => _question.exam.title;
  String get examKey => _question.key;

  Question get question => _question;

  ExamQuestionResult _result;
  ExamQuestionResult get result => _result;

  UserExamQuestion(this._question, this._result);
}
