// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'message_model.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;
  final UserDto currentUser;

  ChatMessageWidget({required this.message, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sender.userId == currentUser.userId;
    final screenWidth = MediaQuery.of(context).size.width;
    final DateFormat dateFormat = DateFormat('MMM dd');
    final String formattedDate = dateFormat.format(message.timestamp);
    final String formattedTime =
        "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(message.avatar),
            ),
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    // maxWidth: screenWidth / 3,
                    maxWidth: 500,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "$formattedDate| $formattedTime",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.hintColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            message.sender.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.hintColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isMe ? AppColors.hintColor : AppColors.greyWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(8),
                            topRight: const Radius.circular(8),
                            bottomLeft:
                                isMe ? const Radius.circular(8) : Radius.zero,
                            bottomRight:
                                isMe ? Radius.zero : const Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          message.text,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isMe ? AppColors.greyWhite : AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe)
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(message.avatar),
            ),
        ],
      ),
    );
  }
}
