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
      print("svghjj");
      print('${AppUrl.baseUrl}+${AppUrl.lectures}$numOfSubject');
      print(numOfSubject);
      response = await dio.get(
          '${AppUrl.baseUrl}${AppUrl.lectures}$numOfSubject',
          options: HeaderConfig.getHeader(useToken: true));
      print('${AppUrl.baseUrl}+${AppUrl.lectures}+$numOfSubject');
      List<LectureModel> lectures = List.generate(
        response.data.length,
        (index) => LectureModel.fromMap(response.data[index]),
      );
      return DataSuccessList<LectureModel>(data: lectures);
    } on DioException catch (e) {
      rethrow;
    }
  }
}