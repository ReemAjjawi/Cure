import 'package:bloc/bloc.dart';
import 'package:cure/features/auth/presentation/bloc/login_event.dart';
import 'package:cure/features/auth/presentation/bloc/login_state.dart';
import 'package:cure/config/handle_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import '../../service.dart';

class LoginBloc extends Bloc<LogInClassEvent, LogInClassState> {
  LoginBloc() : super(InitialStateLogIn()) {
    on<LogInEvent>((event, emit) async {
      emit(LogInLoadingState());
      var box = Hive.box('projectBox');

      try {
        SuccessSituation response = await AuthServiceImp().LogIn(event.user);

        String? token = box.get('token');
        if (token != null && token.isNotEmpty) {
          emit(LogInSuccessState());
        } else {
          emit(LogInFailureState(message: "Token is empty or null."));
        }
      } on DioException catch (e) {
        emit(LogInFailureState(message: e.message!));
      }
    });
  }
}
