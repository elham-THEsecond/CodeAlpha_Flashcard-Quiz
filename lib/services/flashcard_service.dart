import 'package:hive/hive.dart';
import '../models/flashcards.dart';

class FlashcardService {
  static const String _boxName = 'flashcards';

  // Get the already-opened box. We opened it in main.dart.
  Box get _box => Hive.box(_boxName);

  // Return all cards as a list, sorted by id (oldest first).
  List<Flashcard> getAllCards() {
    final cards = _box.values
        .map((value) => Flashcard.fromMap(value as Map))
        .toList();
    cards.sort((a, b) => a.id.compareTo(b.id));
    return cards;
  }

  // Add a new card. Returns the id assigned to it.
  Future<String> addCard({
    required String question,
    required String answer,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final card = Flashcard(id: id, question: question, answer: answer);
    await _box.put(id, card.toMap());
    return id;
  }

  // Update an existing card by id.
  Future<void> updateCard(Flashcard card) async {
    await _box.put(card.id, card.toMap());
  }

  // Delete a card by id.
  Future<void> deleteCard(String id) async {
    await _box.delete(id);
  }
}
