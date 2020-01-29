import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/AppInfo.dart';
import 'models/User.dart';
import 'pages/login_page.dart';
import 'pages/exams_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final AppInfo appInfo = Provider.of<AppInfo>(context);
    
    return MaterialApp(
        title: appInfo.title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: user.loginState == UserLoginState.success ? ExamsPage() : LoginPage()
      );
  }
}
