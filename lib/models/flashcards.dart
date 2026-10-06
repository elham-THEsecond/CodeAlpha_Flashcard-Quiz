class Flashcard {
  final String id;
  final String question;
  final String answer;

  Flashcard({required this.id, required this.question, required this.answer});

  Map<String, dynamic> toMap() {
    return {'id': id, 'question': question, 'answer': answer};
  }

  factory Flashcard.fromMap(Map<dynamic, dynamic> map) {
    return Flashcard(
      id: map['id'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
    );
  }

  Flashcard copyWith({String? id, String? question, String? answer}) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }
}
