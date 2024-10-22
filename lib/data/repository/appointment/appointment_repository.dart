import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/repository/appointment/appointment_repository_interface.dart';

import '../../../ui/modules/appointment/bloc/appointment_event.dart';

class AppointmentRepository extends AppointmentRepositoryInterface {
  final collection = FirebaseFirestore.instance.collection("appointment");

  @override
  Future<AppointmentDto> createAppointment(
      CreateAppointmentEvent payload) async {
    // TODO: implement createAppointment
    throw Exception('not implemented');
  }

  @override
  Future<void> deleteAppointment(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<List<AppointmentDto>> getUserAppointments() async {
    final docs = await collection.get();
    final result =
        docs.docs.map((element) => AppointmentDto.fromJson(element.data()));
    return result.toList();
  }

  @override
  Future<AppointmentDto> updateAppointment(AppointmentDto payload) async {
    await collection.doc(payload.id).set(payload.toJson());
    return payload;
  }
}
