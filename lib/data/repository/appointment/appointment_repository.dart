import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/repository/appointment/appointment_repository_interface.dart';
import 'package:reentry/data/shared/share_preference.dart';
import '../../../ui/modules/appointment/bloc/appointment_event.dart';

class AppointmentRepository extends AppointmentRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("appointment");
  final _userCollection = FirebaseFirestore.instance.collection('user');

  Future<void> cancelAppointment(NewAppointmentDto payload) async {
    final doc = collection.doc(payload.id);
    print(payload.id);
    final appointment = await doc.get();
    if (appointment.exists) {
      final data = NewAppointmentDto.fromJson(appointment.data()!)
          .copyWith(status: AppointmentStatus.canceled);
      print(data.toJson());
      await doc.set(data.toJson());
    }else{
      print('data not exist');
    }
  }

  Future<void> updateAppointmentStatus(
      AppointmentStatus status, String id) async {}

  @override
  Future<NewAppointmentDto> createAppointment(
      CreateAppointmentEvent payload) async {
    final doc = collection.doc(payload.data.id);
    await doc.set(payload.data.copyWith(id: doc.id).toJson());
    return payload.data;
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
    return [];
  }

  Future<Stream<List<NewAppointmentDto>>> getCurrentUserAppointments(
      String userId) async {
    final docs = await collection.where(NewAppointmentDto.keyAttendees,
        arrayContains: userId);
    return docs.snapshots().map((e) {
      return e.docs
          .map((element) => NewAppointmentDto.fromJson(element.data())).toList();
    });
  }

  Future<List<AppointmentDto>> getAppointments({String? userId}) async {
    QuerySnapshot<Map<String, dynamic>> docs;
    if (userId == null) {
      docs = await collection.get();
    } else {
      docs = await collection
          .where(AppointmentDto.keyAttendees, arrayContains: userId ?? '')
          .get();
    }
    final appointmentDocs = docs.docs.toList();
    final appointments =
        appointmentDocs.map((e) => AppointmentDto.fromJson(e.data())).toList();
    return appointments;
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
  Future<NewAppointmentDto> updateAppointment(NewAppointmentDto payload) async {
    await collection.doc(payload.id).set(payload.toJson());
    return payload;
  }
}
