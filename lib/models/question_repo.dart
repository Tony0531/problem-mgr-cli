import 'exam.dart';
import 'question.dart';

class QuestionRepo {
  List<String> _subjects = [];
  List<String> get subjects => _subjects;

  Map<String, Exam> _exams = {};
  List<Exam> get exams => List.from(_exams.values);

  Map<String, Question> _questions = {};
  List<Question> get questions => List.from(_questions.values);

  factory QuestionRepo() => _getInstance();
  static QuestionRepo get instance => _getInstance();
  static QuestionRepo _instance;

  QuestionRepo._() {
    // 初始化
  }

  static QuestionRepo _getInstance() {
    if (_instance == null) {
      _instance = new QuestionRepo._();
    }
    return _instance;
  }

  Question findQuestion(String key) {
    return _questions[key];
  }

  Exam findExam(String title) {
    return _exams[title];
  }

  void addExam(Exam exam) {
    if (_exams.containsKey(exam.title)) {
      return;
    }

    if (_subjects.indexOf(exam.subject) < 0) {
      _subjects.add(exam.subject);
    }

    _exams[exam.title] = exam;

    for (String key in exam.questions) {
      Question question = Question(exam, key, QuestionLoadingState.notLoad);
      _questions[question.globalKey] = question;
    }
  }
}
