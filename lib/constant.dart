import 'dart:ui';

class Constant {
  Color primary = const Color(0xFFC40000);
  Color cursorColor = const Color(0xFFFFFFFF).withOpacity(0.25);
  List<Color> zoneColor = const [
    Color(0xFFDEDEDE),
    Color(0xFF646464),
    Color(0xFF00B1DB),
    Color(0xFF00BC0B),
    Color(0xFFEABF00),
    Color(0xFFD00000)
  ];
}

int zone(int hr, int age) {
  var mhr = 210 - (0.65 * age);

  var hrPercent = getPercentage(hr, mhr);
  if (hrPercent <= 50) {
    return 0;
  } else if (hrPercent > 50 && hrPercent <= 60) {
    return 1;
  } else if (hrPercent > 60 && hrPercent <= 70) {
    return 2;
  } else if (hrPercent > 70 && hrPercent <= 80) {
    return 3;
  } else if (hrPercent > 80 && hrPercent <= 90) {
    return 4;
  }
  return 5;
}

getPercentage(int hr, double mhr) {
  return (hr / mhr) * 100;
}

String batteryStatus(int battery) {
  if (battery < 60) {
    return "Low";
  } else if (battery > 80) {
    return "High";
  }
  return "Med";
}

String network(int signal) {
  if (signal >= -70) {
    return "Good";
  } else if (signal < -90) {
    return "Poor";
  } else {
    return "Avg";
  }
}
