import 'package:reentry/data/model/incidence_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class ReportCubitState {
  final List<IncidenceDto> data;
  final List<IncidenceResponse> responses;
  final CubitState state;

  const ReportCubitState(
      {required this.state, this.responses = const [], this.data = const []});

  static ReportCubitState init() => ReportCubitState(state: CubitState());

  ReportCubitState loading() => ReportCubitState(
      state: CubitStateLoading(), responses: responses, data: data);

  ReportCubitState success(
          {List<IncidenceDto>? data, List<IncidenceResponse>? responses}) =>
      ReportCubitState(
          state: CubitStateSuccess(),
          data: data ?? this.data,
          responses: responses ?? this.responses);

  ReportCubitState error(String error) => ReportCubitState(
      state: CubitStateError(error), data: data, responses: responses);
}
