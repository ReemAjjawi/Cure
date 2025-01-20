import 'package:dio/dio.dart';

import '../../../../config/app_url.dart';
import '../../../../config/header_config.dart';
import '../../../../config/handle_model.dart';
import 'lecture_information_model.dart';
import '../../../lectures/lecture_model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class LectureService extends Service {
  Future<DataSuccessObject<LectureInformationModel>> getInfoLecture(
      int lectureId);
}

class LectureServiceInfoImp extends LectureService {
  @override
  Future<DataSuccessObject<LectureInformationModel>> getInfoLecture(
      int lectureId) async {
    try {
      print(lectureId);
      response = await dio.get(
          "${AppUrl.baseUrl}${AppUrl.lectureInfo}$lectureId",
          options: HeaderConfig.getHeader(useToken: true));
      print(response.statusCode);
      print("hi");


 if (response.statusCode == 200 || response.statusCode == 201) {
 
      
      LectureInformationModel lectureInfo =
          LectureInformationModel.fromMap(response.data);
      return DataSuccessObject<LectureInformationModel>(data: lectureInfo);

      }
      else {
      
        // Throw an exception when a 404 error occurs
        throw Exception("try again later.");
      
      }

    } on DioException catch (e) {
      throw e;
    }
  }
}
