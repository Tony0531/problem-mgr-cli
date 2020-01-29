import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/AppInfo.dart';
import 'models/User.dart';
import 'pages/login_page.dart';
import 'pages/exams_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppInfo appInfo = Provider.of<AppInfo>(context, listen: false);

    return MaterialApp(
        title: appInfo.title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Selector(
          builder: (BuildContext context, UserLoginState loginState, Widget child) {
            return loginState == UserLoginState.success
              ? ExamsPage()
              : LoginPage();
            },
            selector: (BuildContext context, User user) => user.loginState,
          ),
        );
  }
}
