import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

sealed class BlogState {}

class BlogLoading extends BlogState {}

class BlogInitial extends BlogState {}

class BlogError extends BlogState {
  final String error;

  BlogError(this.error);
}
class RequestBlogSuccess extends BlogState{

}
class CreateBlogContentSuccess extends BlogState {}

class UpdateBlogSuccess extends BlogState {
  BlogDto blog;
  UpdateBlogSuccess(this.blog);
}

class BlogCubitState {
  final CubitState state;
  final List<BlogDto> data;
  final List<BlogDto> complete;
  final BlogDto? currentBlog;

  BlogCubitState({this.data = const [],this.complete = const [], required this.state, this.currentBlog});

  static BlogCubitState init() => BlogCubitState(
        state: CubitState(),
      );

  BlogCubitState loading() =>
      BlogCubitState(state: CubitStateLoading(), data: data, currentBlog: currentBlog);

  BlogCubitState success({List<BlogDto>? complete,List<BlogDto>? data, BlogDto? currentBlog}) =>
      BlogCubitState(
          data: data ?? this.data,
          complete: complete??this.complete,
          state: CubitStateSuccess(),
          currentBlog: currentBlog ?? this.currentBlog);

  BlogCubitState error(String error) => BlogCubitState(
      state: CubitStateError(error), data: data, currentBlog: currentBlog);

  bool get isLoading => state is CubitStateLoading;

  bool get isSuccess => state is CubitStateSuccess;

  bool get isError => state is CubitStateError;

  String get errorMessage =>
      state is CubitStateError ? (state as CubitStateError).message : '';
}
