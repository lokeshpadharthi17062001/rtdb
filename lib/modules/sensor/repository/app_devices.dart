import 'dart:convert';

import 'package:rtdb/helpers/shared_preference.dart';
import 'package:rtdb/modules/sensor/models/idle_view_data.dart';
import 'package:rtdb/modules/sensor/models/live_view_data.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class AppDevices {
  static final AppDevices _client = AppDevices._internal();

  factory AppDevices() {
    return _client;
  }

  AppDevices._internal() {}

  static AppDevices get instance => _client;

  Map<String, LiveViewData> unknownDevices = {};

  int unknownDeviceIndex = 0;

  void updateUnknownDevices(LiveViewData model, DiscoveredDevice device) {
    addUnknownDevice(model);

    incrementUnknownIndex(device);
  }

  void addUnknownDevice(LiveViewData model) {
    unknownDevices[model.device.name] = model;
  }

  void incrementUnknownIndex(DiscoveredDevice device) {
    if (unknownDevices.containsKey(device.name)) {
      ///This condition is used to identify the variation of colors by adding a index to all the latency series of plots
    } else {
      unknownDeviceIndex += 1;
    }
  }

  void clearDevices() {
    unknownDevices = {};

    unknownDeviceIndex = 0;
  }

  int fetchAppDevicesCount() {
    Map<String, dynamic> deviceProfileDetails =
        jsonDecode(StorageManager.getLocalUserProfile()!);

    return deviceProfileDetails.keys.length;
  }
}
