import 'package:flutter/material.dart';
import 'exam.dart';
import 'exam_question.dart';
import 'question_repo.dart';

enum UserLoginState {
  notLogin,
  inprocess,
  success,
}

class User with ChangeNotifier {
  UserLoginState _loginState = UserLoginState.notLogin;
  UserLoginState get loginState => _loginState;

  String _name;
  String get name => _name;

  List<Exam> _exams = <Exam>[];
  List<Exam> get exams => _exams;

  Exam _currentExam;
  Exam get currentExam => _currentExam;

  void login(String name, String passwd) {
    _loginState = UserLoginState.success;
    _name = name;
    _loadDebugExams();
    _currentExam = _exams.last;

    print("login ${this._name}");
    this.notifyListeners();
  }

  void logout() {
    print("logout ${this._name}");
    _loginState = UserLoginState.notLogin;
    _name = null;
    _currentExam = null;
    _exams.clear();

    notifyListeners();
  }

  void setCurrentExam(Exam exam) {
    assert(_exams.indexOf(exam) >= 0);
    if (_currentExam != exam) {
      _currentExam = exam;
      notifyListeners();
    }
  }

  void createExam(String examName) {
    Exam exam = Exam(examName, ExamState.building);
    _exams.add(exam);
    _currentExam = exam;
    notifyListeners();
  }

  void _loadDebugExams() {
    _currentExam = null;
    _exams.clear();

    final QuestionRepo repo = QuestionRepo.instance;

    for (String examName in ["测试1", "测试2", "测试3"]) {
      Exam exam = Exam(examName, ExamState.processing);
      _exams.add(exam);

      for (String questionKey in ["q1", "q2", "q3"]) {
        ExamQuestion question = ExamQuestion(
          repo.getOrCreateQuestion(questionKey),
          ExamQuestionResult.unknown,
        );

        exam.addQuestion(question);
      }
    }
  }
}
