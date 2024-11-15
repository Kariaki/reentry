import 'dart:io';

class CreateBlogEvent extends BlogEvent {
  final File? file;
  String title;
  final String content;
  final String? link;

  CreateBlogEvent(
      {required this.title, required this.content, this.file, this.link});
}

sealed class BlogEvent {}
