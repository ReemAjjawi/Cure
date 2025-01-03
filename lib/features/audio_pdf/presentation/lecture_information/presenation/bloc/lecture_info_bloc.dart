import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/handle_model.dart';
import '../../lecture_information_model.dart';
import 'lecture_info_event.dart';
import 'lecture_info_state.dart';
import '../../service.dart';

class LectureInformationBloc
    extends Bloc<GetInformationLectureEvent, GetInformationLectureState> {
  LectureInformationBloc() : super(Loading()) {
    on<GetInfoLecture>((event, emit) async {
      try {
        final connectivityResult = await Connectivity().checkConnectivity();
        print("Connectivity Result: $connectivityResult");

        if (connectivityResult.contains(ConnectivityResult.none)) {
          print("lectueer connectivity");
          print("$ConnectivityResult");
          // No internet: fetch saved lectures for the subject from Hive
          final savedInfoLectures =
              await getSavedInfoLecture("${event.lectureId}".toString());
          // Emit the cached data if found
          emit(SuccessGet(xx: savedInfoLectures));
          print("lectueer connectivity");
        } else {
          SuccessSituation response =
              await LectureServiceInfoImp().getInfoLecture(event.lectureId);

          if (response is DataSuccessObject<LectureInformationModel>) {
            await saveInfoLecture(
                "${event.lectureId}".toString(), response.data);
            emit(SuccessGet(xx: response.data));
            print(response.data);
          }
        }
      } on DioException catch (e) {
        emit(FailureGet(message: e.message!));
      }
    });
  }
}

Future<LectureInformationModel> getSavedInfoLecture(String lectureId) async {
  final box = await Hive.openBox('lectureInfoBox');
  final savedLectures =
      box.get(lectureId, defaultValue: []) as LectureInformationModel;
  return savedLectures; // Remove any null values
}

Future<void> saveInfoLecture(
    String lectureId, LectureInformationModel lectureInfo) async {
  final box = await Hive.openBox('lectureInfoBox');
  await box.put(lectureId, lectureInfo);
}
