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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcard Quiz')),
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

          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Edit card #${card.id} — coming next step'),
              ),
            );
          },
        );
      },
    );
  }
}
