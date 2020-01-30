import 'package:flutter/material.dart';
import 'exam_question.dart';

enum ExamState {
  building,
  processing,
  completed,
}

class Exam with ChangeNotifier {
  String _title;
  String get title => _title;

  ExamState _state;
  ExamState get state => _state;

  List<ExamQuestion> _questions = [];
  List<ExamQuestion> get questions => _questions;

  static final Exam noExam = Exam("", ExamState.completed);

  Exam(this._title, this._state);

  ExamQuestion findQuestion(String key) {
    for (ExamQuestion q in _questions) {
      if (q.question.key == key) {
        return q;
      }
    }
    return null;
  }

  void addQuestion(ExamQuestion question) {
    if (findQuestion(question.question.key) != null) {
      return;
    }

    _questions.add(question);
    notifyListeners();
  }
}