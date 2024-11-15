import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/blog/blog_repository.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';

class BlogCubit extends Cubit<BlogCubitState> {
  BlogCubit() : super(BlogCubitState.init());

  Future<void> fetchBlogs() async {
    try {
      state.loading();
      final result = await BlogRepository().getBlocs();
      emit(state.success(data: result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}
