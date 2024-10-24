import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/clients/client_repository.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientCubit() : super(ClientStateInitial());

  final _repo = ClientRepository();

  Future<void> fetchClients() async {
    emit(ClientLoading());
    try {
      final result = await _repo.getUserClients();
      emit(ClientDataSuccess(result));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}

class RecommendedClientCubit extends Cubit<ClientState> {
  RecommendedClientCubit() : super(ClientStateInitial());

  final _repo = ClientRepository();

  Future<void> fetchRecommendedClients() async {
    emit(ClientLoading());
    try {
      final result = await _repo.getRecommendedClients();
      emit(ClientDataSuccess(result));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}
