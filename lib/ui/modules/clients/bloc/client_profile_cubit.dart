import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/repository/clients/client_repository.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';

class ClientProfileCubit extends Cubit<ClientState> {
  ClientProfileCubit() : super(ClientStateInitial());
  final _repo = ClientRepository();

  Future<void> fetchClientById(String id) async {
    emit(ClientLoading());
    try {
      final result = await _repo.getClientById(id);
      if (result == null) {
        emit(ClientError('User not found'));
        return;
      }
      emit(ClientSuccess(result));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}