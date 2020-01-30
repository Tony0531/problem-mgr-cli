import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_info.dart';
import 'models/user.dart';
import 'app.dart';

void main() {
  final User _user = User();
  final AppInfo _appInfo = AppInfo();

  runApp(
    MultiProvider(
        providers: [
          Provider<AppInfo>.value(value: _appInfo),
          ChangeNotifierProvider<User>.value(value: _user),
        ],
        child: MyApp())
    );
}
