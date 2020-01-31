import 'package:flutter/foundation.dart';
import 'user.dart';
import 'user_question.dart';
import 'question.dart';
import 'question_repo.dart';

enum UserQuestionOrder {
  errorCount,
}

class UserQuestionSearcher with ChangeNotifier {
  final User user;

  String _subject;
  String get subject => _subject;
  void setSubject(String subject) {
    if (_subject != subject) {
      _subject = subject;
      notifyListeners();
    }
  }

  UserQuestionOrder _order = UserQuestionOrder.errorCount;
  UserQuestionOrder get order => _order;
  void setOrder(UserQuestionOrder order) {
    if (_order != order) {
      _order = order;

      if (_results.isEmpty) {
      } else {
        _sortResults();
        _resultVersion++;
      }

      notifyListeners();
    }
  }

  int _resultVersion = 0;
  int get resultVersion => _resultVersion;
  List<UserQuestion> _results = [];
  List<UserQuestion> get results => _results;

  UserQuestionSearcher(this.user) : assert(user != null);

  void go() {
    _results.clear();
    _buildREsults();
    _sortResults();

    _resultVersion++;
    notifyListeners();
  }

  void clear() {
    _results.clear();

    _resultVersion++;
    notifyListeners();
  }

  void _buildREsults() {
    final QuestionRepo repo = QuestionRepo.instance;

    for (Question q in repo.questions) {
      _results.add(user.checkCreateQuestion(q));
    }
  }

  void _sortResults() {}
}
