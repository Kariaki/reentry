import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_event.dart';

abstract class BlogRepositoryInterface{
  Future<void> createBlog(CreateBlogEvent body);
  Future<void> deleteBlog(String blogId);
  Future<List<BlogDto>> getBlogs();
  Future<void> updateBlog(BlogDto blog);
}