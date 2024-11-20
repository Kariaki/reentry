import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/appointment/appointment_repository.dart';
import 'package:reentry/data/repository/clients/client_repository.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_state.dart';
import '../../../../data/repository/admin/admin_repository.dart';

class CitizenProfileCubit extends Cubit<CitizenProfileCubitState> {
  CitizenProfileCubit() : super(CitizenProfileCubitState.init());

  final _appointmentRepo = AppointmentRepository();
  final _repo = AdminRepository();
  final _clientRepository = ClientRepository();
  final _userRepository = UserRepository();

  Future<void> fetchCitizenProfileInfo(UserDto user) async {
    List<UserDto> careTeam = [];
    int appointmentCount = 0;
    ClientDto? client;
    try {
      emit(state.loading());
      careTeam = await _repo.getNonCitizens();
      appointmentCount =
          (await _appointmentRepo.getAppointments(userId: user.userId ?? ''))
              .length;
      client = await _clientRepository.getClientById(user.userId ?? '');
      emit(state.success(
          careTeam: careTeam,
          user: user,
          appointmentCount: appointmentCount,
          client: client));
    } catch (e) {
      emit(state.error(e.toString()));
      return;
    }
  }

  Future<void> updateProfile(UserDto user) async {
    try {
      emit(state.loading());
      final newClient = state.client?.copyWith(
        name: user.name,
        avatar: user.avatar,
      );
      if (newClient != null) {
        await _clientRepository.updateClient(newClient);
      }
      await _userRepository.updateUser(user);
      emit(state.success(client: newClient, user: user));
    } catch (e) {
      emit(state.error(e.toString()));
    }
  }
}