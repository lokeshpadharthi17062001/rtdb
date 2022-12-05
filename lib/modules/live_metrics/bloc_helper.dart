import 'dart:math';

import 'package:rtdb/helpers/constants.dart';

class BlocHelper {
  static List<int> getSensorCurrentTime() {
    var currentTimeSeconds =
        (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).round();

    var hexValue =
        currentTimeSeconds.toRadixString(16).padLeft(2, '0').toUpperCase();

    var listBytes = hexToIntList(hexValue);

    var command = commandToString[SensorCommand.time]!.codeUnits[0];

    listBytes.insert(0, command);

    return listBytes;
  }

  static List<int> hexToIntList(String hex) {
    if (hex.length % 2 != 0) {
      throw 'Odd number of hex digits';
    }

    List<int> result = [];

    for (var i = 0; i < 4; ++i) {
      var x = int.parse(hex.substring(i * 2, (2 * (i + 1))), radix: 16);
      if (x.isNaN) {
        throw 'Expected hex string';
      }
      result.add(x);
    }

    return result;
  }

  static List<int> getTokenValue() {
    Random random = Random();

    int command = commandToString[SensorCommand.token]!.codeUnits[0];
    int randomNumber1 = random.nextInt(255);
    int randomNumber2 = random.nextInt(255);
    int randomNumber3 = random.nextInt(255);
    int randomNumber4 = random.nextInt(255);

    List<int> result = [];

    result.add(command);
    result.add(randomNumber1);
    result.add(randomNumber2);
    result.add(randomNumber3);
    result.add(randomNumber4);

    return result;
  }

  static bool isSensorSerialValid(String serialNumber) {
    if (serialNumber.isEmpty) return false;
    if (serialNumber.length != 12) return false;
    if (serialNumber.contains(RegExp('[0-9]{12}'))) return true;
    return false;
  }
}
