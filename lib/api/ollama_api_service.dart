import 'dart:convert';
import 'package:http/http.dart' as http;

class OllamaApiService {
  final String _baseUrl = 'http://localhost:11434/api';

  Future<List<dynamic>> getLocalModels() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/tags'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['models'];
      } else {
        throw Exception('Failed to load models: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to Ollama service: $e');
    }
  }

  Stream<String> pullModel(String modelName) async* {
    try {
      final request = http.Request('POST', Uri.parse('$_baseUrl/pull'))
        ..headers['Content-Type'] = 'application/json'
        ..body = json.encode({'name': modelName, 'stream': true});

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        await for (var chunk in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
          if (chunk.isNotEmpty) {
            final decodedChunk = json.decode(chunk);
            yield decodedChunk['status'];
          }
        }
      } else {
        final errorBody = await response.stream.bytesToString();
        throw Exception('Failed to pull model: $errorBody');
      }
    } catch (e) {
      throw Exception('Failed to connect to Ollama service: $e');
    }
  }

  Future<void> deleteModel(String modelName) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/delete'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': modelName}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete model: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to Ollama service: $e');
    }
  }

  Stream<String> chat(String model, List<Map<String, String>> messages) async* {
    try {
      final request = http.Request('POST', Uri.parse('$_baseUrl/chat'))
        ..headers['Content-Type'] = 'application/json'
        ..body = json.encode({
          'model': model,
          'messages': messages,
          'stream': true,
        });

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        await for (var chunk in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
          if (chunk.isNotEmpty) {
            final decodedChunk = json.decode(chunk);
            if (decodedChunk['done'] == false) {
              yield decodedChunk['message']['content'];
            }
          }
        }
      } else {
        final errorBody = await response.stream.bytesToString();
        throw Exception('Failed to get chat response: $errorBody');
      }
    } catch (e) {
      throw Exception('Failed to connect to Ollama service: $e');
    }
  }
}