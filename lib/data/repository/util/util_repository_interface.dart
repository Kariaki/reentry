import 'package:reentry/data/model/report_dto.dart';
import 'package:reentry/data/model/support_ticket.dart';

abstract class UtilityRepositoryInterface {
  Future<void> reportAnIssue(ReportDto data);

  Future<void> supportTicket(SupportTicketDto data);
}
