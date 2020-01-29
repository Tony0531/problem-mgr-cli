import 'package:flutter/material.dart';
import 'Question.dart';

enum ExamQuestionResult {
  unknown,
  error,
  correct,
}

class ExamQuestion  with ChangeNotifier {
  final Question _question;
  Question get question => _question;

  ExamQuestionResult _result;
  ExamQuestionResult get result => _result;
  
  ExamQuestion(this._question, this._result);
}
