import 'package:bloc/bloc.dart';
import 'package:cure/services/subjects/handle_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../model.dart';
import '../../services.dart';

part 'lectures_event.dart';
part 'lectures_state.dart';

class LecturesBloc extends Bloc<LecturesEvent, LecturesState> {
  LecturesBloc() : super(LecturesLoading()) {
    on<GetLectures>((event, emit) async {
       try {   SuccessSituation response =
          await LectureServiceImp().getLectures(event.numberOfLecture);
  
        print("hi");
        if (response is DataSuccessList<LectureModel>) {
          emit(LecturesList(lectures: response.data));
        }
      } on DioException catch (e) {
        emit(FailureLecturesState(message: e.message!));
      }
    });
  }
}
