import 'package:flutter_bloc/flutter_bloc.dart';

class FeelingsCubit extends Cubit<bool> {
  FeelingsCubit() : super(false);

  void setFeeling() {
    emit(true);
  }
}
