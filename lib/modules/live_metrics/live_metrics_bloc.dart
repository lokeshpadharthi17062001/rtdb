import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rtdb/helpers/constants.dart';
import 'package:rtdb/modules/live_metrics/bloc_helper.dart';
import 'package:rtdb/modules/sensor/models/live_view_data.dart';
import 'package:rtdb/modules/sensor/models/local_user_profile.dart';
import 'package:rtdb/modules/sensor/pages/dashboard/dashboard_grid.dart';
import 'package:rtdb/modules/sensor/repository/app_devices.dart';
import 'package:rtdb/modules/sensor/repository/beacon_decoder.dart';
import 'package:rtdb/modules/sensor/repository/ble_handler.dart';
import 'package:rtdb/modules/sensor/repository/decoder.dart';
import 'package:rtdb/modules/sensor/repository/profile_handler.dart';
import 'package:rtdb/modules/sensor/repository/session_handler.dart';
import 'package:rxdart/rxdart.dart';

part 'live_metrics_event.dart';

part 'live_metrics_state.dart';

class LiveMetricsBloc extends Bloc<LiveMetricsEvent, LiveMetricsState> {
  static final _client = LiveMetricsBloc._internal();

  factory LiveMetricsBloc() {
    return _client;
  }

  static LiveMetricsBloc get instance => _client;

  StreamSubscription<ConnectionStateUpdate>? connectionSubscription;

  final BehaviorSubject<Map<String, LiveViewData>?> unKnownDeviceStream =
      BehaviorSubject.seeded(null);

  var headerStream = StreamController<String?>();

  Map<String, dynamic> deviceTimeLagDetails = {};

  LiveMetricsBloc._internal() : super(LiveMetricsInitialState()) {
    on<LiveMetricsSensorLiveViewEvent>((event, emit) async {
      listenBeaconForDevice();

      emit(LiveMetricsSensorLiveViewState());
    });

    on<LiveMetricsSensorStopEvent>((event, emit) async {
      stopSession();
    });
    on<BluetoothTurnedOffEvent>((event, emit) async {
      emit(BluetoothTurnedOffState());
    });
    on<LocationTurnedOffEvent>((event, emit) async {
      emit(LocationTurnedOffState());
    });
    on<BleErrorEvent>((event, emit) async {
      emit(BleErrorState());
    });
    on<GatewayCreateEvent>((event, emit) async {
      emit(GatewayCreateState());
    });
    on<LiveMetricsSensorRescanEvent>((event, emit) async {
      // rescanDevices();
    });
  }

  @override
  Future<void> close() {
    BleHandler.instance.dispose();
    return super.close();
  }

  void listenBeaconForDevice() {
    BleHandler.instance.scanForDevices();

    BleHandler.instance.scanSubscription?.onData((device) {
      showDevice(device);
    });
  }

  void showDevice(DiscoveredDevice device) {
    if (device.name.startsWith('Movesense')) {
      showDeviceDetails(device);
    }
  }

  void showDeviceDetails(DiscoveredDevice device) {
    String hex = Decoder.bytesToHex(device.manufacturerData);

    if (BeaconDecoder.isBeaconResponse(hex)) {
      showLiveViewDetails(device, hex);
    }

    /* IDLE DEVICE */

    else {
      showIdleViewDetails(device);
    }
  }

  void showIdleViewDetails(DiscoveredDevice device,
      {IdleDeviceStatus? status}) {
    LiveViewData idleViewData = BeaconDecoder.idleDeviceDataHandler(device);

    idleViewData.deviceStatus = status ?? IdleDeviceStatus.notRunning;

    if (ProfileHandler.fetchProfileDetails(device.name) != null) {
      LocalUserProfile localUserProfile =
          ProfileHandler.fetchProfileDetails(device.name)!;
      idleViewData.localUserProfile = localUserProfile;
    }

    AppDevices.instance.addUnknownDevice(idleViewData);

    updateDeviceDetails();
  }

