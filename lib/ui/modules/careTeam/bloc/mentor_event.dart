import '../../../../data/model/mentor_request.dart';

class MentorEvent{}
class RequestMentorEvent extends MentorEvent{

  MentorRequest data;
  RequestMentorEvent(this.data);
}
