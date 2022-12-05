import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:rtdb/modules/sensor/repository/ble_handler.dart';
import 'package:rtdb/modules/sensor/repository/session_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class FileWriter {
  static final FileWriter _client = FileWriter._internal();

  factory FileWriter() {
    return _client;
  }

  FileWriter._internal();

  static FileWriter get instance => _client;

  writeToFile(String text, String deviceName) async {
    final Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final File file = File(
        '${directory!.path}/hexFile${SessionHandler.fetchSessionStopTime(deviceName)}.txt');
    await file.writeAsString(text, mode: FileMode.append);
  }

  Future<String> read() async {
    String text = "";
    try {
      String directory = "";
      if (Platform.isAndroid) {
        directory = (await getExternalStorageDirectory())!.path;
      } else {
        directory = (await getApplicationDocumentsDirectory()).path;
      }

      var device = BleHandler.instance.sensorDevice!.name;

      final File file = File(
          '$directory/hexFile${SessionHandler.fetchSessionStopTime(device)}.txt');
      text = await file.readAsString();
    } catch (e) {
      log("Couldn't read file");
    }
    return text;
  }

  void fetchHexFile() {}

  void shareFile(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      var size = MediaQuery.of(context).size;

      String dir = "";

      var device = BleHandler.instance.sensorDevice!.name;

      if (Platform.isAndroid) {
        dir =
            "${(await getExternalStorageDirectory())!.path}/hexFile${SessionHandler.fetchSessionStopTime(device)}.txt";
      } else {
        dir =
            "${(await getApplicationDocumentsDirectory()).path}/hexFile${SessionHandler.fetchSessionStopTime(device)}.txt";
      }

      Share.shareFiles([dir],
          sharePositionOrigin: Rect.fromLTWH(
              0,
              0,
              size.width,
              size.height /
                  2)); //TODO need more info on this. Discussion needed.
    } else {
      await [
        Permission.storage,
      ].request();
    }
  }
}
