import 'package:flutter/material.dart';
import 'user_exam_question.dart';

enum UserExamState {
  building,
  processing,
  completed,
}

enum UserExamType {
  system,
  personal,
}

class UserExam with ChangeNotifier {
  final UserExamType type;
  final String subject;
  String _title;
  String get title => _title;

  UserExamState _state;
  UserExamState get state => _state;

  List<UserExamQuestion> _questions = [];
  List<UserExamQuestion> get questions => _questions;

  static final UserExam noExam =
      UserExam(UserExamType.personal, "", "", UserExamState.completed);

  UserExam(this.type, this.subject, this._title, this._state);

  UserExamQuestion findQuestion(String key) {
    for (UserExamQuestion q in _questions) {
      if (q.question.key == key) {
        return q;
      }
    }
    return null;
  }

  void addQuestion(UserExamQuestion question) {
    if (findQuestion(question.question.key) != null) {
      return;
    }

    _questions.add(question);
    notifyListeners();
  }

  void removeQuestion(String key) {
    var oldLength = _questions.length;
    _questions.removeWhere((question) => question.question.key == key);
    if (oldLength != _questions.length) {
      notifyListeners();
    }
  }

  void commit() {
    if (_state != UserExamState.building) {
      return;
    }

    print("exam $_title commit");
    _state = UserExamState.processing;
    notifyListeners();
  }

  void complete() {
    if (_state != UserExamState.processing) {
      return;
    }

    print("exam $_title complete");
    _state = UserExamState.completed;
    notifyListeners();
  }
}
