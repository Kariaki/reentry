import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/blog/blog_repository.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_event.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc() : super(BlogInitial()) {
    on<CreateBlogEvent>(_createBlog);
  }

  final _repo = BlogRepository();

  Future<void> _createBlog(
      CreateBlogEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    try {
      final result = await _repo.createBlog(event);
      emit(CreateBlogContentSuccess());
    } catch (e) {
      emit(BlogError(e.toString()));
    }
  }
}