  void showLiveViewDetails(
    DiscoveredDevice device,
    String hex,
  ) {
    LiveViewData liveViewData = BeaconDecoder.beaconDataHandler(hex, device);

    /* SESSION RUNNING */

    if (isSessionRunning(liveViewData)) {
      /* PROFILE EXISTS */

      if (ProfileHandler.fetchProfileDetails(device.name) != null) {
        LocalUserProfile localUserProfile =
            ProfileHandler.fetchProfileDetails(device.name)!;

        liveViewData.localUserProfile = localUserProfile;
      }

      AppDevices.instance.addUnknownDevice(liveViewData);

      updateDeviceDetails();
    } else {
      showIdleViewDetails(device);
    }
  }

  bool isSessionRunning(LiveViewData liveViewData) {
    return liveViewData.metricsData?.sessionStatus == SessionStatus.running;
  }

  void updateDeviceDetails() {
    unKnownDeviceStream.add(AppDevices.instance.unknownDevices);
  }

  void stopSession() {
    BleHandler.instance.commander?.stopSession();

    setSensorClock();

    SessionHandler.setSessionStopTime(DateTime.now().millisecondsSinceEpoch,
        BleHandler.instance.sensorDevice!.name);

    // setSessionStopDetails();

    Future.delayed(const Duration(milliseconds: 300), () {
      BleHandler.instance.commander?.getSensorInfo();
    });
  }

  void setSensorClock() {
    if (BleHandler.instance.sensorInfoData?.sensorDetails != null) {
      var utcTimeMilliseconds =
          BleHandler.instance.sensorInfoData!.sensorDetails.utcTime * 1000;

      var sensorTime = DateTime.fromMillisecondsSinceEpoch(utcTimeMilliseconds);

      if (sensorTime.year < 2020) {
        Future.delayed(const Duration(seconds: 1), () {
          BleHandler.instance.commander
              ?.setTime(BlocHelper.getSensorCurrentTime());
        });
      }

      /* SENSOR CLOCK SET COMPLETED */

      else {
        ///the current clock for sensor has been set
      }
    } else {
      ///Do nothing
    }
  }

  // void setSessionStopDetails() {
  //   LocalUserProfile? localUserProfile = ProfileHandler.fetchProfileDetails(
  //       BleHandler.instance.sensorDevice!.name);
  //
  //   var device = BleHandler.instance.sensorDevice!.name;
  //
  //   var sessionStopTime = SessionHandler.fetchSessionStopTime(device);
  //
  //   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
  //       SessionHandler.fetchSessionStopTime(device)!);
  //
  //   if (localUserProfile == null) {
  //     localUserProfile = LocalUserProfile(
  //         sessionData: SessionData(
  //             sessionStopTime: sessionStopTime,
  //             timeZone: dateTime.timeZoneName,
  //             appVersion: appVersion ?? "0.1.12",
  //             dateTime: dateTime.toIso8601String(),
  //             restingHr: 50,
  //             firmwareVersion: BleHandler
  //                 .instance.sensorInfoData?.sensorDetails.firmwareVersion));
  //   } else {
  //     localUserProfile.sessionData?.sessionStopTime = sessionStopTime;
  //
  //     localUserProfile.sessionData?.timeZone = dateTime.timeZoneName;
  //
  //     localUserProfile.sessionData?.dateTime = dateTime.toIso8601String();
  //
  //     localUserProfile.sessionData?.appVersion = appVersion ?? "0.1.12";
  //
  //     localUserProfile.sessionData?.firmwareVersion =
  //         BleHandler.instance.sensorInfoData?.sensorDetails.firmwareVersion;
  //   }
  //
  //   ProfileHandler.setSessionDetails(
  //       localUserProfile, BleHandler.instance.sensorDevice!.name);
  // }

  void disposeStream() {
    unKnownDeviceStream.add(null);
  }

  bool checkDataCompleted() {
    return BleHandler.instance.sensorInfoData?.sensorDetails.currentSyncRead ==
        BleHandler.instance.sensorInfoData?.sensorDetails.pendingReads;
  }

// void rescanDevices() {
//   unKnownDeviceStream.add(null);
//
//   LayoutHandler.instance.resetKnownDevices();
//
//   updateDeviceDetails();
//
//   BleHandler.instance.scanSubscription?.cancel();
//
//   add(const SensorSearchEvent());
// }
}
