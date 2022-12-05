import 'dart:developer';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rtdb/helpers/constants.dart';
import 'package:rtdb/modules/live_metrics/models/models.dart';
import 'package:rtdb/modules/sensor/models/clocking_info.dart';
import 'package:rtdb/modules/sensor/models/live_view_data.dart';
import 'package:rtdb/modules/sensor/models/metrics_data.dart';
import 'package:rtdb/modules/sensor/repository/app_devices.dart';
import 'package:rtdb/modules/sensor/repository/master_clock.dart';

class BeaconDecoder {
  static bool isBeaconResponse(String hex) {
    return (hex.isNotEmpty && hex.length == kBeaconResponseStringLength);
  }

  static BeaconResponse parseBeaconResponse(String hex) {
    String command = hex.substring(0, 4);
    int battery = int.parse(hex.substring(5, 6), radix: 16);
    String sensorToken = hex.substring(10, 12) +
        hex.substring(12, 14) +
        hex.substring(14, 16) +
        hex.substring(16, 18);

    int relativeTime = int.parse(hex.substring(6, 10), radix: 16);
    int rr = int.parse(hex.substring(18, 22), radix: 16);
    int hr = ((60 * 1000) ~/ rr).toInt();
    int acceleration = int.parse(hex.substring(22, 26), radix: 16);
    int stepCount = int.parse(hex.substring(26, 28), radix: 16);

    return BeaconResponse(
        command: command,
        relativeTime: relativeTime,
        sensorToken: sensorToken,
        hr: hr.isNaN ? 0 : hr,
        acceleration: acceleration,
        stepCount: stepCount,
        battery: battery);
  }

  static LiveViewData beaconDataHandler(String hex, DiscoveredDevice device) {
    MasterClock.instance.setInitialTime();

    MetricsData metricsData = fetchMetricsData(hex);

    ClockingInfo clockingInfo = fetchClockingInfo(device);

    return LiveViewData(
        metricsData: metricsData, clockingInfo: clockingInfo, device: device);
  }

  static LiveViewData idleDeviceDataHandler(DiscoveredDevice device) {
    MasterClock.instance.setInitialTime();

    ClockingInfo clockingInfo = fetchClockingInfo(device);

    return LiveViewData(clockingInfo: clockingInfo, device: device);
  }

  static MetricsData fetchMetricsData(String hex) {
    String command = hex.substring(0, 4);
    String sensorToken = hex.substring(10, 12) +
        hex.substring(12, 14) +
        hex.substring(14, 16) +
        hex.substring(16, 18);

    int relativeTime = int.parse(hex.substring(6, 10), radix: 16);
    int rr = int.parse(hex.substring(18, 22), radix: 16);
    int hr = rr == 0 ? 0 : ((60 * 1000) ~/ rr).toInt();
    int acceleration = int.parse(hex.substring(22, 26), radix: 16);
    int stepCount = int.parse(hex.substring(26, 30), radix: 16);
    int battery = int.parse(hex.substring(5, 6), radix: 16) * 10;

    bool isDataAvailable = command == "FEFE" ? true : false;

    int nibble = int.parse(hex.substring(4, 5), radix: 16);

    PendingStatus pendingStatus =
        (nibble / 4) % 2 == 1 ? PendingStatus.pending : PendingStatus.noPending;

    SessionStatus sessionStatus = (nibble / 2).floor() % 2 == 1
        ? SessionStatus.running
        : SessionStatus.notRunning;

    SensorStatus sensorStatus = (nibble / 1).floor() % 2 == 1
        ? SensorStatus.running
        : SensorStatus.notRunning;

    log("SessionStatus - ${sessionStatus.name}");
    return MetricsData(
        command: command,
        sensorToken: sensorToken,
        sensorStatus: sensorStatus,
        sessionStatus: sessionStatus,
        pendingStatus: pendingStatus,
        relativeTime: relativeTime,
        rr: rr,
        hr: hr,
        acceleration: acceleration,
        stepCount: stepCount,
        isDataAvailable: isDataAvailable,
        battery: battery);
  }

  static ClockingInfo fetchClockingInfo(DiscoveredDevice device) {
    DateTime latencyTime = DateTime.now();

    Duration latency = emptyDuration;

    var devices = AppDevices.instance.unknownDevices;

    if (devices[device.name]?.clockingInfo.latencyTime != null) {
      latency = latencyTime
          .difference(devices[device.name]!.clockingInfo.latencyTime);
    } else {
      latency = emptyDuration;
    }

    return ClockingInfo(latency: latency, latencyTime: latencyTime);
  }
}

Duration emptyDuration = const Duration(seconds: 0);
