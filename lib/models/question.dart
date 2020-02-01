import 'package:flutter/material.dart';
import 'exam.dart';

enum QuestionLoadingState {
  notLoad,
  loading,
  loaded,
}

class Question with ChangeNotifier {
  final Exam exam;
  final String key;
  String get globalKey => makeGlobalKey(exam.title, key);
  String get subject => exam.subject;

  QuestionLoadingState _loadingState;
  QuestionLoadingState get loadingState => _loadingState;

  String _summary;
  String get summary => _summary == null ? globalKey : _summary;

  Question(this.exam, this.key, this._loadingState);

  static String makeGlobalKey(String examTitle, String key) {
    return "$examTitle - $key";
  }
}
