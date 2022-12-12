import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rtdb_view/storage_manager.dart';
import 'package:rtdb_view/styles.dart';
import 'constant.dart';

class AthleteCard extends StatefulWidget {
  final Size size;
  final int index;
  final dynamic fetchedData;
  final String device;

  const AthleteCard(this.size, this.index, this.fetchedData, this.device,
      {super.key});

  @override
  State<AthleteCard> createState() => _AthleteCardState();
}

class _AthleteCardState extends State<AthleteCard> {
  Size size = Size.zero;
  bool tap = false;

  @override
  void initState() {
    size = widget.size;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var beaconData = widget.fetchedData['beaconData'];
    bool isActive = beaconData['sessionActive'];
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffCCCCCC)),
          borderRadius: BorderRadius.circular(15)),
      child: (isActive)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: deviceNameText(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            width: 100 * size.width / 1280 - 10,
                            height: 85,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Constant().zoneColor[zone(
                                      beaconData['metrics']['heartRate'], 21)],
                                  width: 1.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                width: 70 * size.width / 1280,
                                height: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constant().zoneColor[zone(
                                          beaconData['metrics']['heartRate'],
                                          21)],
                                      width: 2.5),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${beaconData['metrics']['heartRate']}",
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const Text(
                                      "BPM",
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            'ZONE ${zone(beaconData['metrics']['heartRate'], 21)}')
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 140 * size.width / 1280,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40 * size.width / 1280,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    border:
                                        Border.all(color: Color(0xffAFAFAF)),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Image.asset(
                                  'assets/stepcount.png',
                                  height: 35,
                                  width: 35 * size.width / 1280,
                                ),
                              ),
                              Container(
                                height: 40,
                                padding: EdgeInsets.only(left: 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${beaconData['metrics']['stepCount']}",
                                      style: TextStyle(
                                        // color: Constant().rowInfoColor,
                                        fontSize: 23,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "Step Count",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 140 * size.width / 1280,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40 * size.width / 1280,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    border:
                                        Border.all(color: Color(0xffAFAFAF)),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Image.asset(
                                  'assets/acc_rms.png',
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              Container(
                                height: 40,
                                padding: EdgeInsets.only(left: 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${beaconData['metrics']['movementLoad']}",
                                      style: TextStyle(
                                        // color: Constant().rowInfoColor,
                                        fontSize: 23,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "Mov. Load",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 12 * size.width / 1280,
                              height: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constant().primary),
                            ),
                            SizedBox(width: 5),
                            Text("${beaconData['metrics']['relativeTime']}",
                                style: TextStyle(
                                  color: Constant().primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: 30,
                                child: batteryLevel(
                                    beaconData['metrics']['battery'])),
                            SizedBox(
                                width: 55 * size.width / 1280,
                                height: 30,
                                child: networkStatus(
                                    beaconData['metrics']['rssi'])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: deviceNameText(),
                ),
                const Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No active session',
                          style:
                              TextStyle(color: Color(0xFFEFEFEF), fontSize: 20),
                        ))),
              ],
            ),
    );
  }

  GestureDetector deviceNameText() {
    Map mapData = json.decode(StorageManager.getUser() ?? "{}");
    String userName = "${mapData[widget.device] ?? widget.device}";
    userName=(userName=="")?widget.device:userName;
    return GestureDetector(
        onTap: () {
          setState(() {
            tap = true;
          });
        },
        child: (tap)
            ? Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 20,
                child: TextField(
                  cursorColor: Colors.black,
          decoration: textFieldDecoration(),
                controller: TextEditingController(text: userName),
                style: const TextStyle(fontSize: 15),
                autofocus: true,
                onSubmitted: (val) {
                    // if (val.isNotEmpty) {
                      String catchData = StorageManager.getUser() ?? "{}";
                      Map map = json.decode(catchData);
                      map[widget.device] = val;
                      StorageManager.setUser(json.encode(map));
                    // }
                    setState(() {
                      tap = false;
                    });
                  }),
              ),
            )
            : deviceText(widget.device));
  }

  Widget deviceText(device) {
    Map mapData = json.decode(StorageManager.getUser() ?? "{}");
    String userName = "${mapData[device] ?? widget.device}";

    return SizedBox(
      height: 20,
      child: Text(
        (userName == "") ? (widget.device) : userName,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Row networkStatus(int rssi) {
    String networkLevel = network(rssi);
    Color networkColor =
        (networkLevel == "Poor") ? Constant().primary : Color(0x0FF78797B);
    return Row(children: [
      Image.asset(
        "assets/${networkLevel.toUpperCase()}_signal.png",
        color: networkColor,
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 2, top: 5, right: 2),
        child: Text("$networkLevel",
            style: TextStyle(
              color: networkColor,
              fontSize: 10,
            )),
      )
    ]);
  }

  Row batteryLevel(int battery) {
    String level = batteryStatus(battery);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/battery$level.png",
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2, top: 4, right: 4),
            child: Text('$level',
                style: TextStyle(
                  color: (level == "Low")
                      ? Constant().primary
                      : Color(0x0FF78797B),
                  fontSize: 10,
                )),
          )
        ]);
  }
}
