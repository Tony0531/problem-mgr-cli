import 'package:flutter/material.dart';

enum QuestionLoadingState {
  notLoad,
  loading,
  loaded,
}

class Question with ChangeNotifier {
  final String _key;
  String get key => _key;

  QuestionLoadingState _loadingState;
  QuestionLoadingState get loadingState => _loadingState;

  String _title;
  String get title => _title;

  Question(this._key, this._loadingState);
}
