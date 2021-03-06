import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question_repo.dart';
import '../models/user.dart';
import '../models/user_exam.dart';
import '../models/user_exam_question.dart';
import '../models/user_question.dart';
import '../models/user_question_searcher.dart';

class ExamsPage extends StatelessWidget {
  ExamsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<User, UserExam>(
      selector: (_, user) {
        return user.currentExam == null ? UserExam.noExam : user.currentExam;
      },
      builder: (context, exam, _) {
        print("build exam");

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: exam),
            ChangeNotifierProvider.value(value: ExamPageSelectionMode()),
          ],
          child: _buildScaffold(context),
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context) {
    print("build exam.scaffold");
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
            Provider.of<User>(context, listen: false)
                .exams
                .map((UserExam exam) {
          return PopupMenuItem<UserExam>(
            value: exam,
            child: Text("${exam.subject} - ${exam.title}"),
          );
        }));
      },
      onSelected: (UserExam exam) {
        User user = Provider.of<User>(context, listen: false);
        user.setCurrentExam(exam);
      },
      child: Selector(
        selector: (BuildContext context, UserExam exam) {
          return exam == null ? null : "${exam.subject} - ${exam.title}";
        },
        builder: (BuildContext context, String examFullName, Widget child) {
          print("build exam.selector");
          return Text(examFullName);
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
    return Selector<UserExam, UserExamState>(
      selector: (context, exam) => exam.state,
      builder: (context, state, child) {
        if (state == UserExamState.building) {
          return Consumer<ExamPageSelectionMode>(
            builder: (context, selectionMode, child) {
              if (selectionMode.isAddQueston) {
                return ChangeNotifierProvider<UserQuestionSearcher>(
                  create: _createSearcher,
                  child: _buildQuestionsAreaAdd(context),
                );
              } else {
                return _buildQuestionsAreaView(context);
              }
            },
          );
        } else {
          return _buildQuestionsAreaView(context);
        }
      },
    );
  }

  UserQuestionSearcher _createSearcher(BuildContext context) {
    UserExam exam = Provider.of<UserExam>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    var searcher = UserQuestionSearcher(user);
    searcher.setSubject(exam.subject);
    searcher.go();
    return searcher;
  }

  Widget _buildQuestionsAreaAdd(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildQuestionsAreaAddCondition(context),
        Expanded(child: _buildQuestionsAreaAddResult(context)),
      ],
    );
  }

  Widget _buildQuestionsAreaAddCondition(BuildContext context) {
    return Text("条件区域");
  }

  Widget _buildQuestionsAreaAddResult(BuildContext context) {
    return Selector<UserQuestionSearcher, int>(
      selector: (_, searcher) => searcher.resultVersion,
      builder: (context, int, _) {
        print("build exam.questionsArea.add.result");

        UserQuestionSearcher searcher = Provider.of<UserQuestionSearcher>(
          context,
          listen: false,
        );

        return ListView.builder(
          itemBuilder: (context, i) {
            var question = searcher.results[i];
            return ChangeNotifierProvider<UserQuestion>.value(
              value: question,
              child: _buildUserQuestion(context, question),
            );
          },
          itemCount: searcher.results.length,
        );
      },
    );
  }

  Widget _buildUserQuestion(BuildContext context, UserQuestion question) {
    print("build user.question ${question.key}");

    UserExam exam = Provider.of<UserExam>(context, listen: false);

    Widget operations = Selector<UserQuestion, bool>(selector: (_, question) {
      return question.findInExam(exam.title) != null;
    }, builder: (context, inExam, _) {
      if (inExam) {
        return IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            exam.removeQuestion(question.key);
          },
        );
      } else {
        return IconButton(
          icon: const Icon(Icons.add_to_queue),
          onPressed: () {
            exam.addQuestion(question, ExamQuestionResult.unknown);
          },
        );
      }
    });

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

  Widget _buildQuestionsAreaView(BuildContext context) {
    return Selector<UserExam, int>(
      selector: (_, exam) => exam.questionsVersion,
      builder: (context, _, child) {
        UserExam exam = Provider.of<UserExam>(context, listen: false);

        print("build exam.questionsArea.view");

        return ListView.builder(
          itemBuilder: (context, i) {
            var question = exam.questions[i];
            return ChangeNotifierProvider<UserExamQuestion>.value(
              value: question,
              child: _buildExamQuestionWrap(context, question),
            );
          },
          itemCount: exam.questions.length,
        );
      },
    );
  }

  Widget _buildExamQuestionWrap(
      BuildContext context, UserExamQuestion question) {
    return Selector(
      selector: (BuildContext context, UserExam exam) => exam.state,
      builder: (BuildContext context, UserExamState examState, Widget child) {
        return Consumer<UserExamQuestion>(
          builder:
              (BuildContext context, UserExamQuestion question, Widget child) {
            return Card(
              margin: EdgeInsets.all(4.0),
              child: _buildExamQuestion(context, examState, question),
            );
          },
        );
      },
    );
  }

  Widget _buildExamQuestion(BuildContext context, UserExamState examState,
      UserExamQuestion question) {
    print("build exam.question ${question.question.key}");

    Widget operations;

    switch (examState) {
      case UserExamState.building:
        operations = IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            UserExam exam = Provider.of<UserExam>(context, listen: false);
            exam.removeQuestion(question.key);
          },
        );
        break;
      case UserExamState.processing:
        operations = _buildExamQuestionResultSelector(context, question);
        break;
      case UserExamState.completed:
        operations = _buildExamQuestionResult(context, question);
        break;
    }

    ListTile title = ListTile(
      leading: Icon(Icons.question_answer),
      title: Text("${question.originExam} - ${question.originExamKey}"),
      trailing: operations,
    );

    List<Widget> contents = [];
    contents.add(title);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: contents,
    );
  }

  Widget _buildExamQuestionResult(
      BuildContext context, UserExamQuestion question) {
    if (question.result == ExamQuestionResult.error) {
      return Text("错");
    } else if (question.result == ExamQuestionResult.correct) {
      return Text("对");
    } else {
      return null;
    }
  }

  Widget _buildExamQuestionResultSelector(
      BuildContext context, UserExamQuestion question) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildRadioLabel(
          Text("对"),
          question.result,
          ExamQuestionResult.correct,
          (value) => question.setResult(value),
        ),
        _buildRadioLabel(
          Text("错"),
          question.result,
          ExamQuestionResult.error,
          (value) => question.setResult(value),
        ),
      ],
    );
  }

  Widget _buildRadioLabel(
      Widget label, var value, var group, ValueChanged onChanged) {
    return GestureDetector(
      onTap: () => onChanged(group),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Radio(
            value: group,
            groupValue: value,
            onChanged: onChanged,
          ),
          label,
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Selector<UserExam, UserExamState>(
      selector: (_, exam) => exam.state,
      builder: (context, state, _) {
        print("build exam.bottomBar");

        if (state == UserExamState.building) {
          return Consumer<ExamPageSelectionMode>(
            builder: (context, state, child) {
              if (state.isAddQueston) {
                return _buildBottomAppBar(
                  <Widget>[
                    FlatButton(
                      onPressed: () {
                        Provider.of<ExamPageSelectionMode>(context)
                            .setAddQuestion(false);
                      },
                      child: Text('完成选择'),
                    ),
                  ],
                );
              } else {
                return _buildBottomAppBar(
                  <Widget>[
                    FlatButton(
                      onPressed: () {
                        Provider.of<ExamPageSelectionMode>(context)
                            .setAddQuestion(true);
                      },
                      child: Text('添加题目'),
                    ),
                    FlatButton(
                      onPressed: () => _commitExam(context),
                      child: Text('生成试卷'),
                    ),
                    FlatButton(
                      onPressed: () => _randomExam(context),
                      child: Text('随机题目'),
                    ),
                  ],
                );
              }
            },
          );
        } else if (state == UserExamState.completed) {
          return _buildBottomAppBar(
            <Widget>[
              FlatButton(
                onPressed: () => _exportExam(context),
                child: Text('下载试卷'),
              ),
            ],
          );
        } else {
          assert(state == UserExamState.processing);

          return _buildBottomAppBar(
            <Widget>[
              FlatButton(
                onPressed: () => _completeExam(context),
                child: Text('提交答案'),
              ),
              FlatButton(
                onPressed: () => _exportExam(context),
                child: Text('下载试卷'),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildBottomAppBar(List<Widget> childs) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: childs,
      ),
    );
  }

  void _createExam(BuildContext context) {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return _buildCreateExamDialog(context);
      },
    );
  }

  Widget _buildCreateExamDialog(BuildContext context) {
    var nameOfExam = TextEditingController();
    var selectedSubject =
        ExamPageSubjectSelectionMode(QuestionRepo.instance.subjects.first);

    return ChangeNotifierProvider.value(
      value: selectedSubject,
      child: SimpleDialog(
        title: Text('新建试卷'),
        children: <Widget>[
          Text("选择科目："),
          _buildCreateExamSubjectSelector(context),
          Text("请输入试卷名称："),
          TextField(
            controller: nameOfExam,
          ),
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              _doCommitExam(context, selectedSubject.subject, nameOfExam.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreateExamSubjectSelector(BuildContext context) {
    final List<String> subjects = QuestionRepo.instance.subjects;

    var subjectWidgets = <Widget>[];
    for (var subject in subjects) {
      subjectWidgets.add(
        GestureDetector(
          //onTap: () => onChanged(group),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Consumer(
                builder: (context, ExamPageSubjectSelectionMode selection, child) {
                  return Radio(
                    value: subject,
                    groupValue: selection.subject,
                    onChanged: (value) {
                      selection.setSubject(value);
                      print("xxxxxx subject=$value");
                    },
                  );
                },
              ),
              Text(subject),
            ],
          ),
        ),
      );
    }

    return Row(
      children: subjectWidgets,
    );
  }

  void _doCommitExam(BuildContext context, String subject, String examName) {
    User user = Provider.of<User>(context, listen: false);
    user.createExam(subject, examName);
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

class ExamPageSelectionMode with ChangeNotifier {
  bool _isAddQuestion = false;
  bool get isAddQueston => _isAddQuestion;

  void setAddQuestion(bool isAddQueston) {
    if (_isAddQuestion != isAddQueston) {
      _isAddQuestion = isAddQueston;
      notifyListeners();
    }
  }
}

class ExamPageSubjectSelectionMode with ChangeNotifier {
  String _subject;
  String get subject => _subject;

  ExamPageSubjectSelectionMode(this._subject);

  //bool get isAddQueston => _isAddQuestion;

  void setSubject(String subject) {
    if (_subject != subject) {
      _subject = subject;
      notifyListeners();
    }
  }
}
