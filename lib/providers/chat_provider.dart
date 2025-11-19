import 'package:a4tech_webui/api/ollama_api_service.dart';
import 'package:a4tech_webui/models/chat_message_model.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final OllamaApiService _apiService = OllamaApiService();

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  String? _selectedModel;
  String? get selectedModel => _selectedModel;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  String? _error;
  String? get error => _error;

  void setSelectedModel(String? modelName) {
    _selectedModel = modelName;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (_selectedModel == null) {
      _error = 'Please select a model first.';
      notifyListeners();
      return;
    }
    if (_isTyping) return;

    _messages.add(ChatMessage(content: text, sender: MessageSender.user, timestamp: DateTime.now()));
    _isTyping = true;
    _error = null;
    notifyListeners();

    final history = _messages.map((m) {
      return {'role': m.sender == MessageSender.user ? 'user' : 'assistant', 'content': m.content};
    }).toList();
    
    // Add bot's streaming message placeholder
    _messages.add(ChatMessage(content: '', sender: MessageSender.bot, timestamp: DateTime.now(), isStreaming: true));
    notifyListeners();

    try {
      final stream = _apiService.chat(_selectedModel!, history);
      await for (var chunk in stream) {
        _messages.last.content += chunk;
        notifyListeners();
      }
    } catch (e) {
      _messages.removeLast(); // Remove placeholder on error
      _error = e.toString();
    } finally {
      if(_messages.last.sender == MessageSender.bot) {
        _messages.last.isStreaming = false;
      }
      _isTyping = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages = [];
    notifyListeners();
  }
}