import 'dart:async';

import 'package:rtdb/helpers/constants.dart';
import 'package:rtdb/modules/sensor/models/sensor_info_data.dart';
import 'package:rtdb/modules/sensor/repository/commander.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


class BleHandler {
  static final BleHandler _client = BleHandler._internal();

  factory BleHandler() {
    return _client;
  }

  BleHandler._internal();

  static BleHandler get instance => _client;

  DiscoveredDevice? sensorDevice;

  StreamSubscription<BleStatus>? bleStatus;

  StreamSubscription<DiscoveredDevice>? scanSubscription;

  StreamSubscription<ConnectionStateUpdate>? connectionSubscription;

  FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();

  SensorInfoData? sensorInfoData;

  Commander? commander;

  bool isSyncBackClicked = false;

  StreamSubscription<BleStatus>? bleStatusListener() {
    bleStatus = flutterReactiveBle.statusStream.listen(null);
    return bleStatus;
  }

  void connectToDevice(String deviceId) {
    connectionSubscription = flutterReactiveBle
        .connectToAdvertisingDevice(
            id: deviceId,
            withServices: [],
            prescanDuration: const Duration(seconds: 5),
            servicesWithCharacteristicsToDiscover: {
              serviceUUID: [rxCharUUID, txCharUUID]
            },
            connectionTimeout: const Duration(seconds: 10))
        .listen(null);
  }

  void scanForDevices() {
    scanSubscription =
        flutterReactiveBle.scanForDevices(withServices: []).listen((event) {});
  }

  void dispose() {
    flutterReactiveBle.deinitialize();
    connectionSubscription = null;
    scanSubscription = null;
    sensorDevice = null;
    sensorInfoData = null;
  }
}
