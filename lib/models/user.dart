import 'package:flutter/material.dart';
import 'user_exam.dart';
import 'user_question.dart';
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

  List<UserExam> _exams = [];
  List<UserExam> get exams => _exams;

  Map<String, UserQuestion> _questions = {};

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

    _exams.forEach((exam) => exam.dispose());
    _exams.clear();

    _questions.forEach((_, question) => question.dispose());
    _questions.clear();

    notifyListeners();
  }

  UserQuestion findQuestion(String questionKey) {
    return _questions[questionKey];
  }

  UserQuestion checkCreateQuestion(Question question) {
    UserQuestion userQuestion = _questions[question.key];

    if (userQuestion == null) {
      userQuestion = UserQuestion(question);
      _questions[question.key] = userQuestion;
    }

    return userQuestion;
  }

  UserExam findExam(String title) {
    return _exams.firstWhere((exam) => exam.title == title, orElse: () => null);
  }

  void setCurrentExam(UserExam exam) {
    assert(_exams.indexOf(exam) >= 0);
    if (_currentExam != exam) {
      _currentExam = exam;
      print("exam switch ${_currentExam == null ? 'N/A' : exam.title}");
      notifyListeners();
    }
  }

  void createExam(String subject, String examName) {
    UserExam exam = UserExam(
        UserExamType.personal, subject, examName, UserExamState.building);
    _exams.add(exam);
    _currentExam = exam;
    print("exam create $examName");
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
        exam.subject,
        exam.title,
        UserExamState.processing,
      );
      _exams.add(userExam);

      for (String questionKey in exam.questions) {
        Question question =
            repo.findQuestion(Question.makeGlobalKey(exam.title, questionKey));
        assert(question != null);

        UserExamQuestion userQuestion = UserExamQuestion(
          checkCreateQuestion(question),
          ExamQuestionResult.unknown,
        );

        userExam.addQuestion(userQuestion);
      }
    }
  }
}
