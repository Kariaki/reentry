class RequestBlogDto {
  final String? id;
  final String title;
  final String details;
  final String email;
  final String userId;

  const RequestBlogDto(
      {required this.title,
      required this.details,
      required this.email,
      required this.userId,
      this.id});

  Map<String, dynamic> toJson(String id) {
    return {
      'id': id,
      'title': title,
      'details': details,
      'email': email,
      'userId': userId
    };
  }
}
