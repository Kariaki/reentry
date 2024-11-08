import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';

import 'activity_event.dart';

class ActivityBloc extends Bloc<CreateActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitial()) {
    on<CreateActivityEvent>(_createActivity);
  }

  Future<void> _createActivity(
      CreateActivityEvent event, Emitter<ActivityState> emit) async {}
}
