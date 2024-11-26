//NOTE Flutter Connect to Native Code
import 'package:flutter/services.dart';

class DynamicIconService {
  static const MethodChannel _channel =
      MethodChannel('flutter_dynamic_icon_plus');

  Future<bool> supportsAlternateIcons() async {
    return await _channel.invokeMethod('supportsAlternateIcons');
  }

  Future<String?> getAlternateIconName() async {
    return await _channel.invokeMethod('getAlternateIconName');
  }

  Future<void> setAlternateIconName(String? iconName,
      {bool showAlert = true}) async {
    print("in Func : ${iconName} - ${showAlert}");
    await _channel.invokeMethod('setAlternateIconName', {
      'iconName': iconName,
      'showAlert': showAlert,
    });
  }

  Future<int> getApplicationIconBadgeNumber() async {
    return await _channel.invokeMethod('getApplicationIconBadgeNumber');
  }

  Future<void> setApplicationIconBadgeNumber(int badgeNumber) async {
    await _channel.invokeMethod('setApplicationIconBadgeNumber', {
      'badgeNumber': badgeNumber,
    });
  }
}
