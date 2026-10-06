import 'package:flashcard_quiz/screens/study_screen.dart';
import 'package:flutter/material.dart';
import '../models/flashcards.dart';
import '../services/flashcard_service.dart';
import 'add_edit_screen.dart';

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
        title: const Text('Flashcard Quiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.school_outlined),
            tooltip: 'Study',
            onPressed: _cards.isEmpty ? null : _openStudyScreen,
          ),
        ],
      ),
      body: _cards.isEmpty ? _buildEmptyState() : _buildCardList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.style_outlined, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No flashcards yet!',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + to Add your first flashcrad!',
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
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(
            card.question,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(card),
          ),
          onTap: () => _openEditScreen(card),
        );
      },
    );
  }
}
