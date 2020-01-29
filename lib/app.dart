import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/AppInfo.dart';
import 'models/User.dart';
import 'pages/login_page.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final User _user = User();
  final AppInfo _appInfo = AppInfo();

  @override
  Widget build(BuildContext context) {
    return _buildLoginStage(context);
  }

  Widget _buildLoginStage(BuildContext context) {
    return MaterialApp(
      title: _appInfo.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          Provider<AppInfo>.value(value: _appInfo),
          Provider<User>.value(value: _user),
        ],
        child: LoginPage()
      )
    );
  }
}
