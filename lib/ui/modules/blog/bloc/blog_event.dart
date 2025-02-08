import 'dart:io';
import 'dart:typed_data';

import 'package:reentry/data/model/request_blog_dto.dart';

class CreateBlogEvent extends BlogEvent {
  final Uint8List? file;
  String? blogId;
  String title;
  final String? url;
  final String category;
  final List<Map<String,dynamic>> content;

  CreateBlogEvent(
      {required this.title, this.file,this.url, required this.content,this.blogId,required this.category});
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
