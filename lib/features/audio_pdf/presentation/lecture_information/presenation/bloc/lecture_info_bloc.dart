import 'dart:developer';

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
          var box =
              await Hive.openBox<LectureInformationModel>('lectureInfoBox');

          final savedInfoLectures = box.get("${event.lectureId}".toString());
          //  await getSavedInfoLecture("${event.lectureId}".toString());

          if (savedInfoLectures != null) {
            emit(SuccessGet(xx: savedInfoLectures));
          } else {
            emit(FailureGet(
                message: "No internet and no saved lectures available."));
          }

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

Future<LectureInformationModel?> getSavedInfoLecture(String lectureId) async {
  try {
    var box = await Hive.openBox<List<dynamic>>('lectureInfoBox');
    final savedLecture = box.get(lectureId, defaultValue: null);
    print("Loaded ${savedLecture?.length ?? 0} lectures from Hive.");

    if (savedLecture != null && savedLecture.isNotEmpty) {
      return savedLecture.first
          as LectureInformationModel; // Assuming the first item is the correct one
    } else {
      print("No lecture found for the given lectureId.");
      return null;
    }
  } catch (e) {
    print("Error accessing Hive: $e");
    return null; // Return null in case of an error
  }
}

Future<void> saveInfoLecture(
    String lectureId, LectureInformationModel lectureInfo) async {
  try {
    var box = await Hive.openBox<LectureInformationModel>('lectureInfoBox');
    await box.put(lectureId, lectureInfo);

    print(box.get('lectureInfoBox'));
    log("=================================");
    print("Saving lectureInfo to Hive.");
    // await box.clear(); // Clear existing data
    await box.close();
    // await box.addAll(subjects);
  } catch (e) {
    print("Error saving subjects to Hive: $e");
  }
}
