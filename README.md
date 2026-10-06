# CodeAlpha Flashcard Quiz App

A simple, offline Flutter flashcard study app built as part of the CodeAlpha App Development internship (Task 1).

## Features

- Add, edit, and delete flashcards
- Persistent storage using Hive (works offline, no backend)
- Study mode with Show Answer, Next, and Previous navigation
- Clean, minimal UI with an animated empty state
- Custom launcher icon

## Screens

- **Home** — list of all flashcards, with add / edit / delete actions
- **Add / Edit** — full-screen form to create or update a card
- **Study** — study the cards one at a time, reveal answers on demand

## Tech

- Flutter (Dart)
- Hive (local key-value store)
- Lottie (empty-state animation)
- flutter_launcher_icons (custom app icon)

## Project structure


lib/
main.dart
models/
flashcard.dart
services/
flashcard_service.dart
screens/
home_screen.dart
add_edit_screen.dart
study_screen.dart

text

## Getting started

bash:

flutter pub get
flutter run

Data model
Each flashcard has three fields:

id — unique string id (microsecond timestamp)

question — the text shown on the front

answer — the text shown on the back

Notes
Android only
All data is stored locally on device

Author:
elham-THEsecond — github.com/elham-THEsecond