import 'package:flutter/foundation.dart';
import 'user.dart';
import 'user_question.dart';

enum UserQuestionOrder {
  none,
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
  
  UserQuestionOrder _order = UserQuestionOrder.none;
  UserQuestionOrder get order => _order;
  void setOrder(UserQuestionOrder order) {
    if (_order != order) {
      _order = order;
      _sortResults();
      notifyListeners();
    }
  }

  List<UserQuestion> _results = [];
  List<UserQuestion> get results => _results;

  UserQuestionSearcher(this.user) : assert(user != null);

  void go() {
    _buildREsults();
    _sortResults();
  }

  void _buildREsults() {
  }

  void _sortResults() {
  }
}
