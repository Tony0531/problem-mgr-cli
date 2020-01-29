import 'package:flutter/material.dart';

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

  login(String name, String passwd) {
    this._loginState = UserLoginState.success;
    this._name = name;
    print("login ${this._name}");
    this.notifyListeners();
  }

  logout() {
  }
}
