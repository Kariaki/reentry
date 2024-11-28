import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';

class MessageModel {
  final String text;
  final UserDto sender;
  final ClientDto receiver;
  final String avatar;
  final DateTime timestamp;
  final DateTime date; 

  MessageModel({
    required this.text,
    required this.sender,
    required this.receiver,
    required this.avatar,
    required this.timestamp,
  }) : date = DateTime(timestamp.year, timestamp.month, timestamp.day);  
}
