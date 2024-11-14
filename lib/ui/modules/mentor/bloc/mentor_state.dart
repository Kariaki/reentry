import 'package:reentry/data/model/user_dto.dart';

import '../../../../data/model/mentor_request.dart';

class MentorState {}

class MentorStateInitial extends MentorState {}

class MentorStateLoading extends MentorState {}

class MentorStateError extends MentorState {
  String message;

  MentorStateError(this.message);
}

class MentorLoaded extends MentorState {
  final UserDto mentor;

  MentorLoaded(this.mentor);
}

class MentorStateSuccess extends MentorState {
  MentorRequest data;

  MentorStateSuccess(this.data);
}
