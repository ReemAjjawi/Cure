import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import '../../config/app_url.dart';
import '../../services/subjects/handle_model.dart';
import 'model.dart';

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

      print(response.data);
      print(response.statusCode);
      String token = response.data['token'];
      var box = Hive.box('projectBox');

      box.put('token', token);

      return DataSuccessObject(data: response);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
