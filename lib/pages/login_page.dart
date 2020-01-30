import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

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
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(80, 20, 500, 600),
          child: Text(
            '错题管理',
            style: TextStyle(fontSize: 100),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginArea(BuildContext context) {
    TextStyle titleFontStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
    );
    return AspectRatio(
      aspectRatio: 10.0 / 9.5,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 20.0,
        color: Colors.blue[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Text(
                    '账号',
                    textAlign: TextAlign.left,
                    style: titleFontStyle,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 150, 0),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '账号',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Text(
                    '密码',
                    textAlign: TextAlign.left,
                    style: titleFontStyle,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 150, 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '密码',
                ),
              ),
            ),
            Expanded(
              child: RaisedButton(
                child: const Text('登录'),
                onPressed: _login,
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Text(
                    '还没有账号？快去',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                FlatButton(
                  child: Text('注册'),
                  onPressed: _gotoRegister,
                  textColor: Colors.blue,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                ),
                Text(
                  '一个',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _gotoRegister() {}
  _login() {
    Provider.of<User>(context).login("用户1", "密码1");
  }
}
