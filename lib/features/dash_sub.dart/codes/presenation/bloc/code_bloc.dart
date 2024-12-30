import 'package:bloc/bloc.dart';
import 'package:cure/features/dash_sub.dart/codes/presenation/bloc/code_event.dart';
import 'package:cure/features/dash_sub.dart/codes/service.dart';
import 'package:cure/services/subjects/handle_model.dart';
import 'package:dio/dio.dart';

import '../../model.dart';
import '../../response_code_model.dart';
import 'code_state.dart';

class CodeBloc extends Bloc<CodeEvent, CodeState> {
  CodeBloc() : super(CodeEmpty()) {
    on<GenerateCode>((event, emit) async {
      emit(CodeLoading());

      try { SuccessSituation response = await CodeServiceImp()
          .generateCode(event.numberOfCodes, event.subjectsNumber);
  
        if (response is DataSuccessList<CodeResponse>) {
          emit(SuccessGenerateCode(code: response.data));
        }
      } on DioException catch (e) {
        emit(FailureCodeState(message: e.message!));
      }
    });
  }
}
