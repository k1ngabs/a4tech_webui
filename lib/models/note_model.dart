import 'dart:io';

class Note {
  final File file;
  String title;
  String content;

  Note({
    required this.file,
    required this.title,
    this.content = '',
  });
}
