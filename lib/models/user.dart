import 'package:flutter/material.dart';
import 'user_exam.dart';
import 'user_exam_question.dart';
import 'exam.dart';
import 'question.dart';
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

  List<UserExam> _exams = <UserExam>[];
  List<UserExam> get exams => _exams;

  UserExam _currentExam;
  UserExam get currentExam => _currentExam;

  void login(String name, String passwd) {
    _loginState = UserLoginState.success;
    _name = name;
    _currentExam = null;
    _exams.clear();

    _syncExams();
    _currentExam = _exams.isEmpty ? null : _exams.last;

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

  UserExam findExam(String title) {
    return _exams.firstWhere((exam) => exam.title == title, orElse: () => null);
  }

  void setCurrentExam(UserExam exam) {
    assert(_exams.indexOf(exam) >= 0);
    if (_currentExam != exam) {
      _currentExam = exam;
      notifyListeners();
    }
  }

  void createExam(String examName) {
    UserExam exam =
        UserExam(UserExamType.personal, examName, UserExamState.building);
    _exams.add(exam);
    _currentExam = exam;
    notifyListeners();
  }

  void _syncExams() {
    final QuestionRepo repo = QuestionRepo.instance;

    for (Exam exam in repo.exams) {
      if (findExam(exam.title) != null) {
        continue;
      }

      UserExam userExam = UserExam(
        UserExamType.system,
        exam.title,
        UserExamState.processing,
      );
      _exams.add(userExam);

      for (String questionKey in exam.questions) {
        Question question =
            repo.findQuestion(Question.makeGlobalKey(exam.title, questionKey));
        assert(question != null);

        UserExamQuestion userQuestion = UserExamQuestion(
          question,
          ExamQuestionResult.unknown,
        );

        userExam.addQuestion(userQuestion);
      }
    }
  }
}
