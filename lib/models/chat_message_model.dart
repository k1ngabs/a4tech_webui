enum MessageSender { user, bot }

class ChatMessage {
  String content;
  final MessageSender sender;
  final DateTime timestamp;
  bool isStreaming;

  ChatMessage({
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isStreaming = false,
  });
}