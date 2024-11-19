import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/data/repository/blog/blog_repository_interface.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_event.dart';

class BlogRepository extends BlogRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("blog");

  @override
  Future<void> createBlog(CreateBlogEvent body) async {
    String? url;
    if (body.file != null) {
      final userRepo = UserRepository();
      url = await userRepo.uploadFile(body.file!);
    }
    final doc = collection.doc();
    final bodyData = BlogDto(
        title: body.title, content: body.content, imageUrl: url, id: doc.id);
    await doc.set(bodyData.toJson());
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    await collection.doc(blogId).delete();
  }

  @override
  Future<List<BlogDto>> getBlocs() async {
    final response = await collection.get();
    return response.docs.map((e) => BlogDto.fromJson(e.data())).toList();
  }

  @override
  Future<void> updateBlog(BlogDto blog) async {
    final doc = collection.doc(blog.id);
    await doc.set(blog.toJson());
  }
}
