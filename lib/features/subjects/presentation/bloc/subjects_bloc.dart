import 'package:bloc/bloc.dart';
import 'package:cure/features/subjects/services.dart';
import 'package:cure/services/subjects/handle_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../model.dart';

part 'subjects_event.dart';
part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectsBloc() : super(SubjectsLoading()) {
    on<GetSubjects>((event, emit) async {


    try {SuccessSituation response = await SubjectServiceImp().getSubjects();

        if (response is DataSuccessList  <SubjectModel>) {
        emit(  SubjectsList(subjects: response.data));
      }
 
    }on DioException catch (e) {
emit(FailureSubjectsState(message:e.message! ));
          }
    });


      on<AddCodeToUser>((event, emit) async {


    try {bool response = await SubjectServiceImp().addCodeToUser(event.code);

        if (response ==true) {

        emit(  SuccessAddCode());
      }
   
 
    }on DioException catch (e) {
emit(FailureSubjectsState(message:e.message! ));
          }
    });
  }
}
