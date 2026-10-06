import 'package:flutter/material.dart';
import '../models/flashcards.dart';

class StudyScreen extends StatefulWidget {
  final List<Flashcard> cards;

  const StudyScreen({super.key, required this.cards});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  Flashcard get _currentCard => widget.cards[_currentIndex];
  bool get _isFirst => _currentIndex == 0;
  bool get _isLast => _currentIndex == widget.cards.length - 1;

  void _next() {
    if (_isLast) return;
    setState(() {
      _currentIndex++;
      _showAnswer = false;
    });
  }

  void _previous() {
    if (_isFirst) return;
    setState(() {
      _currentIndex--;
      _showAnswer = false;
    });
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Study — ${_currentIndex + 1} / ${widget.cards.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('QUESTION', style: theme.textTheme.labelSmall),
                          const SizedBox(height: 12),
                          Text(
                            _currentCard.question,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge,
                          ),
                          if (_showAnswer) ...[
                            const SizedBox(height: 32),
                            const Divider(),
                            const SizedBox(height: 16),
                            Text('ANSWER', style: theme.textTheme.labelSmall),
                            const SizedBox(height: 12),
                            Text(
                              _currentCard.answer,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _toggleAnswer,
                icon: Icon(
                  _showAnswer ? Icons.visibility_off : Icons.visibility,
                ),
                label: Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isFirst ? null : _previous,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLast ? null : _next,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
