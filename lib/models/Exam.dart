import 'package:flutter/material.dart';
import 'ExamQuestion.dart';

enum ExamState {
  building,
  processing,
  completed,
}

class Exam with ChangeNotifier {
  String _title;
  String get title => _title;

  List<ExamQuestion> _questions;
  List<ExamQuestion> get questions => _questions;

  ExamQuestion findQuestion(String key) {
    for (ExamQuestion q in _questions) {
      if (q.question.key == key) {
        return q;
      }
    }
    return null;
  }

  addQuestion(ExamQuestion question) {
    if (findQuestion(question.question.key) != null) {
      return;
    }

    _questions.add(question);
  }
}
