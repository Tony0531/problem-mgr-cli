import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/AppInfo.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录查看更多功能"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 2, child: _buildMessageArea(context)),
            Expanded(flex: 1, child: _buildLoginArea(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageArea(BuildContext context) {
    return Text("错题管理");
  }

  Widget _buildLoginArea(BuildContext context) {
    return Text("登录");
  }
}
