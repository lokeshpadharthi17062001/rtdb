import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rtdb/helpers/shared_preference.dart';

import '../../../../live_metrics/live_metrics_bloc.dart';

class ViewData extends StatefulWidget {
  final String gatewayStatus;
  final String gatewayId;

  const ViewData(
      {Key? key, required this.gatewayStatus, required this.gatewayId})
      : super(key: key);

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  String displayData = "";
  String accessId = "ACCESS";
  TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: GestureDetector(
                onTap: alertBox,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.refresh,
                      color: Color(0xFF363636),
                    ),
                    Text("RESET",
                        style: GoogleFonts.jost(
                            color: Color(0xFF333333), fontSize: 16)),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Image.asset(
                  "assets/conqur_live_logo.png",
                  height: 81,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "${widget.gatewayStatus}",
                  style:
                      GoogleFonts.jost(color: Color(0xFF333333), fontSize: 24),
                ),
                Text("${widget.gatewayId}",
                    style: GoogleFonts.jost(
                        color: Color(0xFF333333), fontSize: 24)),
                SizedBox(
                  height: 100,
                )
              ],
            ),
            Image.asset(
              'assets/netrin_logo.png',
              height: 37,
            ),
          ],
        ),
      ),
    );
  }

  void alertBox() {
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(color: Colors.grey),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Continue",
        style: TextStyle(color: Colors.grey),
      ),
      onPressed: () {
        FirebaseDatabase.instance
            .ref('data/${StorageManager.getGatewayId()}')
            .remove();
        String id = "";

        for (int i = 0; i < 6; i++) {
          var random = 65 + Random().nextInt(25);
          id += String.fromCharCode(random);
        }
        StorageManager.setGatewayId(id);
        Navigator.of(context).pop();
        LiveMetricsBloc.instance.add(const GatewayCreateEvent());
        Future.delayed(const Duration(seconds: 1), () {
          LiveMetricsBloc.instance.add(const LiveMetricsSensorLiveViewEvent());
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: const [
          Icon(
            Icons.warning,
            color: Colors.grey,
          ),
          Text(
            "Warning",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      content: const Text(
        "You are about to change the access code",
        style: TextStyle(color: Colors.grey),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
