import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/messaging/web/components/chat_message_widget.dart';
import 'package:reentry/ui/modules/messaging/web/components/message_model.dart';

class ChatScreen extends StatefulWidget {
  final UserDto currentUser;
  final ClientDto chatPartner;

  ChatScreen({required this.currentUser, required this.chatPartner});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<MessageModel> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDummyChats();
  }

  void _loadDummyChats() {
    setState(() {
      _messages.addAll([
        MessageModel(
          text:
              "Hey Olivia, can you please review the latest design when you can?",
          sender: widget.currentUser,
          receiver: widget.chatPartner,
          avatar: Assets.imagesCitiImg,
          timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        ),
        MessageModel(
          text:
              "Hey Olivia, can you please review the latest design when you can?",
          sender: widget.currentUser,
          receiver: widget.chatPartner,
          avatar: Assets.imagesCitiImg,
          timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        ),
        MessageModel(
          text: "Sure Phoenix! I'll review it now.",
          sender: widget.currentUser,
          receiver: widget.chatPartner,
          avatar: Assets.imagesCitiImg,
          timestamp: DateTime.now().subtract(Duration(minutes: 8)),
        ),
      ]);
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = MessageModel(
      text: _messageController.text.trim(),
      sender: widget.currentUser,
      receiver: widget.chatPartner,
      timestamp: DateTime.now(),
      avatar: Assets.imagesCitiImg,
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageWidget(
                  message: _messages[index],
                  currentUser: widget.currentUser,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: InputField(
                    hint: "Type a message...",
                    radius: 100,
                      maxLines: 3,
                      lines: 1,
                    controller: _messageController,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
