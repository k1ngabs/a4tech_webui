import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final notesPath = Directory('${directory.path}/notes');
    if (!await notesPath.exists()) {
      await notesPath.create(recursive: true);
    }
    return notesPath.path;
  }

  Future<List<File>> listNotes() async {
    final path = await _localPath;
    final dir = Directory(path);
    final files = await dir.list().toList();
    return files.whereType<File>().where((file) => file.path.endsWith('.md')).toList();
  }

  Future<File> writeNote(String fileName, String content) async {
    final path = await _localPath;
    final file = File('$path/$fileName.md');
    return file.writeAsString(content);
  }

  Future<String> readNote(File file) async {
    try {
      return await file.readAsString();
    } catch (e) {
      return 'Error reading file: $e';
    }
  }

  Future<void> deleteNote(File file) async {
    try {
      await file.delete();
    } catch (e) {
      // Handle error
    }
  }
}
