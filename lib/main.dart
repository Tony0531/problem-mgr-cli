import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_info.dart';
import 'models/user.dart';
import 'models/exam.dart';
import 'models/question_repo.dart';
import 'app.dart';

void main() {
  final User _user = User();
  final AppInfo _appInfo = AppInfo();

  final QuestionRepo repo = QuestionRepo.instance;
  repo.addExam(
    Exam.fromJson(
      json.decode('{"subject":"语文", "title":"测试1", question: 20}'),
    ),
  );

  runApp(MultiProvider(providers: [
    Provider<AppInfo>.value(value: _appInfo),
    ChangeNotifierProvider<User>.value(value: _user),
  ], child: MyApp()));
}
