import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/data/repository/blog/blog_repository_interface.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_event.dart';

import '../../../exception/app_exceptions.dart';
Future<String> uploadFile(Uint8List file) async {
  // Create a Reference to the file
  try {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('flutter-tests')
        .child('/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final result = await ref.putData(file);
    if (result.state == TaskState.success) {
      final url = await ref.getDownloadURL();
      return url;
    }
    throw BaseExceptions('Something went wrong');
  } catch (e) {
    throw BaseExceptions(e.toString());
  }
}
class BlogRepository extends BlogRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("blog");
  final blogRequest = FirebaseFirestore.instance.collection("blogRequest");



  @override
  Future<BlogDto> createBlog(CreateBlogEvent body) async {
    String? url;

    if (body.file != null) {
      url = await uploadFile(body.file!);
    } else {
      url = null;
    }
    final doc = collection.doc(body.blogId);

    final bodyData = BlogDto(
        title: body.title,
        content: body.content,
        category: body.category,
        imageUrl: url ?? body.url,
        id: body.blogId ?? doc.id);

    await doc.set(bodyData.toJson());
    print('kariaki -> blog created => ${bodyData.toJson()}');
    return bodyData;
  }

  Future<void> requestBloc(RequestBlogEvent event) async {
    final doc = blogRequest.doc();
    await doc.set(event.toDto().toJson(doc.id));
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    await collection.doc(blogId).delete();
  }

  @override
  Future<List<BlogDto>> getBlogs() async {
    final response = await collection.get();
    return response.docs.map((e) => BlogDto.fromJson(e.data())).toList();
  }

  @override
  Future<void> updateBlog(BlogDto blog) async {
    final doc = collection.doc(blog.id);
    await doc.set(blog.toJson());
  }
}
