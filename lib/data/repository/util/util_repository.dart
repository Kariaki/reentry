import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/report_dto.dart';
import 'package:reentry/data/model/support_ticket.dart';
import 'package:reentry/data/repository/util/util_repository_interface.dart';
import 'package:reentry/exception/app_exceptions.dart';

class UtilRepository implements UtilityRepositoryInterface {
  final reportCollection = FirebaseFirestore.instance.collection("report");
  final supportCollection = FirebaseFirestore.instance.collection("support");

  @override
  Future<void> reportAnIssue(ReportDto data) async {
    try {
      final doc = reportCollection.doc();
      final payload = data.copyWithId(doc.id);
      await doc.set(payload.toJson());
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }

  @override
  Future<void> supportTicket(SupportTicketDto data) async {
    try {
      final doc = reportCollection.doc();
      final payload = data.copyWithId(doc.id);
      await doc.set(payload.toJson());
    } catch (e) {
      throw BaseExceptions(e.toString());
    }
  }
}
