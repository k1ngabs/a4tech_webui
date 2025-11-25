import 'package:a4tech_webui/models/chat_message_model.dart';
import 'package:flutter/material.dart';

class BotMessageTile extends StatefulWidget {
  final ChatMessage message;

  const BotMessageTile({Key? key, required this.message}) : super(key: key);

  @override
  State<BotMessageTile> createState() => _BotMessageTileState();
}

class _BotMessageTileState extends State<BotMessageTile> {
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
    final content = widget.message.content;
    final thinkRegex = RegExp(r'<think>([\s\S]*?)<\/think>');
    final matches = thinkRegex.allMatches(content);

    if (matches.isEmpty) {
      return Text(content);
    }

    final thinkContents = matches.map((m) => m.group(1)!).toList();
    final visibleContent = content.replaceAll(thinkRegex, '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (visibleContent.isNotEmpty) Text(visibleContent),
        ExpansionTile(
          title: const Text('Show thoughts'),
          children: [
            for (final thinkContent in thinkContents)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(thinkContent.trim()),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreamingView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text('Bot is typing...'),
        SizedBox(width: 8),
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.0),
        ),
      ],
    );
  }
}
