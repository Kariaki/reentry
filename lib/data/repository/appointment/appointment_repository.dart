import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/appointment/appointment_repository_interface.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/exception/app_exceptions.dart';
import '../../../ui/modules/appointment/bloc/appointment_event.dart';

class AppointmentRepository extends AppointmentRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("appointment");
  final _userCollection = FirebaseFirestore.instance.collection('user');

  Future<void> cancelAppointment(String id) async {
    final doc = collection.doc(id);
    final appointment = await doc.get();
    if (appointment.exists) {
      final data = AppointmentDto.fromJson(appointment.data()!)
          .copyWith(status: AppointmentStatus.canceled);
      await doc.set(data.toJson());
    }
  }

  Future<void> updateAppointmentStatus(
      AppointmentStatus status, String id) async {}

  @override
  Future<AppointmentDto> createAppointment(
      CreateAppointmentEvent payload) async {
    //verify if selected day have been taken
    final bookedDay = payload.bookedDay;
    final bookedTime = payload.bookedTime;
    final appointmentsResult = await getAppointmentByUserId(
        payload.userId); //fetch upcoming appointments
    final filteredAppointments = appointmentsResult.where((e) =>
        DateTime.fromMillisecondsSinceEpoch(e.time)
            .isAfter(DateTime.now())); //filter by date time
    final booked = filteredAppointments.where((e) {
      return e.bookedDay == bookedDay && e.bookedTime == bookedTime;
    }).isNotEmpty;
    if (booked) {
      throw BaseExceptions('Select date and time have been booked');
    }

    final user = await PersistentStorage.getCurrentUser();
    final doc = collection.doc(payload.id);
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
      appointmentMap[aliasId] = result1;
    }
    final aliasIds = appointmentMap.keys;

    if (aliasIds.isEmpty) {
      return [];
    }
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
          bookedTime: map.bookedTime ?? '9:00 AM',
          bookedDay: map.bookedDay ?? 0,
          status: map.status,
          id: map.id,
          note: map.note,
          avatar: aliasUser.avatar ?? AppConstants.avatar);
      result.add(appointment);
    }
    return result;
  }

  @override
  Future<List<AppointmentDto>> getAppointmentByUserId(String userId) async {
    final user = await PersistentStorage.getCurrentUser();
    final docs = await collection
        .where(AppointmentDto.keyAttendees, arrayContains: user?.userId ?? '')
        .where(AppointmentDto.keyStatus,
            isEqualTo: AppointmentStatus.upcoming.name)
        .get();

    return docs.docs.map((e) {
      return AppointmentDto.fromJson(e.data());
    }).toList();
  }

  @override
  Future<AppointmentDto> updateAppointment(AppointmentDto payload) async {
    await collection.doc(payload.id).set(payload.toJson());
    return payload;
  }
}
