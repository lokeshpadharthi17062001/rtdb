import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static Future<bool?> setSessionStopTime(String value) async =>
      await _prefsInstance?.setString(UserDefaultKeys.time, value);

  static String? getSessionStopTime() =>
      _prefsInstance?.getString(UserDefaultKeys.time);

  static Future<bool?> setLocalUserProfile(String value) async =>
      await _prefsInstance?.setString(UserDefaultKeys.userProfile, value);

  static String? getLocalUserProfile() =>
      _prefsInstance?.getString(UserDefaultKeys.userProfile);

  static Future<bool?> setDevicesLayout(String value) async =>
      await _prefsInstance?.setString(UserDefaultKeys.deviceDetails, value);

  static String? getDeviceLayout() =>
      _prefsInstance?.getString(UserDefaultKeys.deviceDetails);

  // static Future<bool?> setIdleDeviceDetails(String value) async =>
  //     await _prefsInstance?.setString(UserDefaultKeys.idleDeviceDetails, value);
  //
  // static String? getIdleDeviceDetails() =>
  //     _prefsInstance?.getString(UserDefaultKeys.idleDeviceDetails);
  //
  // static Future<bool?> setLiveDeviceDetails(String value) async =>
  //     await _prefsInstance?.setString(UserDefaultKeys.liveDeviceDetails, value);
  //
  // static String? getLiveDeviceDetails() =>
  //     _prefsInstance?.getString(UserDefaultKeys.liveDeviceDetails);

  static clearAllDatas() {
    _prefsInstance?.clear();
  }
}

class UserDefaultKeys {
  static var time = "time";
  static var userProfile = "userProfile";
  static var idleDeviceDetails = "idleDeviceDetails";
  static var liveDeviceDetails = "liveDeviceDetails";
  static var deviceTimeLagDetails = "deviceTimeLagDetails";
  static var deviceDetails = "deviceDetails";
}
