import '../../../../data/model/mentor_request.dart';

class MentorState {}

class MentorStateInitial extends MentorState {}

class MentorStateLoading extends MentorState {}

class MentorStateError extends MentorState {
  String message;

  MentorStateError(this.message);
}

class MentorStateSuccess extends MentorState {
  MentorRequest data;

  MentorStateSuccess(this.data);
}
