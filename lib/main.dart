import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'models/User.dart';
import 'app.dart';

void main() {
  var user = User();
  var providers = Providers();

  providers..provide(Provider<User>.value(user));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}
