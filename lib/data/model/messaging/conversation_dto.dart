class ConversationDto {
  final String lastMessage;
  final int timestamp;
  final String id;
  final List<String> members;
  static const keyMembers = 'members';
  static const keyTimestamp = 'timestamp';

  const ConversationDto(
      {required this.lastMessage,
      required this.members,
      required this.id,
      required this.timestamp});

  Map<String, dynamic> toJson() => {
        'lastMessage': lastMessage,
        'timestamp': timestamp,
        'id': id,
        'members': members,
      };

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    return ConversationDto(
        lastMessage: json['lastMessage'],
        id: json['id'],
        members: (json[keyMembers] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        timestamp: json[keyTimestamp]);
  }
}
