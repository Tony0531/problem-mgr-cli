import 'package:flutter/material.dart';
import 'Exam.dart';

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

  login(String name, String passwd) {
    this._loginState = UserLoginState.success;
    this._name = name;
    print("login ${this._name}");
    this.notifyListeners();
  }

  logout() {
    print("logout ${this._name}");
    this._loginState = UserLoginState.notLogin;
    this._name = null;
    this._exams.clear();
    this.notifyListeners();
  }
}
