import 'dart:io';

import 'package:reentry/data/model/request_blog_dto.dart';

class CreateBlogEvent extends BlogEvent {
  final File? file;
  String title;
  final String content;
  final String? link;

  CreateBlogEvent(
      {required this.title, required this.content, this.file, this.link});
}

class RequestBlogEvent extends BlogEvent {
  final String title;
  final String userId;
  final String email;
  final String details;

  RequestBlogEvent(
      {required this.userId,
      required this.title,
      required this.email,
      required this.details});
  RequestBlogDto toDto(){
    return RequestBlogDto(title: title, details: details, email: email, userId: userId);
  }
}

sealed class BlogEvent {}
