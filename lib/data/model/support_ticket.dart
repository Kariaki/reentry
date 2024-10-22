class SupportTicketDto {
  final String? id;
  final String title;
  final String description;

  const SupportTicketDto(
      {required this.title, required this.description, this.id});

  SupportTicketDto copyWithId(String id) =>
      SupportTicketDto(title: title, description: description, id: id);

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        'createdAt': DateTime.now().toIso8601String()
      };
}
