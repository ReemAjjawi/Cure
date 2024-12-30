import 'package:bloc/bloc.dart';
import 'package:cure/features/auth/model.dart';
import 'package:cure/features/auth/response_model.dart';
import 'package:cure/features/dash_sub.dart/auth/presentation/bloc/login_event.dart';
import 'package:cure/features/dash_sub.dart/auth/presentation/bloc/login_state.dart';
import 'package:cure/features/dash_sub.dart/auth/services.dart';
import 'package:cure/services/subjects/handle_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

class LoginBloc extends Bloc<LogInClassEvent, LogInClassState> {
  LoginBloc() : super(InitialStateLogIn()) {
    on<LogInEvent>((event, emit) async {
      var box = Hive.box('projectBox');
      emit(LogInLoadingState());
      try {      SuccessSituation response = await AuthServiceImp().LogIn(event.user);

        String? token = box.get('token');
        if (token != null && token.isNotEmpty) {
          emit(LogInSuccessState());
        }
        else {
          emit(LogInFailureState(message: "Token is empty or null."));
        }
      } on DioException catch (e) {
        emit(LogInFailureState(message: e.message!));
      }
    });
  }
}
