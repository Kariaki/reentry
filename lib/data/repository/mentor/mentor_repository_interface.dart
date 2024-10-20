import '../../model/mentor_request.dart';

abstract class MentorRepositoryInterface {

  Future<MentorRequest> requestMentor(MentorRequest data);
}