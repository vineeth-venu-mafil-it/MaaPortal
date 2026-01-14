import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../core/helpers/cache_helper/app_cache_helper.dart';
import '../../../core/helpers/network/api_endpoints.dart';
import '../model/task_model.dart';
import '../repository/home_repo.dart';

class HomeController extends ChangeNotifier {
  final AppCacheHelper _cache = AppCacheHelper();
  final HomeRepo _api = HomeRepo();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _empCode;
  String? get empCode => _empCode;

  String? _processedToken;

  String? _branchId;

  set branchId(String? value) {
    _branchId = value;
  }

  String? get branchId => _branchId;

  final List<TaskDetails> _primaryTasks = [];
  final List<TaskDetails> _generalTasks = [];

  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Hover state
  int _hoveredIndex = -1;
  int get hoveredIndex => _hoveredIndex;

  List<TaskDetails> get currentData {
    final source = _currentTabIndex == 0 ? _primaryTasks : _generalTasks;
    if (_searchQuery.isEmpty) return source;

    final query = _searchQuery.toLowerCase().trim();
    return source.where((t) {
      return (t.subject?.toLowerCase().contains(query) ?? false) ||
          (t.assignedEmploy?.toLowerCase().contains(query) ?? false) ||
          (t.content?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  HomeController() {
    _init();
  }

  Future<void> _init() async {
    await _loadEmpCode();

    if (_empCode == null || _empCode!.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    branchId = await _cache.getData('branchName');
    await _processAuthToken();

    await loadTasksForCurrentTab();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
  }

  void clearError() {
    errorMessage = null;

    notifyListeners();
  }

  Future<void> _loadEmpCode() async {
    try {
      _empCode = await _cache.getData('empCode');
    } catch (e) {
      debugPrint('Failed to load empCode: $e');
      _empCode = null;
    }
  }

  Future<void> _processAuthToken() async {
    try {
      final rawToken = await _cache.getData('token') ?? '';
      if (rawToken.isEmpty) {
        debugPrint('No token found in cache');
        return;
      }

      final encryptedBase64 = await _encryptToken(rawToken);
      if (encryptedBase64 == null || encryptedBase64.isEmpty) {
        debugPrint('Encryption failed');
        return;
      }

      _processedToken = await _toHexString(encryptedBase64);
      debugPrint('Processed token (hex): $_processedToken');
    } catch (e) {
      debugPrint('Token processing failed: $e');
      _processedToken = null;
    }
  }

  Future<String?> _encryptToken(String plainText) async {
    try {
      const keyString = "8080808080808080";
      const ivString = "8080808080808080";

      final key = encrypt.Key.fromUtf8(keyString);
      final iv = encrypt.IV.fromUtf8(ivString);

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64;
    } catch (e) {
      debugPrint('Encryption error: $e');
      return null;
    }
  }

  // ── Convert string → hex string ──────────────────────────────────────────────
  Future<String?> _toHexString(String input) async {
    try {
      final bytes = input.codeUnits;
      final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      return hex.toUpperCase(); // usually uppercase is preferred
    } catch (e) {
      debugPrint('Hex conversion error: $e');
      return null;
    }
  }

  set currentTabIndex(int index) {
    if (index == _currentTabIndex) return;
    _currentTabIndex = index;
    _searchQuery = '';
    notifyListeners();
    loadTasksForCurrentTab();
  }

  void updateSearchQuery(String query) {
    final trimmed = query.trim();
    if (trimmed == _searchQuery) return;
    _searchQuery = trimmed;
    notifyListeners();
  }

  void setHoveredIndex(int index) {
    if (_hoveredIndex == index) return;
    _hoveredIndex = index;
    notifyListeners();
  }

  void clearHover() {
    if (_hoveredIndex == -1) return;
    _hoveredIndex = -1;
    notifyListeners();
  }

  Future<void> loadTasksForCurrentTab() async {
    if (_empCode == null || _empCode!.isEmpty) {
      _clearAllTasks();
      return;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final url = _buildTaskUrl();
      final response = await _api.fetchTableData(url: url);

      if (response == null || response['status'] != 200) {
        _handleError('Failed to load tasks (status: ${response?['status']})');
        return;
      }

      final tasks = _parseTasks(response);

      if (_currentTabIndex == 0) {
        _primaryTasks
          ..clear()
          ..addAll(tasks);
      } else {
        _generalTasks
          ..clear()
          ..addAll(tasks);
      }

      _setLoading(false);
    } catch (e, st) {
      debugPrint('Task fetch error: $e');
      if (kDebugMode) debugPrint('Stack: $st');
      _handleError('Something went wrong while loading tasks');
    }
  }

  Future<void> handleMenuAction(String value) async {
    try {
      final sessionValid = await _checkSession();
      if (!sessionValid) {
        debugPrint('Session check failed');
        return;
      }

      await countCheck(value: value);
    } catch (e) {
      debugPrint('Error in handleMenuAction: $e');
    }
  }

  Future<bool> _checkSession() async {
    try {
      final res = await _api.checkSession();
      if (res == null || res['status'] != 200) return false;

      final flag = "${res['data']['flag']}";
      return flag == '1';
    } catch (_) {
      return false;
    }
  }

  Future<void> countCheck({required String value}) async {
    try {
      final cached = await Future.wait([
        _cache.getData('empCode'),
        _cache.getData('branchId'),
        _cache.getData('IpAddress'),
        _cache.getData('Host'),
        _cache.getData('curSession'),
      ]);

      final [empCode, branchId, ipAddress, hostName, session] = cached;

      if (empCode == null || _processedToken == null || session == null) {
        debugPrint(
            'Missing critical cached values (empCode, token or session)');
        return;
      }

      final parts = value.split('~').map((e) => e.trim()).toList();
      if (parts.length < 4) {
        debugPrint('Invalid menu value format: $value');
        return;
      }

      final priority = parts[0];
      final statusUrl = parts[1]; // base URL
      final menuId = parts[3];

      final payload = '$empCode*$menuId*$branchId*$hostName*$ipAddress*1';
      final response = await _api.countCheck(value: payload);

      if (response == null || response['status'] != 200) {
        debugPrint('Count check failed → ${response?['status']}');
        return;
      }

      final baseAction = statusUrl.split('?').first.trim();

      if (priority != '0') {
        await _submitForm(baseAction, session, _processedToken!);
        return;
      }

      final queryParams = '?session=$session&token=$_processedToken';

      if (menuId == '27' || menuId == '36') {
        final browser = await _detectBrowser();
        if (browser == 'Microsoft Edge') {
          final edgeUri = Uri.parse('microsoft-edge:$baseAction$queryParams');
          if (await canLaunchUrl(edgeUri)) {
            await launchUrl(edgeUri);
            return;
          }
        }
      }

      // Fallback: normal browser launch with query params
      final uri = Uri.parse('$baseAction$queryParams');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await _submitForm(baseAction, session, _processedToken!);
      }
    } catch (e, st) {
      debugPrint('countCheck failed: $e');
      if (kDebugMode) debugPrint('Stack: $st');
    }
  }

  Future<void> _submitForm(
      String baseAction, String sessionId, String token) async {
    try {
      final form = html.FormElement()
        ..method = 'post'
        ..action = baseAction
        ..target = '_blank';

      form.append(html.InputElement(type: 'hidden')
        ..name = 'id'
        ..value = sessionId);

      form.append(html.InputElement(type: 'hidden')
        ..name = 'token'
        ..value = token);

      html.document.body?.append(form);
      form.submit();
      form.remove();
    } catch (e) {
      debugPrint('Form submit failed: $e');
    }
  }

  String _buildTaskUrl() {
    const base =
        '${ApiEndPoints.baseUrlUat}/CustomMaaPortalMenuAPI/api/CustomMenuAPI/GetCustomMenuDetails/GETAPPPORTALMENU';
    final endpoint = _currentTabIndex == 0 ? '1' : '2';
    return '$base/$_empCode*0*3/$endpoint';
  }

  List<TaskDetails> _parseTasks(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>? ?? {};

    if (data['taskDetails'] case final List list when list.isNotEmpty) {
      return list.map((e) => TaskDetails.fromJson(e)).toList();
    }

    if (data['menuResDto'] case final List list when list.isNotEmpty) {
      return list.map((item) {
        return TaskDetails(
          taskId: item['TASK_ID'],
          subTaskId: item['SUB_TASK_ID'],
          subject: item['SUBJECT'],
          assignDt: item['assign_dt'],
          targetDt: item['target_dt'],
          assignedEmpcode: item['assigned_empcode'],
          assignedEmploy: item['Assigned_Employ'],
          requestedEmpcode: item['Requested_Empcode'],
          requestedEmploy: item['requested_employ'],
          status: item['STATUS'],
          reqType: item['REQ_TYPE'],
          priority: item['PRIORITY'],
          content: item['CONTENT'],
          revReqdate: item['Rev_reqdate'],
          reqReason: item['Req_reason'],
        );
      }).toList();
    }

    return [];
  }

  Future<String> _detectBrowser() async {
    final ua = html.window.navigator.userAgent.toLowerCase();

    if (ua.contains('edg')) return 'Microsoft Edge';
    if (ua.contains('firefox')) return 'Mozilla Firefox';
    if (ua.contains('opr') || ua.contains('opera')) return 'Opera';
    if (ua.contains('chrome')) return 'Google Chrome';
    if (ua.contains('safari') && !ua.contains('chrome')) return 'Apple Safari';

    return 'Unknown';
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _safeNotify();
  }

  void _handleError(String msg) {
    _errorMessage = msg;
    _setLoading(false);
  }

  void _clearAllTasks() {
    _primaryTasks.clear();
    _generalTasks.clear();
    _setLoading(false);
  }

  void _safeNotify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
