import 'package:flutter/foundation.dart';
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
    return Container(
        margin: const EdgeInsets.all(10.0),
        color: Colors.amber[600],
        height: 48.0,
        //transform: Matrix4.rotationZ(0.1),
        child: Text("错题管理"));
  }

  Widget _buildLoginArea(BuildContext context) {
    TextStyle titleFontStyle = TextStyle(
      color: Color(0xFFFFFFFF),
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
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 430, 20),
              child: Text(
                '账号',
                textAlign: TextAlign.left,
                style: titleFontStyle,
              ),
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '账号',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 430, 20),
              child: Text(
                '密码',
                textAlign: TextAlign.left,
                style: titleFontStyle,
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '密码',
              ),
            ),
            RaisedButton(
              child: const Text('登录'),
              onPressed: _login,
            ),
            Row(
              children: <Widget>[
                Text(
                  '还没有账号？快去',
                  textAlign: TextAlign.left,
                ),
                FlatButton(
                  child: Text('注册'),
                  onPressed: _gotoRegister,
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                ),
                Text(
                  '一个',
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
