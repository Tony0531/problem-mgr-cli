import 'package:flutter/material.dart';
import 'question.dart';

enum ExamQuestionResult {
  unknown,
  error,
  correct,
}

class UserExamQuestion  with ChangeNotifier {
  final Question _question;
  Question get question => _question;

  ExamQuestionResult _result;
  ExamQuestionResult get result => _result;
  
  UserExamQuestion(this._question, this._result);
}
