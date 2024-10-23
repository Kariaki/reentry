import 'package:reentry/data/model/report_dto.dart';
import 'package:reentry/data/model/support_ticket.dart';

class UtilityEvent {}

class ReportUserEvent extends UtilityEvent {
  final String reportedUserId;
  final String issue;

  ReportUserEvent({required this.reportedUserId, required this.issue});

  ReportDto toReportDto() {
    return ReportDto(issue: issue, userId: '', reportedUserId: reportedUserId);
  }
}

class SupportTicketEvent extends UtilityEvent {

  final String title;
  final String description;
  SupportTicketEvent({required this.description,required this.title});
  SupportTicketDto ticketDto(){
    return SupportTicketDto(title: title, description: description);
  }
}
