import 'package:flutter/foundation.dart';
import 'question.dart';
import 'user_exam_question.dart';

class UserQuestion with ChangeNotifier {
  final Question _question;
  List<UserExamQuestion> _examQuestions = [];

  String get key => _question.globalKey;
  String get subject => _question.exam.subject;
  String get exam => _question.exam.title;
  String get examKey => _question.key;
  Question get question => _question;

  UserQuestion(this._question);

  UserExamQuestion findInExam(String examTitle) {
    return _examQuestions.firstWhere((examQuestion) => examQuestion.exam.title == examTitle, orElse: () => null);
  }
  
  void addExamQuestion(UserExamQuestion examQuestion) {
  }

  void removeExamQuestion(UserExamQuestion examQuestion) {
  }
}
