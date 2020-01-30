import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/User.dart';
import '../models/Exam.dart';

class ExamsPage extends StatelessWidget {
  ExamsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector(
      selector: (BuildContext context, User user) {
        return user.currentExam == null ? Exam.noExam : user.currentExam;
      },
      builder: (BuildContext context, Exam exam, Widget child) {
        return ChangeNotifierProvider<Exam>.value(
            value: exam, child: _buildScaffold(context));
      },
      //child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(child: Text("错题管理")),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          SizedBox(
            width: 300,
            child: _buildExamSelector(context),
          ),
          // Selector(
          //   selector: (BuildContext context, User user) => user.name,
          //   builder: (BuildContext context, String userName, Widget child) {
          //     return Text(userName);
          //   }
          // ),
        ],
      ),
      leading: IconButton(
        tooltip: '登出',
        icon: const Icon(Icons.exit_to_app),
        onPressed: () => Provider.of<User>(context, listen: false).logout(),
      ),
      actions: <Widget>[
        Text('1'),
        Text('2'),
        Text('3'),
      ],
    );
  }

  Widget _buildExamSelector(BuildContext context) {
    return PopupMenuButton<Exam>(
      itemBuilder: (BuildContext context) {
        var items = <PopupMenuEntry<Exam>>[];

        User user = Provider.of<User>(context, listen: false);

        for (Exam exam in user.exams) {
          items.add(PopupMenuItem<Exam>(
            value: exam,
            child: Text(exam.title),
          ));
        }

        items.add(PopupMenuItem<Exam>(
          value: Exam.noExam,
          child: Text('新建测试'),
        ));

        return items;
      },
      onSelected: (Exam exam) {
        User user = Provider.of<User>(context, listen: false);

        if (exam == Exam.noExam) {
        } else {
          user.setCurrentExam(exam);
        }
      },
      child: Selector(
        selector: (BuildContext context, Exam exam) {
          return exam == null ? null : exam.title;
        },
        builder: (BuildContext context, String examName, Widget child) {
          return Text(examName);
        },
      ),
    );
  }
}
