import 'package:a4tech_webui/providers/notes_provider.dart';
import 'package:a4tech_webui/screens/note_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          if (notesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notesProvider.notes.isEmpty) {
            return const Center(
              child: Text('No notes yet. Tap the + button to create one!'),
            );
          }

          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              return ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(note.title),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NoteEditorScreen(note: note),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    // TODO: Add confirmation dialog
                    notesProvider.deleteNote(note);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}