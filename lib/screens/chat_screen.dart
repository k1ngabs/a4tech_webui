import 'package:a4tech_webui/models/chat_message_model.dart';
import 'package:a4tech_webui/providers/chat_provider.dart';
import 'package:a4tech_webui/providers/model_provider.dart';
import 'package:a4tech_webui/widgets/bot_message_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final modelProvider = Provider.of<ModelProvider>(context, listen: false);
      if (chatProvider.selectedModel == null && modelProvider.models.isNotEmpty) {
        chatProvider.setSelectedModel(modelProvider.models.first.name);
      }
    });
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(_textController.text);
      _textController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    // Scroll to bottom when a new message is added or streamed
    if (chatProvider.messages.isNotEmpty) {
      _scrollToBottom();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildModelSelector(modelProvider, chatProvider),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear Chat',
            onPressed: () => chatProvider.clearChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                if (message.sender == MessageSender.user) {
                  return _buildUserMessage(message);
                } else {
                  return BotMessageTile(message: message);
                }
              },
            ),
          ),
          if (chatProvider.error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Error: ${chatProvider.error}', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildModelSelector(ModelProvider modelProvider, ChatProvider chatProvider) {
    return DropdownButton<String>(
      value: chatProvider.selectedModel ?? (modelProvider.models.isNotEmpty ? modelProvider.models.first.name : null),
      hint: const Text('Select a model'),
      isExpanded: true,
      onChanged: (String? newValue) {
        if (newValue != null) {
          chatProvider.setSelectedModel(newValue);
        }
      },
      items: modelProvider.models.map<DropdownMenuItem<String>>((model) {
        return DropdownMenuItem<String>(
          value: model.name,
          child: Text(model.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
    );
  }

  Widget _buildUserMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Text(message.content),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              onSubmitted: chatProvider.isTyping ? null : (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: chatProvider.isTyping ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
