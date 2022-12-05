import 'dart:convert';

import 'package:rtdb/helpers/shared_preference.dart';

class SessionHandler {
  static void setSessionStopTime(int? sessionStopTime, String deviceName) {
    if (StorageManager.getSessionStopTime() != null) {
      Map<String, dynamic> sessionStopDetails =
          jsonDecode(StorageManager.getSessionStopTime()!);
      sessionStopDetails[deviceName] = sessionStopTime;
      StorageManager.setSessionStopTime(jsonEncode(sessionStopDetails));
    } else {
      var sessionJson = {deviceName: sessionStopTime};
      StorageManager.setSessionStopTime(jsonEncode(sessionJson));
    }
  }

  static int? fetchSessionStopTime(String deviceName) {
    if (StorageManager.getSessionStopTime() != null) {
      Map<String, dynamic> sessionStopDetails =
          jsonDecode(StorageManager.getSessionStopTime()!);

      if (sessionStopDetails.containsKey(deviceName)) {
        return sessionStopDetails[deviceName];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
