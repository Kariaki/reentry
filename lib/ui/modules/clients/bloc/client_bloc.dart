import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/repository/clients/client_repository.dart';
import 'package:reentry/ui/modules/clients/bloc/client_event.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientStateInitial()) {
    on<ClientActionEvent>(_clientAction);
  }

  final _repo = ClientRepository();

  Future<void> _clientAction(
      ClientEvent event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    try {
      final payLoad = event as ClientActionEvent;
      await _repo.updateClient(payLoad.client);
      emit(ClientSuccess(payLoad.client));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}
