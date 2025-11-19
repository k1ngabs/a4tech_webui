import 'package:a4tech_webui/models/chat_message_model.dart';
import 'package:flutter/material.dart';

class BotMessageTile extends StatefulWidget {
  final ChatMessage message;

  const BotMessageTile({Key? key, required this.message}) : super(key: key);

  @override
  State<BotMessageTile> createState() => _BotMessageTileState();
}

class _BotMessageTileState extends State<BotMessageTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: widget.message.isStreaming ? _buildStreamingView() : _buildStaticView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticView() {
    return Text(widget.message.content);
  }

  Widget _buildStreamingView() {
    if (_isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message.content),
          IconButton(
            icon: const Icon(Icons.expand_less),
            onPressed: () => setState(() => _isExpanded = false),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bot is typing...'),
          const SizedBox(width: 8),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
          IconButton(
            icon: const Icon(Icons.expand_more),
            onPressed: () => setState(() => _isExpanded = true),
          ),
        ],
      );
    }
  }
}
