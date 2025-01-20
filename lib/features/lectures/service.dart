import 'package:cure/config/app_url.dart';
import 'package:dio/dio.dart';

import '../../config/header_config.dart';
import '../../config/handle_model.dart';
import 'lecture_model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class LectureService extends Service {
  Future<DataSuccessList<LectureModel>> getLectures(int numOfSubject);
}

class LectureServiceImp extends LectureService {
  @override
  Future<DataSuccessList<LectureModel>> getLectures(int numOfSubject) async {
    try {
 
      response = await dio.get(
          '${AppUrl.baseUrl}${AppUrl.lectures}$numOfSubject',
          options: HeaderConfig.getHeader(useToken: true));
      print('${AppUrl.baseUrl}+${AppUrl.lectures}+$numOfSubject');

      if (response.statusCode == 200 || response.statusCode == 201) {
              List<LectureModel> lectures = List.generate(
        response.data.length,
        (index) => LectureModel.fromMap(response.data[index]),
      );
        return DataSuccessList<LectureModel>(data: lectures);
      } else {
        throw Exception(
        "Failed to fetch Lecture");
      }
    } on DioException catch (e) {
      rethrow;
    } 
  }
}
