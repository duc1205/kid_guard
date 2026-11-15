import 'dart:math';

enum QuestionType {
  /// Kiến thức các môn học trong chương trình của lớp.
  academic,

  /// Câu hỏi mở: kỹ năng sống, tình huống, đạo đức.
  open,

  /// Kiến thức xã hội bên ngoài.
  social,
}

class Question {
  const Question({
    required this.id,
    required this.grade,
    required this.subject,
    required this.topic,
    required this.type,
    required this.text,
    required this.options,
    required this.answerIndex,
    required this.suggestion,
    this.optionOrder = const [0, 1, 2, 3],
    this.difficulty,
    this.term,
  }) : assert(options.length == 4);

  final String id;
  final int grade;
  final String subject;
  final String topic;
  final QuestionType type;
  final String text;

  /// Luôn đúng 4 đáp án, hiển thị lần lượt là A, B, C, D.
  final List<String> options;
  final int answerIndex;

  /// Gợi ý phần kiến thức cần củng cố khi trả lời sai.
  final String suggestion;

  /// Độ khó 1 (dễ) – 3 (khó); null = chưa phân loại.
  final int? difficulty;

  /// Học kỳ 1 hoặc 2 của năm học; null = cả năm / không áp dụng.
  final int? term;

  /// optionOrder[i] = vị trí gốc (trong ngân hàng câu hỏi) của đáp án đang hiển thị ở ô i.
  final List<int> optionOrder;

  bool isCorrect(int chosenIndex) => chosenIndex == answerIndex;

  /// Đảo thứ tự đáp án để trẻ không học thuộc vị trí A/B/C/D.
  Question shuffled(Random random) {
    final order = List<int>.generate(options.length, (i) => i)..shuffle(random);
    return Question(
      id: id,
      grade: grade,
      subject: subject,
      topic: topic,
      type: type,
      text: text,
      options: [for (final i in order) options[i]],
      answerIndex: order.indexOf(answerIndex),
      suggestion: suggestion,
      optionOrder: [for (final i in order) optionOrder[i]],
      difficulty: difficulty,
      term: term,
    );
  }
}
