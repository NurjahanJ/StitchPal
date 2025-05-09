import 'package:flutter/material.dart';
import 'package:stitchpal/models/chat_message.dart';
import 'package:stitchpal/services/global_assistant_service.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/chat_bubble.dart';
import 'package:stitchpal/widgets/cute_stitch_pal_icon.dart';

class GlobalAssistantModal extends StatefulWidget {
  const GlobalAssistantModal({super.key});

  @override
  State<GlobalAssistantModal> createState() => _GlobalAssistantModalState();
}

class _GlobalAssistantModalState extends State<GlobalAssistantModal> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalAssistantService _assistantService = GlobalAssistantService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        text: "Hi there! I'm StitchPal, your crochet assistant. How can I help you today?",
        sender: MessageSender.assistant,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmit(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          sender: MessageSender.user,
        ),
      );
      _isLoading = true;
    });

    // Clear input field
    _textController.clear();

    // Scroll to bottom
    _scrollToBottom();

    // Get response from assistant
    final response = await _assistantService.getAssistance(
      userQuery: text,
      previousMessages: _messages,
    );

    // Add assistant response
    setState(() {
      _messages.add(response);
      _isLoading = false;
    });

    // Scroll to bottom again
    _scrollToBottom();
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: StitchPalTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const CuteStitchPalIcon(size: 44),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'StitchPal Assistant',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your personal crochet helper',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: _messages[index]);
                },
              ),
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: StitchPalTheme.accentColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Thinking...',
                    style: TextStyle(
                      color: StitchPalTheme.textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Ask StitchPal a question...',
                      hintStyle: TextStyle(
                        color: StitchPalTheme.textColor.withOpacity(0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: StitchPalTheme.surfaceColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: _handleSubmit,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: StitchPalTheme.primaryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    onPressed: () => _handleSubmit(_textController.text),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
