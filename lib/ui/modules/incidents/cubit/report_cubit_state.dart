import 'package:reentry/data/model/incidence_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class ReportCubitState {
  final List<IncidenceDto> data;
  final List<IncidenceDto> all;
  final List<IncidenceResponse> responses;
  final CubitState state;
  final IncidenceDto? selected;

  const ReportCubitState(
      {required this.state, this.responses = const [],this.all=const [], this.data = const [],this.selected});

  static ReportCubitState init() => ReportCubitState(state: CubitState());

  ReportCubitState loading() => ReportCubitState(
      state: CubitStateLoading(), responses: responses, data: data,all: all);

  ReportCubitState success(
          {List<IncidenceDto>? data,List<IncidenceDto>? all, List<IncidenceResponse>? responses,IncidenceDto? selected,CubitState? state}) =>
      ReportCubitState(
          state: state??CubitStateSuccess(),
          data: data ?? this.data,
          all:all??this.all ,
          selected: selected??this.selected,
          responses: responses ?? this.responses);

  ReportCubitState error(String error) => ReportCubitState(
      state: CubitStateError(error), data: data, responses: responses,all: all);
}
