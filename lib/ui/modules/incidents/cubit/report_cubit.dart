import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/incidence_dto.dart';
import 'package:reentry/data/repository/report/report_repository.dart';
import 'package:reentry/ui/modules/incidents/cubit/report_cubit_state.dart';

import '../../../../data/enum/account_type.dart';

class ReportCubit extends Cubit<ReportCubitState> {
  ReportCubit() : super(ReportCubitState.init());

  final _repository = ReportRepository();

  Future<void> fetchReports() async {
    try {
      emit(state.loading());
      //final result = await _repository.getReports();
      await Future.delayed(Duration(seconds: 4));
      emit(state.success(data: []));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }

  void select(IncidenceDto report){
    emit(state.success(selected: report));
  }
  Future<void> submitResponse(IncidenceResponse response) async {}

  Future<void> fetchResponses(String reportId) async {
    try {
      emit(state.loading());
      final result = await _repository.getIncidenceResponse(reportId);
      emit(state.success(responses: result));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}

List<IncidenceDto> dummyIncidences = [
  IncidenceDto(
    title: "Traffic Violation",
    description: "Reported a speeding vehicle in a school zone.",
    date: DateTime.now().subtract(Duration(days: 2)),
    id: "id_traffic_violation",
    responseCount: 5,
    reported: UsersInvolved(
      name: "Officer John Doe",
      userId: "officer_001",
      account: AccountType.officer,
    ),
    victim: UsersInvolved(
      name: "Jane Smith",
      userId: "citizen_001",
      account: AccountType.citizen,
    ),
  ),
  IncidenceDto(
    title: "Vandalism in Park",
    description: "Graffiti reported on public benches.",
    date: DateTime.now().subtract(Duration(days: 7)),
    id: "id_vandalism_park",
    responseCount: 3,
    reported: UsersInvolved(
      name: "Citizen Mark Lee",
      userId: "citizen_002",
      account: AccountType.citizen,
    ),
    victim: UsersInvolved(
      name: "City Council",
      userId: "organization_001",
      account: AccountType.mentor,
    ),
  ),
  IncidenceDto(
    title: "Robbery Incident",
    description: "Attempted mugging near the subway entrance.",
    date: DateTime.now().subtract(Duration(days: 1)),
    id: "id_robbery_incident",
    responseCount: 8,
    reported: UsersInvolved(
      name: "Officer Emily Davis",
      userId: "officer_002",
      account: AccountType.officer,
    ),
    victim: UsersInvolved(
      name: "Peter Parker",
      userId: "citizen_003",
      account: AccountType.citizen,
    ),
  ),
  IncidenceDto(
    title: "Noise Complaint",
    description: "Loud music reported in residential area.",
    date: DateTime.now().subtract(Duration(days: 10)),
    id: "id_noise_complaint",
    responseCount: 2,
    reported: UsersInvolved(
      name: "Citizen Anna Brown",
      userId: "citizen_004",
      account: AccountType.citizen,
    ),
    victim: UsersInvolved(
      name: "Local Residents",
      userId: "group_001",
      account: AccountType.mentor,
    ),
  ),
  IncidenceDto(
    title: "Missing Person",
    description: "Reported a missing child in the neighborhood.",
    date: DateTime.now().subtract(Duration(days: 4)),
    id: "id_missing_person",
    responseCount: 12,
    reported: UsersInvolved(
      name: "Officer Liam Wilson",
      userId: "officer_003",
      account: AccountType.officer,
    ),
    victim: UsersInvolved(
      name: "Family Johnson",
      userId: "family_001",
      account: AccountType.citizen,
    ),
  ),
  IncidenceDto(
    title: "Burglary Report",
    description: "Attempted break-in at a local convenience store.",
    date: DateTime.now().subtract(Duration(days: 6)),
    id: "id_burglary_report",
    responseCount: 7,
    reported: UsersInvolved(
      name: "Citizen Chloe White",
      userId: "citizen_005",
      account: AccountType.citizen,
    ),
    victim: UsersInvolved(
      name: "Store Owner",
      userId: "business_001",
      account: AccountType.mentor,
    ),
  ),
  IncidenceDto(
    title: "Assault Report",
    description: "Physical altercation near a bar.",
    date: DateTime.now().subtract(Duration(days: 12)),
    id: "id_assault_report",
    responseCount: 15,
    reported: UsersInvolved(
      name: "Officer Mia Carter",
      userId: "officer_004",
      account: AccountType.officer,
    ),
    victim: UsersInvolved(
      name: "David Warner",
      userId: "citizen_006",
      account: AccountType.citizen,
    ),
  ),
  IncidenceDto(
    title: "Suspicious Activity",
    description: "Unattended bag found at the train station.",
    date: DateTime.now().subtract(Duration(days: 3)),
    id: "id_suspicious_activity",
    responseCount: 4,
    reported: UsersInvolved(
      name: "Officer Jacob Miller",
      userId: "officer_005",
      account: AccountType.officer,
    ),
    victim: UsersInvolved(
      name: "Train Station Authority",
      userId: "organization_002",
      account: AccountType.mentor,
    ),
  ),
  IncidenceDto(
    title: "Fire Hazard",
    description: "Open flame spotted in a wooded area.",
    date: DateTime.now().subtract(Duration(days: 8)),
    id: "id_fire_hazard",
    responseCount: 10,
    reported: UsersInvolved(
      name: "Citizen Olivia Moore",
      userId: "citizen_007",
      account: AccountType.citizen,
    ),
    victim: UsersInvolved(
      name: "Local Forestry Team",
      userId: "team_001",
      account: AccountType.mentor,
    ),
  ),
  IncidenceDto(
    title: "Lost Pet",
    description: "Lost dog spotted in the neighborhood.",
    date: DateTime.now().subtract(Duration(days: 5)),
    id: "id_lost_pet",
    responseCount: 1,
    reported: UsersInvolved(
      name: "Citizen Sophia Green",
      userId: "citizen_008",
      account: AccountType.citizen,
    ),
    victim: UsersInvolved(
      name: "Pet Owner",
      userId: "individual_001",
      account: AccountType.citizen,
    ),
  ),
];
