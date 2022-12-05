import 'package:rtdb/modules/sensor/pages/dashboard/zones.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum BleSignalLevel { good, moderate, poor }

enum BleBatteryLevel { low, average, high }

class Common {
  static String fetchDeviceName(String name) {
    return name.split(' ')[1];
  }

  static Zones fetchZoneFromHr(int hr, String age) {

    var ageValue = 30;

    if (age != null && age != "") {
      ageValue = int.parse(age);
    }

    var mhr = 210 - (0.65 * ageValue);

    var hrPercent = getPercentage(hr, mhr);

    /* ZONE 0 */
    if (hrPercent <= 50) {
      return Zones.zone_0;
    }

    /* ZONE 1 */

    else if (hrPercent > 50 && hrPercent <= 60) {
      return Zones.zone_1;
    }

    /* ZONE 2 */

    else if (hrPercent > 60 && hrPercent <= 70) {
      return Zones.zone_2;
    }

    /* ZONE 3 */

    else if (hrPercent > 70 && hrPercent <= 80) {
      return Zones.zone_3;
    }

    /* ZONE 4 */

    else if (hrPercent > 80 && hrPercent <= 90) {
      return Zones.zone_4;
    }

    /* ZONE 5 */

    else if (hrPercent > 90) {
      return Zones.zone_5;
    }

    /* ZONE 1 */

    else {
      return Zones.zone_1;
    }
  }

  static getPercentage(int hr, double mhr) {
    return (hr / mhr) * 100;
  }

  static BleSignalLevel fetchSignalLevel(int signal) {
    /* GOOD BLE SIGNAL */

    if (signal >= -70) {
      return BleSignalLevel.good;
    }

    /* MODERATE BLE SIGNAL */

    else if (signal < -70 && signal >= -90) {
      return BleSignalLevel.moderate;
    }

    /* POOR BLE SIGNAL */

    else {
      return BleSignalLevel.poor;
    }
  }

  static BleBatteryLevel fetchBatteryLevel(int battery) {
    /* LOW BATTERY SIGNAL */

    if (battery < 60) {
      return BleBatteryLevel.low;
    }

    /* AVERAGE BATTERY SIGNAL */

    else if (battery >= 60 && battery <= 80) {
      return BleBatteryLevel.average;
    }

    /* HIGH BLE SIGNAL */

    else {
      return BleBatteryLevel.high;
    }
  }

  static String getDateFromTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var dateTime = DateFormat("dd MMM yyyy , hh:mm:ss").format(date);
    return dateTime;
  }

  String getTimeDifference(DateTime startTime, DateTime endTime) {
    var duration = startTime.difference(endTime);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m ${twoDigitSeconds}s";
  }

  static String getDeviceDuration(Duration duration) {
    return "${duration.inHours} h ${duration.inMinutes % 60} m ${duration.inSeconds % 60} s";
  }

  static InputDecoration numSearch = InputDecoration(
    hintStyle: const TextStyle(color: Colors.black26),
    suffixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10)),
  );
}
