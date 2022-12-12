import 'package:rtdb/modules/sensor/models/clocking_info.dart';
import 'package:rtdb/modules/sensor/models/local_user_profile.dart';
import 'package:rtdb/modules/sensor/models/metrics_data.dart';
import 'package:rtdb/modules/sensor/pages/dashboard/dashboard_grid.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class LiveViewData {
  IdleDeviceStatus? deviceStatus;
  MetricsData? metricsData;
  ClockingInfo clockingInfo;
  LocalUserProfile? localUserProfile;
  DiscoveredDevice device;
  LiveViewData(
      {this.metricsData,
      required this.clockingInfo,
      this.localUserProfile,
      required this.device,
      this.deviceStatus});
}
