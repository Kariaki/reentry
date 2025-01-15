import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/incidence_dto.dart';
import 'package:reentry/data/repository/report/report_repository_interface.dart';

class ReportRepository extends ReportRepositoryInterface {
  final incidenceCollection =
      FirebaseFirestore.instance.collection("incidence");

  @override
  Future<List<IncidenceResponse>> getIncidenceResponse(String reportId) async {
    final document = incidenceCollection.doc(reportId).collection("response");
    final result = await document.get();
    return result.docs
        .map((e) => IncidenceResponse.fromJson(e.data()))
        .toList();
  }

  @override
  Future<List<IncidenceDto>> getReports() async {
    final result = await incidenceCollection.get();
    return result.docs.map((e) => IncidenceDto.fromJson(e.data())).toList();
  }

  @override
  Future<void> reportUser(IncidenceDto report) async {
    final document = incidenceCollection.doc();
    await document.set(report.toJson(document.id));
  }

  @override
  Future<void> submitResponse(
      String reportId, IncidenceResponse response) async {
    final document = incidenceCollection.doc(reportId).collection("response");
    var documentSnapshot = incidenceCollection.doc(reportId);
    final reportDataSnapshot = await documentSnapshot.get();
    final reportJson = reportDataSnapshot.data();
    var report = IncidenceDto.fromJson(reportJson!);
    report = report.copyWith(responseCount: report.responseCount + 1);
    await documentSnapshot.set(report.toJson(report.id));
    await document.doc().set(response.toJson());
  }
}
