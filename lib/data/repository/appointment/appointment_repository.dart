import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/appointment/appointment_repository_interface.dart';
import 'package:reentry/data/shared/share_preference.dart';

import '../../../ui/modules/appointment/bloc/appointment_event.dart';

class AppointmentRepository extends AppointmentRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("appointment");
  final _userCollection = FirebaseFirestore.instance.collection('user');

  @override
  Future<AppointmentDto> createAppointment(
      CreateAppointmentEvent payload) async {
    final user = await PersistentStorage.getCurrentUser();
    final doc = collection.doc();
    AppointmentDto appointmentPayload = payload.toAppointmentDto();
    appointmentPayload = appointmentPayload.copyWith(
        attendees: [...appointmentPayload.attendees, user?.userId ?? ''],
        id: doc.id);
    await doc.set(appointmentPayload.toJson());

    return appointmentPayload;
  }

  @override
  Future<void> deleteAppointment(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<List<AppointmentEntityDto>> getUserAppointments() async {
    final user = await PersistentStorage.getCurrentUser();
    final docs = await collection
        .where(AppointmentDto.keyAttendees, arrayContains: user?.userId ?? '')
        .get();
    final appointmentDocs = docs.docs.toList();
    Map<String, AppointmentDto> appointmentMap = {};
    for (var i in appointmentDocs) {
      final map = i.data();
      final result1 = AppointmentDto.fromJson(map);
      final aliasId =
          result1.attendees.where((e) => e != user?.userId).firstOrNull;
      if (aliasId == null) {
        continue;
      }
      //print("ebilate ${aliasIds.length}");
      appointmentMap[aliasId] = result1;
    }
    final aliasIds = appointmentMap.keys;

    final userDocs =
        await _userCollection.where(UserDto.keyUserId, whereIn: aliasIds).get();
    Map<String, UserDto> userMaps = {};
    for (var i in userDocs.docs) {
      final map = i.data();
      final _user = UserDto.fromJson(map);
      userMaps[_user.userId ?? ''] = _user;
    }
    List<AppointmentEntityDto> result = [];
    final appointments =
        appointmentDocs.map((e) => AppointmentDto.fromJson(e.data())).toList();
    for (var map in appointments) {
      final aliasId = map.attendees.where((e) => e != user?.userId).firstOrNull;
      if (aliasId == null) {
        continue;
      }
      final aliasUser = userMaps[aliasId];
      if (aliasUser == null) {
        continue;
      }
      final appointment = AppointmentEntityDto(
          userId: aliasUser.userId ?? '',
          time: DateTime.fromMillisecondsSinceEpoch(map.time),
          name: aliasUser.name,
          accountType: aliasUser.accountType.name,
          id: map.id,
          note: map.note,
          avatar: aliasUser.avatar ?? 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541');
      result.add(appointment);
    }
    return result;
  }

  @override
  Future<AppointmentDto> updateAppointment(AppointmentDto payload) async {
    await collection.doc(payload.id).set(payload.toJson());
    return payload;
  }
}
