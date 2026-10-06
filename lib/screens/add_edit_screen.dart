import 'package:flutter/material.dart';
import '../models/flashcards.dart';
import '../services/flashcard_service.dart';

class AddEditScreen extends StatefulWidget {
  // Optional: pass a card for edit mode, leave null for add mode.
  final Flashcard? existingCard;

  const AddEditScreen({super.key, this.existingCard});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final FlashcardService _service = FlashcardService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _answerController;

  bool get _isEditing => widget.existingCard != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill the controllers if editing; empty strings if adding.
    _questionController = TextEditingController(
      text: widget.existingCard?.question ?? '',
    );
    _answerController = TextEditingController(
      text: widget.existingCard?.answer ?? '',
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();

    if (_isEditing) {
      final updated = widget.existingCard!.copyWith(
        question: question,
        answer: answer,
      );
      await _service.updateCard(updated);
    } else {
      await _service.addCard(question: question, answer: answer);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true); // true = "something changed"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Flashcard' : 'New Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Question cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Answer cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
