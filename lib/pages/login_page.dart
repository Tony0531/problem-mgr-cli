import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/server_error.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);

  final _userTF = TextEditingController();
  final _pwdTF = TextEditingController();

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
        color: Theme.of(context).primaryColor,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: SizedBox(
                    width: 400,
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '账号',
                      ),
                      controller: _userTF,
                    ),
                  ),
                ),
              ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 30),
                  child: SizedBox(
                    width: 400,
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '密码',
                      ),
                      controller: _pwdTF,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 350,
                  height: 90,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    child: const Text(
                      '登录',
                      style: TextStyle(fontSize: 40),
                    ),
                    onPressed: () => _login(context),
                  ),
                ),
              ],
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  textColor: Colors.white,
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

  _login(BuildContext context) async {
    try {
      await Provider.of<User>(context).login(_userTF.text, _pwdTF.text);
    } on ServerError catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new SimpleDialog(
              title: new Text('错误信息'),
              children: <Widget>[
                new Text(e.code.toString()),
                new Text(e.message),
              ],
            );
          });
    }
  }
}
