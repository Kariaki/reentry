import 'package:reentry/data/model/incidence_dto.dart';
import 'package:reentry/data/model/report_dto.dart';
import 'package:reentry/data/model/support_ticket.dart';

class UtilityEvent {}

class ReportUserEvent extends UtilityEvent {

  final IncidenceDto data;

  ReportUserEvent(this.data);

}

class SupportTicketEvent extends UtilityEvent {

  final String title;
  final String description;
  SupportTicketEvent({required this.description,required this.title});
  SupportTicketDto ticketDto(){
    return SupportTicketDto(title: title, description: description);
  }
}
