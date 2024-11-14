// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:reentry/ui/modules/mentor/bloc/mentor_state.dart';
// import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';

// class MentorCubit extends Cubit<MentorState> {
//   final AdminUsersCubit adminUsersCubit; 

//   MentorCubit(this.adminUsersCubit) : super(MentorInitial());

//   void fetchMentor(String mentorId) {
//     emit(MentorLoading());
//     try {
//       // Find the mentor data from the list in AdminUsersCubit
//       final mentor = adminUsersCubit.mentors.firstWhere((mentor) => mentor.userId == mentorId);
//       emit(MentorLoaded(mentor));
//     } catch (e) {
//       emit(MentorError("Mentor not found"));
//     }
//   }
// }
