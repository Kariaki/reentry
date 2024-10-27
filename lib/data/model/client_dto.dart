import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';
import '../../ui/modules/appointment/appointment_calender_screen.dart';

enum ClientStatus { pending, active, dropped, decline }

class ClientDto {
  final String id;
  final String name;
  final String avatar;
  final int createdAt;
  final int updatedAt;
  final String? email;
  final String? reasonForRequest;
  final String? whatYouNeedInAMentor;
  final List<String> assignees;
  final String? droppedReason;
  final String? clientId;
  final ClientStatus status;

  static const assigneesKey = 'assignees';
  static const statusKey = 'status';

  ClientDto({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    this.reasonForRequest,
    this.whatYouNeedInAMentor,
    this.email,
    required this.createdAt,
    required this.updatedAt,
    this.assignees = const [],
    this.droppedReason,
    this.clientId,
  });

  ConversationUserEntity toConversationUserEntity(){
    return ConversationUserEntity(userId: id, name: name,avatar: avatar);
  }
  // copyWith method
  ClientDto copyWith({
    String? id,
    String? name,
    String? avatar,
    int? createdAt,
    String? email,
    String? whatYouNeedInAMentor,
    String? reasonForRequest,
    ClientStatus? status,
    int? updatedAt,
    List<String>? assignees,
    String? droppedReason,
    String? clientId,
  }) {
    return ClientDto(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      whatYouNeedInAMentor: whatYouNeedInAMentor ?? this.whatYouNeedInAMentor,
      reasonForRequest: reasonForRequest ?? this.whatYouNeedInAMentor,
      email: email ?? this.email,
      updatedAt: updatedAt ?? this.updatedAt,
      assignees: assignees ?? this.assignees,
      droppedReason: droppedReason ?? this.droppedReason,
      clientId: clientId ?? this.clientId,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'assignees': assignees,
      'email': email,
      'reasonForRequest': reasonForRequest,
      'whatYouNeedInAMentor': whatYouNeedInAMentor,
      'droppedReason': droppedReason,
      'status': status.index,
      'clientId': clientId,
    };
  }

  AppointmentUserDto toAppointmentUserDto(){
    return AppointmentUserDto(userId: id, name: name, avatar: avatar??'');
  }
  // fromJson method
  factory ClientDto.fromJson(Map<String, dynamic> json) {
    return ClientDto(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      status: ClientStatus.values[(json['status'] as int?) ?? 0],
      createdAt: (json['createdAt']),
      updatedAt: (json['updatedAt']),
      assignees: (json['assignees'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      droppedReason: json['droppedReason'],
      clientId: json['clientId'],
      email: json['email'],
      reasonForRequest: json['reasonForRequest'],
      whatYouNeedInAMentor: json['whatYouNeedInAMentor'],
    );
  }
}
