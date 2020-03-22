import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_info.dart';
import 'models/user.dart';
import 'models/exam.dart';
import 'models/question_repo.dart';
import 'app.dart';

void main() {
  final Dio dio = new Dio();
  dio.options.baseUrl = "http://127.0.0.1:3000";
  dio.options.connectTimeout = 5000; //5s
  dio.options.responseType = ResponseType.json;
  dio.options.receiveTimeout = 3000;

  final User user = User(dio);
  final AppInfo appInfo = AppInfo();

  final QuestionRepo repo = QuestionRepo.instance;
  repo.addExam(
    Exam.fromJson(
      json.decode('{"subject":"语文", "title":"测试1", "questions": 20}'),
    ),
  );

  repo.addExam(
    Exam.fromJson(
      json.decode('{"subject":"数学", "title":"期末测试", "questions": 5}'),
    ),
  );

  runApp(MultiProvider(providers: [
    Provider<AppInfo>.value(value: appInfo),
    ChangeNotifierProvider<User>.value(value: user),
  ], child: MyApp()));
}
