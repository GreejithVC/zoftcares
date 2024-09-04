import 'package:zoftcares/models/auth_model.dart';

import '../models/app_version_model.dart';
import '../networks/api_handler.dart';
import '../networks/api_urls.dart';

class AuthService {
  ApiHandler apiHandler = ApiHandler();

  Future<AppVersionModel> fetchAppVersion() async {
    final response = await apiHandler.get(isAuthApi: false,
        url: ApiUrls.version);
    return AppVersionModel.fromJson(response);
  }
  Future<AuthModel> login( {required String email,required String password}) async {
    final response = await apiHandler.post(
        url: ApiUrls.login,body: {
      'email': email,
      'password': password,
    } );
    return AuthModel.fromJson(response);
  }
}
