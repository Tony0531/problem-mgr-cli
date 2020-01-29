import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/User.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final _userTF = TextEditingController();
  // final _pwdTF = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录查看更多功能"),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("账号"),
        Text("密码"),
        RaisedButton(
          child: const Text("登录"),
          onPressed: _login,
        ),
      ],
    );
  }

  _login() {
    Provider.of<User>(context).login("用户1", "密码1");
  }
}
