import 'package:reentry/data/model/client_dto.dart';

class MentorRequest {
  final String? userId;
  final String? id;
  final String reasonForRequest;
  final String whatYouNeedInAMentor;
  final String email;
  final String name;
  final String avatar;

  MentorRequest({
    this.userId,
    this.id,
    required this.email,
    required this.name,
    required this.reasonForRequest,
    required this.avatar,
    required this.whatYouNeedInAMentor,
  });

  ClientDto toClient() {
    return ClientDto(id:userId??'',
        name: name,
        avatar: avatar,
        status: ClientStatus.pending,
        reasonForRequest:reasonForRequest ,
        whatYouNeedInAMentor: whatYouNeedInAMentor,
        email: email,
        clientId: userId,
        createdAt: DateTime
            .now()
            .millisecondsSinceEpoch,
        updatedAt: DateTime
            .now()
            .millisecondsSinceEpoch);
  }

  // copyWith method
  MentorRequest copyWith({String? userId,
    String? id,
    String? reasonForRequest,
    String? whatYouNeedInAMentor,
    String? name,
    String? avatar,
    String? email}) {
    return MentorRequest(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar??this.avatar,
      id: id ?? this.id,
      reasonForRequest: reasonForRequest ?? this.reasonForRequest,
      whatYouNeedInAMentor: whatYouNeedInAMentor ?? this.whatYouNeedInAMentor,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'id': id,
      'email': email,
      'reasonForRequest': reasonForRequest,
      'whatYouNeedInAMentor': whatYouNeedInAMentor,
    };
  }

  // fromJson method
  factory MentorRequest.fromJson(Map<String, dynamic> json) {
    return MentorRequest(
      userId: json['userId'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      id: json['id'],
      reasonForRequest: json['reasonForRequest'],
      whatYouNeedInAMentor: json['whatYouNeedInAMentor'],
    );
  }
}
