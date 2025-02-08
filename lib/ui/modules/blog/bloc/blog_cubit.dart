import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/data/repository/blog/blog_repository.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';

class BlogCubit extends Cubit<BlogCubitState> {
  BlogCubit() : super(BlogCubitState.init());

  Future<void> fetchBlogs() async {
    try {
      emit(state.loading());
      final result = await BlogRepository().getBlogs();
      emit(state.success(data: result, complete: result));
    } catch (e, trace) {
      debugPrintStack(stackTrace: trace);
      emit(state.error(e.toString()));
    }
  }

  void selectBlog(BlogDto? blog) {
    emit(state.success(currentBlog: blog));
  }

  void search(String query) {
    emit(state.success(
        data: state.complete
            .where((e) =>
                e.title.toLowerCase().contains(query.toLowerCase()) ||
                (e.category?.toLowerCase().contains(query.toLowerCase()) ??
                    false))
            .toList()));
  }

  void deleteBlog(BlogDto blog) async {
    try {
      emit(state.loading());
      await BlogRepository().deleteBlog(blog.id ?? '');
      final result = await BlogRepository().getBlogs();
      emit(state.success(data: result, complete: result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  void editBlog(BlogDto blog) async {
    try {
      emit(state.loading());
      await BlogRepository().updateBlog(blog);
      final result = await BlogRepository().getBlogs();
      emit(state.success(data: result, complete: result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}
