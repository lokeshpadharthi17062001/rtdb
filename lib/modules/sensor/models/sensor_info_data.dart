import 'package:rtdb/modules/sensor/models/local_user_profile.dart';
import 'package:rtdb/modules/sensor/models/sensor_details.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SensorInfoData {
  final SensorDetails sensorDetails;
  final LocalUserProfile? localUserProfile;
  DiscoveredDevice? device;

  SensorInfoData({
    required this.sensorDetails,
    this.device,
    this.localUserProfile,
  });
}
