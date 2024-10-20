class MentorRequest {
  final String? userId;
  final String? id;
  final String reasonForRequest;
  final String whatYouNeedInAMentor;
  final String email;

  MentorRequest({
    this.userId,
    this.id,
    required this.email,
    required this.reasonForRequest,
    required this.whatYouNeedInAMentor,
  });

  // copyWith method
  MentorRequest copyWith(
      {String? userId,
      String? id,
      String? reasonForRequest,
      String? whatYouNeedInAMentor,
      String? email}) {
    return MentorRequest(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      id: id ?? this.id,
      reasonForRequest: reasonForRequest ?? this.reasonForRequest,
      whatYouNeedInAMentor: whatYouNeedInAMentor ?? this.whatYouNeedInAMentor,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'id': id,
      'reasonForRequest': reasonForRequest,
      'whatYouNeedInAMentor': whatYouNeedInAMentor,
    };
  }

  // fromJson method
  factory MentorRequest.fromJson(Map<String, dynamic> json) {
    return MentorRequest(
      userId: json['userId'],
      email: json['email'],
      id: json['id'],
      reasonForRequest: json['reasonForRequest'],
      whatYouNeedInAMentor: json['whatYouNeedInAMentor'],
    );
  }
}
