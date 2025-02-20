import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_profile_cubit_state.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class OrganizationProfileCubit extends Cubit<OrganizationProfileCubitState>{
  OrganizationProfileCubit():super(OrganizationProfileCubitState(state: CubitState()));



}