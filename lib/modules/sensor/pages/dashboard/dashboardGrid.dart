import 'package:flutter/material.dart';
import 'package:rtdb/helpers/constants.dart';
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
    List<String> deviceList;
    List<String> hr;
    List<String> steps;
    List<String> acc;
    List<String> res;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
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
                  final databaseKey =
                      FirebaseDatabase.instance.ref('data/$key');

                  var metrics = snapshot.data![key]!.metricsData;
                  var sessionStatus =
                      snapshot.data![key]!.metricsData?.sessionStatus;
                  if (sessionStatus == SessionStatus.running) {
                    databaseKey.update({
                      "Beaconing Data": {
                        "hr": metrics?.hr,
                        "acc": metrics?.acceleration,
                        "StepCount": metrics?.stepCount
                      }
                    });
                  } else {
                    databaseKey.update({"Beaconing Data": "Not running"});
                  }
                }
              }
              return Text("Data from RTDB");
            }),
        const ViewData(),
      ],
    );
  }

  Widget showUnknownDevices(LiveViewData liveViewData, int index) {
    if (liveViewData.deviceStatus != null) {
      if (liveViewData.deviceStatus == IdleDeviceStatus.notRunning) {
        return Container(padding: EdgeInsets.all(15), child: Text(""));
      } else {
        return Container(padding: EdgeInsets.all(15), child: Text("offline"));
      }
    } else {
      return Container();
    }
  }
}
