import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

sealed class BlogState {}

class BlogLoading extends BlogState {}
class BlogInitial extends BlogState {}

class BlogError extends BlogState {
  final String error;

  BlogError(this.error);
}

class CreateBlogContentSuccess extends BlogState {}

class BlogCubitState {
  final CubitState state;
  final List<BlogDto> data;

  BlogCubitState({this.data = const [], required this.state});

  static BlogCubitState init() => BlogCubitState(
        state: CubitState(),
      );

  BlogCubitState loading() => BlogCubitState(
        state: CubitStateLoading(),
      );

  BlogCubitState success({List<BlogDto>? data}) =>
      BlogCubitState(data: data ?? this.data, state: CubitStateSuccess());

  BlogCubitState error(String error) =>
      BlogCubitState(state: CubitStateError(error));
}
