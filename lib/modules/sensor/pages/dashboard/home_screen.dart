import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:rtdb/constants.dart';
import 'package:rtdb/modules/live_metrics/live_metrics_bloc.dart';
import 'package:rtdb/modules/sensor/models/local_user_profile.dart';
import 'package:rtdb/modules/sensor/pages/dashboard/dashboardGrid.dart';
import 'package:rtdb/modules/sensor/repository/ble_handler.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool splashPage = true;
  Gender gender = Gender.male;

  @override
  void initState() {
    super.initState();
    checkBleStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant().background,
      body: Container(
        color: Constant().primary,
        child: SafeArea(
          child: Container(
            color: Constant().background,
            child: SingleChildScrollView(
              child: Column(children: [
                // StreamBuilder(
                //   stream: LiveMetricsBloc.instance.headerStream.stream,
                //   builder:
                //       (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                //     if (snapshot.hasData) {
                //       if (snapshot.data.toString().isEmpty) {
                //         return Header();
                //       } else {
                //         print(snapshot.data);
                //         return Header(
                //           statusConnected: true,
                //           deviceData: snapshot.data.toString(),
                //         );
                //       }
                //     } else {
                //       return Header();
                //     }
                //   },
                // ),
                // Header(),
                BlocBuilder<LiveMetricsBloc, LiveMetricsState>(
                  bloc: LiveMetricsBloc.instance,
                  builder: (context, state) {
                    /* SensorLiveViewState */

                    if (state is LiveMetricsSensorLiveViewState) {
                      return DashboardGrid(
                          unKnownDeviceStream:
                              LiveMetricsBloc.instance.unKnownDeviceStream);
                    }

                    /* SensorLoadingState */

                    else if (state is LiveMetricsSensorLoadingState) {
                      // return const BlocFrames(
                      //   child: Loading(),
                      // );
                      return Container();
                    }

                    /*  */

                    else {
                      return Container();
                    }
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void checkBleStatus() {
    BleHandler.instance.bleStatusListener()?.onData((status) {
      switch (status) {
        case BleStatus.ready:
          print("ready");
          Future.delayed(const Duration(seconds: 1), () {
            LiveMetricsBloc.instance.add(
                const LiveMetricsSensorSearchEvent(deviceName: "212430003394"));
          });
          break;
        case BleStatus.poweredOff:
          print("off");
          ///create a screen for bluetooth powered off state
          break;
        case BleStatus.unknown:
          print("unknown");
          break;
        case BleStatus.unsupported:
          print("unsupported");
          break;
        case BleStatus.unauthorized:
          print("unauth");
          break;
        case BleStatus.locationServicesDisabled:
          print("loc off");
          // TODO: Handle this case.
          break;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
