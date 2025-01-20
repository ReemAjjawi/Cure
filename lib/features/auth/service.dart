import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import '../../config/app_url.dart';
import '../../config/handle_model.dart';
import 'models/request/model.dart';
import 'models/response/response_model.dart';

abstract class service {
  late Response response;

  Dio dio = Dio();
}

abstract class AuthService extends service {
  Future<SuccessSituation> LogIn(LogInModel logn);
}

class AuthServiceImp extends AuthService {
  @override
  Future<SuccessSituation> LogIn(LogInModel logn) async {
    try {
      print(logn.toMap());
      print('${AppUrl.baseUrl}${AppUrl.logInUser}');
      final data = logn.toMap();
      Response response = await dio.post('${AppUrl.baseUrl}${AppUrl.logInUser}',
          data: logn.toJson());
      print('${AppUrl.baseUrl}${AppUrl.logInUser}');
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        print(response.statusCode);
        Login model = Login.fromMap(response.data);
        var box = Hive.box('projectBox');
        String token = model.data.token;
        print(token);
        box.put('token', token);
        return DataSuccessObject(data: response);
      } else {
        // Throw an exception when a 404 error occurs
        throw Exception("try again later.");
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
