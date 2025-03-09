import 'package:reentry/data/model/incidence_dto.dart';

abstract class ReportRepositoryInterface{
  Future<void> reportUser(IncidenceDto report);
  Future<List<IncidenceDto>> getReports();
  Future<List<IncidenceResponse>> getIncidenceResponse(String reportId);
  Future<void> submitResponse(String reportId,String response);

}