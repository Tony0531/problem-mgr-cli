import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/exam.dart';
import '../models/exam_question.dart';

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
          value: exam,
          child: child,
        );
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
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
          // FlatButton(
          //   onPressed: _createExam,
          //   child: Text('生成试卷', style: Theme.of(context).primaryTextTheme.headline6),
          // ),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: _buildUserInfo(context),
          // ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: _createExam,
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
    return PopupMenuButton<Exam>(
      itemBuilder: (BuildContext context) {
        return List<PopupMenuEntry<Exam>>.from(
            Provider.of<User>(context, listen: false).exams.map((Exam exam) {
          return PopupMenuItem<Exam>(
            value: exam,
            child: Text(exam.title),
          );
        }));
      },
      onSelected: (Exam exam) {
        User user = Provider.of<User>(context, listen: false);
        user.setCurrentExam(exam);
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

  Widget _buildUserInfo(BuildContext context) {
    return Selector(
      selector: (BuildContext context, User user) => user.name,
      builder: (BuildContext context, String userName, Widget child) {
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
      selector: (BuildContext context, Exam exam) => exam.questions,
      builder:
          (BuildContext context, List<ExamQuestion> questions, Widget child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List<Widget>.from(questions.map((ExamQuestion question) {
            return ChangeNotifierProvider<ExamQuestion>.value(
              value: question,
              child: Consumer<ExamQuestion>(
                builder: (BuildContext context, ExamQuestion question,
                    Widget child) {
                  return Card(
                    margin: EdgeInsets.all(4.0),
                    child: _buildQuestion(context, question),
                  );
                },
              ),
            );
          })),
        );
      },
    );
  }

  Widget _buildQuestion(BuildContext context, ExamQuestion question) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.album),
          title: Text(question.question.title == null
              ? "N/A"
              : question.question.title),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Selector(
      selector: (BuildContext context, Exam exam) => exam.state,
      builder: (BuildContext context, ExamState state, Widget child) {
        switch (state) {
          case ExamState.building:
            break;
          case ExamState.completed:
            return null;
          case ExamState.processing:
            break;
        }
        return BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: _commitExam,
                child: Text('生成试卷'),
              ),
              FlatButton(
                onPressed: _randomFillExam,
                child: Text('随机题目'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _createExam() {}

  void _commitExam() {}

  void _randomFillExam() {
  }
}
