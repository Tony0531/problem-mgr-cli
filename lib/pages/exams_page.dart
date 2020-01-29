import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/User.dart';

class ExamsPage extends StatelessWidget {
  ExamsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Provider.of<User>(context).name}'),
      ),
      body: Center(
        child: Text("错题管理")
      ),
    );
  }
}
