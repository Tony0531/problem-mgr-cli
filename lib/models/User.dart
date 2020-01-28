import 'package:flutter/material.dart';

enum UserLoginState {  
  not_login,
  inprocess,
  success,
}
 
class User with ChangeNotifier {
  UserLoginState state = UserLoginState.not_login;

  // increment(){
  //   value++;
  //   notifyListeners();
  // }
}
