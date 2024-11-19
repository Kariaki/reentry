class BlogDto {
  final String title;
  final String content;
  final String? imageUrl;
  final String? url;
  final String? id;
  final String? authorName;
  final String? dateCreated;
  final String? userId;

  const BlogDto(
      {required this.title,
      required this.content,
      this.imageUrl,
      this.authorName,
      this.dateCreated,
      this.url,
      this.userId,
      this.id});

  factory BlogDto.fromJson(Map<String, dynamic> json) {
    return BlogDto(
      title: json['title'] as String,
      content: json['content'] as String,
      dateCreated:
          (DateTime.tryParse((json['date'] as String?) ?? '') ?? DateTime.now())
              .toIso8601String(),
      imageUrl: json['imageUrl'] as String?,
      url: json['url'] as String?,
      id: json['id'] as String?,
      authorName: json['authorName'] as String?,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson({DateTime? date}) {
    return {
      'title': title,
      'content': content,
      'date': date?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'authorName': authorName,
      'url': url,
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
    };
  }
}
