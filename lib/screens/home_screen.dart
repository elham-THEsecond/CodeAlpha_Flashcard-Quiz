import 'package:flashcard_quiz/screens/study_screen.dart';
import 'package:flutter/material.dart';
import '../models/flashcards.dart';
import '../services/flashcard_service.dart';
import 'add_edit_screen.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlashcardService _service = FlashcardService();

  List<Flashcard> _cards = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCards();
  }

  // Reads cards from the service and refreshes the UI.
  void _loadCards() {
    setState(() {
      _cards = _service.getAllCards();
    });
  }

  Future<void> _openAddScreen() async {
    final saved = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const AddEditScreen()));
    if (saved == true) {
      _loadCards();
    }
  }

  Future<void> _openEditScreen(Flashcard card) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddEditScreen(existingCard: card)),
    );
    if (saved == true) {
      _loadCards();
    }
  }

  Future<void> _confirmDelete(Flashcard card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete flashcard?'),
          content: Text(
            'This will permanently delete the card:\n\n"${card.question}"',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _service.deleteCard(card.id);
    _loadCards();

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Flashcard deleted')));
  }

  void _openStudyScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => StudyScreen(cards: _cards)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Flashcard Quiz'),
        ),
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.play_lesson, size: 30, color: Colors.blue[800]),
            ),

            tooltip: 'Study',
            onPressed: _cards.isEmpty ? null : _openStudyScreen,
          ),
        ],
      ),
      body: _cards.isEmpty ? _buildEmptyState() : _buildCardList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: _openAddScreen,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: Lottie.asset(
                'assets/searching_files.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No flashcards yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to add your first card.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardList() {
    return ListView.builder(
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final card = _cards[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 97, 175, 239),
              radius: 28,
              child: Text('${index + 1}'),
            ),
            title: Text(
              card.question,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(card),
            ),
            onTap: () => _openEditScreen(card),
          ),
        );
      },
    );
  }
}
