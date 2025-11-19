import 'dart:io';
import 'package:a4tech_webui/models/note_model.dart';
import 'package:a4tech_webui/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class NotesProvider with ChangeNotifier {
  final FileService _fileService = FileService();

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotesProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    final files = await _fileService.listNotes();
    _notes = files.map((file) {
      final title = p.basenameWithoutExtension(file.path);
      return Note(file: file, title: title);
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNoteContent(Note note) async {
    note.content = await _fileService.readNote(note.file);
    notifyListeners();
  }

  Future<void> createNote(String title, String content) async {
    final newTitle = title.replaceAll(' ', '_');
    await _fileService.writeNote(newTitle, content);
    await loadNotes();
  }

  Future<void> saveNote(Note note, String newContent) async {
    note.content = newContent;
    await _fileService.writeNote(p.basenameWithoutExtension(note.file.path), newContent);
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    await _fileService.deleteNote(note.file);
    await loadNotes();
  }
}
