import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/user_exam.dart';
import '../models/user_exam_question.dart';

class ExamsPage extends StatelessWidget {
  ExamsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector(
      selector: (BuildContext context, User user) {
        return user.currentExam == null ? UserExam.noExam : user.currentExam;
      },
      builder: (BuildContext context, UserExam exam, Widget child) {
        return ChangeNotifierProvider<UserExam>.value(
          value: exam,
          child: child,
        );
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    print("build exam");
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildQuestionsArea(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: '登出',
        icon: const Icon(Icons.exit_to_app),
        onPressed: () => Provider.of<User>(context, listen: false).logout(),
      ),
      title: Row(
        children: <Widget>[
          SizedBox(
            width: 300,
            child: _buildExamSelector(context),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => _createExam(context),
          child: Text(
            '新建试卷',
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        ),
        _buildUserInfo(context),
      ],
    );
  }

  Widget _buildExamSelector(BuildContext context) {
    return PopupMenuButton<UserExam>(
      itemBuilder: (BuildContext context) {
        return List<PopupMenuEntry<UserExam>>.from(
            Provider.of<User>(context, listen: false).exams.map((UserExam exam) {
          return PopupMenuItem<UserExam>(
            value: exam,
            child: Text(exam.title),
          );
        }));
      },
      onSelected: (UserExam exam) {
        User user = Provider.of<User>(context, listen: false);
        user.setCurrentExam(exam);
      },
      child: Selector(
        selector: (BuildContext context, UserExam exam) {
          return exam == null ? null : exam.title;
        },
        builder: (BuildContext context, String examName, Widget child) {
          print("build exam.selector");
          return Text(examName);
        },
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Selector(
      selector: (BuildContext context, User user) => user.name,
      builder: (BuildContext context, String userName, Widget child) {
        print("build exam.userInfo");
        return Center(
          child: Text(
            '$userName 欢迎您',
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        );
      },
    );
  }

  Widget _buildQuestionsArea(BuildContext context) {
    return Selector(
      selector: (BuildContext context, UserExam exam) => exam.questions,
      builder:
          (BuildContext context, List<UserExamQuestion> questions, Widget child) {
        print("build exam.questionsArea");

        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List<Widget>.from(questions.map((UserExamQuestion question) {
              return ChangeNotifierProvider<UserExamQuestion>.value(
                value: question,
                child: _buildQuestionWrap(context, question),
              );
            })));
      },
    );
  }

  Widget _buildQuestionWrap(BuildContext context, UserExamQuestion question) {
    return Selector(
      selector: (BuildContext context, UserExam exam) => exam.state,
      builder: (BuildContext context, UserExamState examState, Widget child) {
        return Consumer<UserExamQuestion>(
          builder: (BuildContext context, UserExamQuestion question, Widget child) {
            return Card(
              margin: EdgeInsets.all(4.0),
              child: _buildQuestion(context, examState, question),
            );
          },
        );
      },
    );
  }

  Widget _buildQuestion(
      BuildContext context, UserExamState examState, UserExamQuestion question) {
    print("build exam.question ${question.question.key}");

    Widget operations;

    switch (examState) {
      case UserExamState.building:
        operations = IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => {},
        );
        break;
      case UserExamState.processing:
        operations = IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => {},
        );
        break;
      case UserExamState.completed:
        break;
    }

    ListTile title = ListTile(
      leading: Icon(Icons.question_answer),
      title: Text("${question.exam} - ${question.examKey}"),
      trailing: operations,
    );

    List<Widget> contents = [];
    contents.add(title);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: contents,
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Selector(
      selector: (BuildContext context, UserExam exam) => exam.state,
      builder: (BuildContext context, UserExamState state, Widget child) {
        print("build exam.bottomBar");
        List<Widget> actions = [];

        switch (state) {
          case UserExamState.building:
            actions
              ..add(FlatButton(
                onPressed: () => _commitExam(context),
                child: Text('生成试卷'),
              ))
              ..add(FlatButton(
                onPressed: () => _randomExam(context),
                child: Text('随机题目'),
              ));
            break;
          case UserExamState.completed:
            actions
              ..add(FlatButton(
                onPressed: () => _exportExam(context),
                child: Text('下载试卷'),
              ));
            break;
          case UserExamState.processing:
            actions
              ..add(FlatButton(
                onPressed: () => _completeExam(context),
                child: Text('提交答案'),
              ))
              ..add(FlatButton(
                onPressed: () => _exportExam(context),
                child: Text('下载试卷'),
              ));
            break;
        }

        return BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions,
          ),
        );
      },
    );
  }

  void _createExam(BuildContext context) {
    var nameOfExam = TextEditingController();

    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('请输入试卷名称：'),
          children: <Widget>[
            TextField(
              controller: nameOfExam,
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                _doCommitExam(context, nameOfExam.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _doCommitExam(BuildContext context, String examName) {
    User user = Provider.of<User>(context, listen: false);
    user.createExam(examName);
  }

  void _commitExam(BuildContext context) {
    UserExam exam = Provider.of<UserExam>(context, listen: false);
    exam.commit();
  }

  void _randomExam(BuildContext context) {}

  void _completeExam(BuildContext context) {
    UserExam exam = Provider.of<UserExam>(context, listen: false);
    exam.complete();
  }

  void _exportExam(BuildContext context) {}
}
