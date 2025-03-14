import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/repository/appointment/appointment_repository_interface.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
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
      final data =
          NewAppointmentDto.fromJson(appointment.data()!, payload.creatorId)
              .copyWith(status: AppointmentStatus.canceled);
      print(data.toJson());
      await doc.set(data.toJson());
    } else {
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

  Future<Stream<List<NewAppointmentDto>>> getUserAppointmentInvitations(
      String userId) async {
    final docs = collection
        .where(NewAppointmentDto.keyAttendees, arrayContains: userId)
        .where(NewAppointmentDto.keyState, isEqualTo: EventState.pending.name)
        .where(NewAppointmentDto.keyStatus,
            isNotEqualTo: AppointmentStatus.canceled.name)
        .where(NewAppointmentDto.keyDate,
            isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        // .where(NewAppointmentDto.keyCreatorId, isNotEqualTo: userId)
        .orderBy(NewAppointmentDto.keyDate, descending: false);
    return docs.snapshots().map((e) {
      return e.docs
          .map((element) => NewAppointmentDto.fromJson(element.data(), userId))
          .toList();
    });
  }

  Future<Stream<List<NewAppointmentDto>>> getUserAppointmentHistory(
      String userId) async {
    final docs = collection
        .where(NewAppointmentDto.keyAttendees, arrayContains: userId)
        // .where(NewAppointmentDto.keyState,
        //     isNotEqualTo: EventState.pending.name)
        .orderBy(NewAppointmentDto.keyDate, descending: true);
    return docs.snapshots().map((e) {
      return e.docs.map((element) {
        final result = NewAppointmentDto.fromJson(element.data(), userId);
        print('kariakiPrint -> ${result.state.name}');
        return result;
      }).toList();
    });
  }  Future<List<NewAppointmentDto>> getUserAppointmentHistoryFuture(
      String userId) async {
    final docs = collection
        .where(NewAppointmentDto.keyAttendees, arrayContains: userId)
        // .where(NewAppointmentDto.keyState,
        //     isNotEqualTo: EventState.pending.name)
        .orderBy(NewAppointmentDto.keyDate, descending: true);
    final result = await  docs.get();
 return   result.docs.map((element) {
      final result = NewAppointmentDto.fromJson(element.data(), userId);
      print('kariakiPrint -> ${result.state.name}');
      return result;
    }).toList();
  }

  Future<List<NewAppointmentDto>> getAppointments({String? userId}) async {
    QuerySnapshot<Map<String, dynamic>> docs;
    if (userId == null) {
      docs = await collection.get();
    } else {
      final user = await UserRepository().getUserById(userId);
      if (user?.accountType == AccountType.reentry_orgs) {
        docs = await collection
            .where(AppointmentDto.keyOrgs, arrayContains: userId)
            .get();
      } else {
        docs = await collection
            .where(AppointmentDto.keyAttendees, arrayContains: userId)
            .get();
      }
    }

    final appointmentDocs = docs.docs.toList();
    final appointments = appointmentDocs
        .map((e) => NewAppointmentDto.fromJson(e.data(), userId ?? ''))
        .toList();
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
