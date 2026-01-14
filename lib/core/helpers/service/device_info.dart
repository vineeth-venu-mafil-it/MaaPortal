import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../core/helpers/cache_helper/app_cache_helper.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class DeviceInfo {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  Future<String?> getDeviceId() async {
    {
      if (kIsWeb) {
        final webBrowserInfo = await _deviceInfoPlugin.webBrowserInfo;

        final webId =
            '${webBrowserInfo.vendor ?? 'unknown_vendor'}_${webBrowserInfo.userAgent ?? 'unknown_agent'}_${webBrowserInfo.hardwareConcurrency}';
        return webId;
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor;
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfoPlugin.linuxInfo;
        return linuxInfo.machineId;
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfoPlugin.windowsInfo;
        return windowsInfo.computerName;
      }

      return null;
    }
  }
}
