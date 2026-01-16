import '../../../core/helpers/cache_helper/app_cache_helper.dart';
import '../../../core/helpers/encryption/app_encryption_helper.dart';
import '../../../core/helpers/network/api_endpoints.dart';
import '../../../core/helpers/network/http/network_api_services.dart';

class LoginRepository {
  final _apiService = NetworkApiServices();
  final appDecryptHelper = AppEncryptionHelper();
  final appCacheHelper = AppCacheHelper();

  ///Password check
  Future<dynamic> passwordCheck(
      {required String empCode, required String password}) async {
    Map<String, dynamic> data = {"empCode": empCode, "password": password};
    dynamic response = await _apiService.postApi(
        data, '${ApiEndPoints.baseUrlUat}/GlobalApi/api/helper/GetRoles');
    return response;
  }

  ///get system ip
  Future<dynamic> macAddressCall() async {
    dynamic response = await _apiService.getApi(
      "${ApiEndPoints.sysBaseURL}getMacID",
    );
    return response;
  }


  ///get hostname ip
  Future<dynamic> getHostname() async {
    dynamic response = await _apiService.getApi(
      "${ApiEndPoints.sysBaseURL}getHostname",
    );
    return response;
  }

  ///get Os installed date
  Future<dynamic> getOsInstallDate() async {
    dynamic response = await _apiService.getApi(
      "${ApiEndPoints.sysBaseURL}getOsInstalldate",
    );
    return response;
  }

  ///get ip address
  Future<dynamic> getClientIP() async {
    dynamic response = await _apiService.getApi(
      "${ApiEndPoints.baseUrlUat}/MflPortalEmpOtp/api/Mfa/GetClientIP",
    );
    return response;
  }

  ///Vpn checking --- ip address
  Future<dynamic> checkVpnAccess() async {
    dynamic response = await _apiService.getApi(
      "${ApiEndPoints.baseUrlUat}/MflPortalEmpOtp/api/Mfa/GetClientIP",
    );
    return response;
  }

  ///Generate Otp
  Future<dynamic> generateOtp(
      {required String pFlag,
      required String pPageValue,
      required String pParaValue}) async {
    Map<String, dynamic> data = {
      "p_flag": pFlag,
      "p_pagevalue": pPageValue,
      "p_paravalue": pParaValue,
    };

    dynamic response = await _apiService.postApi(
        data, '${ApiEndPoints.baseUrlUat}/MflPortalEmpOtp/api/Mfa/PostMfaData');
    return response;
  }

  ///validate otp vpn
  Future<dynamic> verifyOtpVpn(
      {required String empCode, required String curOtp}) async {
    Map<String, dynamic> data = {
      "p_flag": 'OTP_VERIFICATION',
      "p_pagevalue": '$empCode~${curOtp}~1',
      "p_paravalue": '1',
    };

    dynamic response = await _apiService.postApi(
        data, '${ApiEndPoints.baseUrlUat}/MflPortalEmpOtp/api/Mfa/PostMfaData');
    return response;
  }

  ///Verify OTP
  Future<dynamic> verifyOtp({required String value}) async {
    Map<String, dynamic> data = {
      "p_flag": 'GENERATE_OTP',
      "p_pagevalue": value,
      "p_paravalue": '1',
    };

    dynamic response = await _apiService.postApi(
        data, '${ApiEndPoints.baseUrlUat}/MflPortalEmpOtp/api/Mfa/PostMfaData');
    return response;
  }

  ///Generate token
  Future<dynamic> generateToken(
      {required String empCode, required String password}) async {
    Map<String, dynamic> data = {"empcode": empCode, "password": password};

    dynamic response = await _apiService.postApi(data,
        '${ApiEndPoints.baseUrlUat}/GlobalApi/api/authentication/AuthenticateUser');
    return response;
  }

  ///Get employee details
  Future<dynamic> getEmpDetails({required String value}) async {
    Map<String, dynamic> data = {
      "firmId": value.split('~')[0],
      "branchId": value.split('~')[1],
      "userId": value.split('~')[2],
      "sessionId": value.split('~')[3],
      "macId": value.split('~')[4],
      "fromDate": value.split('~')[5],
      "toDate": value.split('~')[6],
      "flag": value.split('~')[7],
    };
    String? curToken = await appCacheHelper.getData('token');

    dynamic response = await _apiService.postApi(data,
        '${ApiEndPoints.baseUrlUat}/PortalApi/api/portal/GetPortalDetails',
        token: curToken ?? '');
    return response;
  }

  ///Get employee details
  Future<dynamic> getBranchDet({required String value}) async {
    Map<String, dynamic> data = {
      "macId": value.split('~')[0],
      "hostName": value.split('~')[1],
      "osInstallDate": value.split('~')[2],
      "param": value.split('~')[3],
      "userId": value.split('~')[4],
      "empPunchedBr": value.split('~')[5],
      "roleId": value.split('~')[6],
    };

    String? curToken = await appCacheHelper.getData('token');

    dynamic response = await _apiService.postApi(
        data, '${ApiEndPoints.baseUrlUat}/PortalApi/api/portal/Validate',
        token: curToken ?? '');
    return response;
  }

  ///Get employee details
  Future<dynamic> portalSessionEncrypt({required String value}) async {
    Map<String, dynamic> data = {"data": value};

    dynamic response = await _apiService.postApi(data,
        '${ApiEndPoints.baseUrlUat}/PortalSessionApi/api/PortalSession/PortalEncrypt');
    return response;
  }
}
