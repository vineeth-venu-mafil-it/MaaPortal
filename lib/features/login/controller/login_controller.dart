import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../core/helpers/cache_helper/app_cache_helper.dart';
import '../repository/login_repo.dart';

class LoginController extends ChangeNotifier {
  final appCacheHelper = AppCacheHelper();
  final _api = LoginRepository();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final pinController = TextEditingController();

  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final otpFocusNode = FocusNode();

  final usernameMask = MaskTextInputFormatter(
    mask: '######',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool passwordVisible = false;
  bool isLoading = false;
  String? resError;
  String? otpAlert;
  String? otpErrorMsg;
  String? loginSuccess;

  String? encryptPass;
  String? baseHex;

  int remainingSeconds = 60;
  bool isTimerActive = true;

  String get username => usernameController.text.trim();
  String get password => passwordController.text;

  bool get isUsernameValid =>
      username.length == 6 && RegExp(r'^[0-9]+$').hasMatch(username);
  bool get isPasswordValid => password.isNotEmpty;
  bool get isFormValid => isUsernameValid && isPasswordValid;

  LoginController() {
    _initialize();
  }

  void _initialize() {
    usernameController.addListener(_onUsernameChanged);
    passwordController.addListener(clearError);
    passwordFocusNode.addListener(_onPasswordFocusChanged);

    pageLoadAction();
  }

  void _onUsernameChanged() {
    final text = usernameController.text;
    final masked = usernameMask.maskText(text);

    if (text != masked) {
      usernameController.value = usernameController.value.copyWith(
        text: masked,
        selection:
            TextSelection.fromPosition(TextPosition(offset: masked.length)),
      );
    }
    notifyListeners();
  }

  Future<void> _onPasswordFocusChanged() async {
    if (passwordFocusNode.hasFocus) return;

    if (username.isEmpty) {
      resError = 'User ID cannot be empty';
    } else if (password.isEmpty) {
      resError = 'Password cannot be empty';
    } else {
      await _performLoginFlow();
    }

    notifyListeners();
  }

  Future<void> login() async {
    if (!isFormValid) return;

    await _performLoginFlow();
  }

  Future<void> _performLoginFlow() async {
    isLoading = true;
    notifyListeners();

    encryptPass = await encryption(password);
    if (encryptPass == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    baseHex = await baseHexFun(encryptPass!);
    if (baseHex == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    await appCacheHelper.saveData(key: "hexPass", value: baseHex!);
    await passwordChecking(empCode: username, password: baseHex!);

    isLoading = false;
    notifyListeners();
  }

  Future<void> pageLoadAction() async {
    await macAddressCall();
  }

  Future<String?> encryption(String text) async {
    final key = encrypt.Key.fromUtf8("8080808080808080");
    final iv = encrypt.IV.fromUtf8("8080808080808080");
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  Future<String?> baseHexFun(String text) async {
    final charCodes = text.runes.toList();
    return charCodes.map((code) => code.toRadixString(16)).join();
  }

  Future<void> passwordChecking({
    required String empCode,
    required String password,
  }) async {
    try {
      final response =
          await _api.passwordCheck(empCode: empCode, password: password);

      if (response == null || response['status'] != 200) {
        resError = "No data found";
        return;
      }

      await Future.wait([
        appCacheHelper.saveData(
            key: 'accessId', value: "${response['data']['accessId']}"),
        appCacheHelper.saveData(
            key: 'roleId', value: "${response['data']['roleId']}"),
        appCacheHelper.saveData(
            key: 'empPunchBranch', value: "${response['data']['branchId']}"),
        appCacheHelper.saveData(
            key: 'flag', value: "${response['data']['flag']}"),
      ]);

      final ipAddress = await appCacheHelper.getData('IpAddress') ?? '';
      final vpnStatus = validateVpn(ipAddress);

      final isSuccess = "${response['data']['isSuccess']}";
      final message = "${response['data']['message']}";

      if (vpnStatus) {
        await generateOtp(type: '2');
      } else if (isSuccess == 'Warning') {
        resError = message;
        await generateOtp(type: '1');
      } else if (isSuccess == 'True') {
        await generateOtp(type: '1');
      } else {
        resError = message;
      }
    } catch (e) {
      if (kDebugMode) print("Password check error: $e");
    }
  }

  bool validateVpn(String ip) {
    final prefix3 = ip.substring(0, 3);
    final prefix6 = ip.substring(0, 6);
    return prefix3 == "172" || prefix6 == "10.202";
  }

  Future<void> generateOtp({required String type}) async {
    try {
      final response = await _api.generateOtp(
        pFlag: 'GENERATE_OTP',
        pPageValue: "$username~1",
        pParaValue: '1',
      );

      if (response == null || response['status'] != 200) {
        resError = 'Generate OTP failed';
        return;
      }

      if (type == "1" && "${response['data'][0]['RES']}" == '222') {
        if (baseHex != null) {
          await generateToken(empCode: username, password: baseHex!);
        }
      } else {
        otpAlert = 'otp generated';
      }
    } catch (e) {
      if (kDebugMode) print("Generate OTP error: $e");
    }
  }

  Future<void> generateToken({
    required String empCode,
    required String password,
  }) async {
    try {
      final response =
          await _api.generateToken(empCode: empCode, password: password);

      if (response != null && response['status'] == 200) {
        await appCacheHelper.saveData(
            key: 'token', value: "${response['data']['Token']}");
        await getEmpDetails();
      } else {
        resError = 'token generation failed';
      }
    } catch (e) {
      if (kDebugMode) print("Token generation error: $e");
    }
  }

  Future<void> getEmpDetails() async {
    try {
      final macId = await appCacheHelper.getData('Macid');
      final data = "1~0~${username}~0~$macId~12:00 AM~02:00:00 AM~GETEMPDET";
      final response = await _api.getEmpDetails(value: data);

      if (response != null && response['status'] == 200) {
        await Future.wait([
          appCacheHelper.saveData(
              key: 'EMP_NAME', value: "${response['data']['EMP_NAME']}"),
          appCacheHelper.saveData(
              key: 'POST_ID', value: "${response['data']['POST_ID']}"),
        ]);
        await getBranchDet();
      } else {
        resError = 'employee details failed';
      }
    } catch (e) {
      if (kDebugMode) print("Get emp details error: $e");
    }
  }

  Future<void> getBranchDet() async {
    try {
      final results = await Future.wait([
        appCacheHelper.getData('Macid'),
        appCacheHelper.getData('Host'),
        appCacheHelper.getData('roleId'),
        appCacheHelper.getData('Osinst'),
        appCacheHelper.getData('empPunchBranch'),
      ]);

      final data =
          "${results[0]}~${results[1]}~${results[3]}~|0~$username~${results[4]}~${results[2]}";
      final response = await _api.getBranchDet(value: data);

      if (response != null && response['status'] == 200) {
        await Future.wait([
          appCacheHelper.saveData(
              key: 'branchId', value: "${response['data']['branchId']}"),
          appCacheHelper.saveData(
              key: 'branchName', value: "${response['data']['branchName']}"),
          appCacheHelper.saveData(
              key: 'mailFlag', value: "${response['data']['mailFlag']}"),
        ]);

        if ("${response['data']['result']}" == 'Success') {
          await portalSessionEncrypt();
        }
      } else {
        resError = 'branch details failed';
      }
    } catch (e) {
      if (kDebugMode) print("Branch details error: $e");
    }
  }

  Future<void> portalSessionEncrypt() async {
    try {
      final results = await Future.wait([
        appCacheHelper.getData('IpAddress'),
        appCacheHelper.getData('branchId'),
        appCacheHelper.getData('branchName'),
        appCacheHelper.getData('EMP_NAME'),
        appCacheHelper.getData('empPunchBranch'),
        appCacheHelper.getData('accessId'),
        appCacheHelper.getData('roleId'),
      ]);

      final formattedTime = DateFormat('h:mm:ss a').format(DateTime.now());

      final data =
          "${results[1]}|${results[2]}|$username!${results[0]}|${results[3]}|${results[4]}|${results[5]}|${results[6]}|$formattedTime";

      final response = await _api.portalSessionEncrypt(value: data);

      if (response != null && response['status'] == 200) {
        await appCacheHelper.saveData(
            key: 'curSession', value: "${response['data']['response']}");

        final roleId = int.tryParse(results[6] ?? '0') ?? 0;
        final empPunchBranch = results[4];

        if (roleId >= 6 && empPunchBranch == '0') {
          await appCacheHelper.saveData(key: 'empCode', value: username);
          loginSuccess = 'valid';
        }
      } else {
        resError = 'portal session failed';
      }
    } catch (e) {
      if (kDebugMode) print("Portal session encrypt error: $e");
    }
  }

  Future<void> macAddressCall() async {
    try {
      final response = await _api.macAddressCall();
      if (response != null && response['status'] == 200) {
        await appCacheHelper.saveData(
            key: 'Macid', value: "${response['data']['Macid']}");
        await getHostname();
      } else {
        resError =
            'WebApiSelfHosting Service is not installed. Please Contact IT Helpdesk';
      }
    } catch (e) {
      if (kDebugMode) print("Mac address call error: $e");
    }
  }

  Future<void> getHostname() async {
    try {
      final response = await _api.getHostname();
      if (response != null && response['status'] == 200) {
        final host = "${response['data']['Host']}";
        await appCacheHelper.saveData(key: 'Host', value: host);
        if (host.isEmpty) {
          resError = 'Host name is empty';
        } else {
          await getOsInstallDate();
        }
      } else {
        resError = 'host name api failed';
      }
    } catch (e) {
      if (kDebugMode) print("Get hostname error: $e");
    }
  }

  Future<void> getOsInstallDate() async {
    try {
      final response = await _api.getOsInstallDate();
      if (response != null && response['status'] == 200) {
        await appCacheHelper.saveData(
            key: 'Osinst', value: "${response['data']['Osinst']}");
        await getClientIP();
      } else {
        resError = 'OS install date api failed';
      }
    } catch (e) {
      if (kDebugMode) print("OS install date error: $e");
    }
  }

  Future<void> getClientIP() async {
    try {
      final response = await _api.getClientIP();
      if (response != null && response['status'] == 200) {
        final ip = "${response['data']['Result']}";
        await appCacheHelper.saveData(key: 'IpAddress', value: ip);
        if (ip.isEmpty) {
          resError = 'Ip address is empty';
        }
      } else {
        resError = 'Ip address api failed';
      }
    } catch (e) {
      if (kDebugMode) print("Client IP error: $e");
    }
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void startOtpTimer() {
    remainingSeconds = 60;
    isTimerActive = true;
    otpErrorMsg = null;
    _countdown();
  }

  void _countdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
        _countdown();
      } else {
        isTimerActive = false;
        notifyListeners();
      }
    });
  }

  void clearError() {
    resError = null;
    otpAlert = null;
    otpErrorMsg = null;
    notifyListeners();
  }

  String? validateUsername(String? value) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return 'Please enter your user ID';
    if (val.length != 6) return 'User ID must be 6 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(val))
      return 'User ID must contain only numbers';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Please enter your password';
    return null;
  }

  void _scheduleNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    usernameController.removeListener(_onUsernameChanged);
    passwordController.removeListener(clearError);
    passwordFocusNode.removeListener(_onPasswordFocusChanged);

    usernameController.dispose();
    passwordController.dispose();
    pinController.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    otpFocusNode.dispose();

    super.dispose();
  }
}
