import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static Future<bool?> setUser(String value) async =>
      await _prefsInstance?.setString('user', value);

  static String? getUser() =>
      _prefsInstance?.getString('user');
}