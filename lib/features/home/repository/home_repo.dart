import 'package:maaportal/core/helpers/network/api_endpoints.dart';

import '../../../core/helpers/cache_helper/app_cache_helper.dart';
import '../../../core/helpers/encryption/app_encryption_helper.dart';
import '../../../core/helpers/network/http/network_api_services.dart';

class HomeRepo {
  final _apiService = NetworkApiServices();
  final appDecryptHelper = AppEncryptionHelper();
  final appCacheHelper = AppCacheHelper();

  ///Password check
  Future<dynamic> fetchTableData({required String url}) async {
    final String? token = await appCacheHelper.getData('token');
    dynamic response = await _apiService.getApi(url, token: token ?? '');
    return response;
  }

  ///Check session

  Future<dynamic> checkSession() async {
    final String? token = await appCacheHelper.getData('token');
    final String? empCode = await appCacheHelper.getData('empCode');
    final String? hexPass = await appCacheHelper.getData('hexPass');
    var data = {"empCode": empCode, "password": hexPass};
    dynamic response = await _apiService.postApi(data,
        "${ApiEndPoints.baseUrlUat}/GlobalApi/api/helper/CheckCredentials",
        token: token);

    return response;
  }

  ///Count check
  Future<dynamic> countCheck({required String value}) async {
    final String? token = await appCacheHelper.getData('token');
    var data = {
      "flag": "MENULOGDETAILS",
      "pageValue": value,
      "paraValue": "1"
    };
    dynamic response = await _apiService.postApi(data,
        "${ApiEndPoints.baseUrlUat}/CustomMaaPortalMenuAPI/api/CustomMenuAPI/PostCustomMenuDetails",
        token: token);
    return response;
  }
}
