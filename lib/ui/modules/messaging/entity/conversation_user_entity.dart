class ConversationUserEntity{
  final String userId;
  final String name;
  final String? avatar;

  const ConversationUserEntity(
      {required this.userId, this.avatar, required this.name});
}
