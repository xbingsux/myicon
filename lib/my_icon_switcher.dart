//NOTE Flutter Connect to Native Code
import 'package:flutter/services.dart';

class MyIconSwitcher {
  static const MethodChannel _channel = MethodChannel('my_icon_switcher');

  Future<bool> supportsAlternateIcons() async {
    return await _channel.invokeMethod('supportsAlternateIcons');
  }

  Future<String?> getAlternateIconName() async {
    return await _channel.invokeMethod('getAlternateIconName');
  }

  Future<void> setAlternateIconName(String? iconName,
      {bool showAlert = true}) async {
    print("setAlternateIconName : ${iconName}");
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
