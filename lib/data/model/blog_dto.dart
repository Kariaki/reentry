class BlogDto {
  final String title;
  final String content;
  final String? imageUrl;
  final String? url;
  final String? id;
  final String? userId;

  const BlogDto(
      {required this.title,
      required this.content,
      this.imageUrl,
      this.url,
      this.userId,
      this.id});

  factory BlogDto.fromJson(Map<String, dynamic> json) {
    return BlogDto(
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      url: json['url'] as String?,
      id: json['id'] as String?,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'url': url,
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
    };
  }
}
