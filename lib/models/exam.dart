class Exam {
  final String title;
  final String subject;
  final List<String> questions;

  Exam(this.title, this.subject, this.questions);

  factory Exam.fromJson(Map<String, dynamic> json) {
    String title = json['title'];
    String subject = json['subject'];
    List<String> questions = [];

    dynamic jsonQuestions = json['questions'];
    if (jsonQuestions is int) {
      for (int i = 0; i < jsonQuestions; ++i) {
        print("${i + 1}");
        questions.add("${i + 1}");
      }
    }

    return Exam(title, subject, questions);
  }
}
