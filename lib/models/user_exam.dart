import 'package:flutter/material.dart';
import 'user_question.dart';
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
  int _questionsVersion = 0;
  int get questionsVersion => _questionsVersion;

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

  UserExamQuestion addQuestion(
      UserQuestion userQuestion, ExamQuestionResult result) {
    UserExamQuestion question = findQuestion(userQuestion.key);
    if (question != null) {
      return question;
    }

    question = UserExamQuestion(
      this,
      userQuestion,
      result,
    );
    userQuestion.addExamQuestion(question);

    print("exam $title: + [${userQuestion.key}]");
    _questions.add(question);
    _questionsVersion++;
    notifyListeners();

    return question;
  }

  void removeQuestion(String key) {
    int idx = _questions.indexWhere((question) => question.key == key);
    if (idx >= 0) {
      UserExamQuestion question = _questions.removeAt(idx);
      question.question.removeExamQuestion(question);
      print("exam $title: - [$key]");
      _questionsVersion++;
      notifyListeners();
    } else {
      print("exam $title: - [$key] !!!");
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

  void clear() {
    _questions.forEach(
      (question) => question.question.removeExamQuestion(question),
    );
    _questions.clear();
  }
}
