import 'package:rtdb/modules/sensor/models/clocking_info.dart';
import 'package:rtdb/modules/sensor/models/local_user_profile.dart';
import 'package:rtdb/modules/sensor/pages/dashboard/dashboard_grid.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class IdleViewData {
  IdleDeviceStatus? deviceStatus;
  DiscoveredDevice device;
  ClockingInfo clockingInfo;
  LocalUserProfile? localUserProfile;
  IdleViewData({
    this.deviceStatus,
    required this.clockingInfo,
    this.localUserProfile,
    required this.device,
  });
}
