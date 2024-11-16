
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';

class MessageSnackbar extends StatelessWidget {
  final String avatar;
  final String message;
  final int timestamp;

  const MessageSnackbar(
      {super.key,
        required this.message,
        required this.timestamp,
        required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: .2,
              blurRadius: 3,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: CircleAvatar(
              backgroundImage: NetworkImage(avatar),
            ),
          ),
          10.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                 const  Text(
                    'New message',
                    maxLines: 2,
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  10.height,
                  Text('just now',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xB21A1A1A).withOpacity(.85),
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              5.height,
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 250,
                ),
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xB21A1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}