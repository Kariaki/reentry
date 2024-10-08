class MentorRequest {
  final String userId;
  final String id;
  final String reasonForRequest;
  final String whatYouNeedInAMentor;

  MentorRequest({
    required this.userId,
    required this.id,
    required this.reasonForRequest,
    required this.whatYouNeedInAMentor,
  });

  // copyWith method
  MentorRequest copyWith({
    String? userId,
    String? id,
    String? reasonForRequest,
    String? whatYouNeedInAMentor,
  }) {
    return MentorRequest(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      reasonForRequest: reasonForRequest ?? this.reasonForRequest,
      whatYouNeedInAMentor: whatYouNeedInAMentor ?? this.whatYouNeedInAMentor,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'reasonForRequest': reasonForRequest,
      'whatYouNeedInAMentor': whatYouNeedInAMentor,
    };
  }

  // fromJson method
  factory MentorRequest.fromJson(Map<String, dynamic> json) {
    return MentorRequest(
      userId: json['userId'],
      id: json['id'],
      reasonForRequest: json['reasonForRequest'],
      whatYouNeedInAMentor: json['whatYouNeedInAMentor'],
    );
  }
}
