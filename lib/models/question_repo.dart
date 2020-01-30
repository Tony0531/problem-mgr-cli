import 'question.dart';

class QuestionRepo {
  Map<String, Question> _questions = {};

  factory QuestionRepo() => _getInstance();
  static QuestionRepo get instance => _getInstance();
  static QuestionRepo _instance;

  QuestionRepo._internal() {
    // 初始化
  }

  static QuestionRepo _getInstance() {
    if (_instance == null) {
      _instance = new QuestionRepo._internal();
    }
    return _instance;
  }

  Question findQuestion(String key) {
    return _questions[key];
  }

  Question getOrCreateQuestion(String key) {
    Question question = _questions[key];

    if (question == null) {
      question = Question(key, QuestionLoadingState.notLoad);
      _questions[key] = question;
    }

    return question;
  }
}
