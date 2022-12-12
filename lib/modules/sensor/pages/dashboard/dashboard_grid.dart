import 'package:flutter/material.dart';
import 'package:rtdb/helpers/constants.dart';
import 'package:rtdb/helpers/shared_preference.dart';
import 'package:rtdb/modules/sensor/models/live_view_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_database/firebase_database.dart';

import 'card/viewdata.dart';

enum IdleDeviceStatus { offline, notRunning }

class DashboardGrid extends StatelessWidget {
  final BehaviorSubject<Map<String, LiveViewData>?> unKnownDeviceStream;

  const DashboardGrid({Key? key, required this.unKnownDeviceStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Column(
              children: [
                UnKnownDevicesGrid(
                  unKnownDeviceStream: unKnownDeviceStream,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UnKnownDevicesGrid extends StatelessWidget {
  final BehaviorSubject<Map<String, LiveViewData>?> unKnownDeviceStream;

  UnKnownDevicesGrid({Key? key, required this.unKnownDeviceStream})
      : super(key: key);

  String displayData = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<Map<String, LiveViewData>?>(
            stream: unKnownDeviceStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (var key in snapshot.data!.keys) {
                  final databaseKey = FirebaseDatabase.instance.ref(
                      'data/${StorageManager.getGatewayId()}/${key.substring(10)}');

                  var metrics = snapshot.data![key]!.metricsData;
                  Duration sessionDuration =
                      Duration(seconds: metrics?.relativeTime ?? 0);
                  var sessionStatus =
                      snapshot.data![key]!.metricsData?.sessionStatus;
                  if (sessionStatus == SessionStatus.running) {
                    // print(snapshot.data![key]!.metricsData!.relativeTime);
                    databaseKey.update({
                      "beaconData": {
                        "sessionActive": true,
                        "metrics": {
                          "movementLoad": metrics?.acceleration,
                          "heartRate": metrics?.hr,
                          "stepCount": metrics?.stepCount,
                          "rssi": snapshot.data![key]!.device.rssi,
                          "battery": metrics?.battery,
                          "relativeTime":
                              "${sessionDuration.inHours}h ${sessionDuration.inMinutes % 60}m ${sessionDuration.inSeconds % 60}s",
                        },
                      },
                      "lastUpdatedTime": DateTime.now().millisecondsSinceEpoch,
                    });
                  } else {
                    databaseKey.update({
                      "beaconData": {
                        "sessionActive": false,
                        "metrics": {},
                      },
                      "lastUpdatedTime": DateTime.now().millisecondsSinceEpoch,
                    });
                  }
                }
              }
              return Container();
            }),
        ViewData(gatewayStatus: "Gateway running",gatewayId: "${StorageManager.getGatewayId()}",),
      ],
    );
  }
}
