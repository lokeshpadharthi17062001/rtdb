import 'package:flutter/material.dart';

class Constant {
  Color primary = Color(0xffAC0004);
  Color rowBackground = Color(0xffF0F0F0);
  Color background = Color(0xffF0F0F0);
  Color bpmColor = Color(0xffADADAD);
  Color greyText = Color(0xff626262);
  Color backColor = Color(0xff888A90);
  Color medColor = Color(0xff5F6164);
  Color goodColor = Color(0xffABAFB2);
  Color buttonColor = Color(0xffB7BCBF);
  Color notRunningColor = Color(0xff000000);
  Color idColor = Color(0xff000000);
  Color infoButtonTextColor = Colors.white;
  Color headerBackground = Color(0xffC40000);
  Color athleteCardBackground = Color(0xffFFFFFF);
  Color zone0 = Color(0xffDEDEDE);
  Color zone1 = Color(0xff646464);
  Color zone2 = Color(0xff00B1DB);
  Color zone3 = Color(0xff00BC0B);
  Color zone4 = Color(0xffEABF00);
  Color zone5 = Color(0xffD00000);
  Color currentHRColor = Color(0xff3C3C3C);
  Color zoneRowColor = Color(0xff909295);
  Color infoButtonBackground = Color(0xffC40000);
  Color rowInfoColor = Color(0xff3C3C3C);
  Color colorWhite = Colors.white;
  Color iconColor = Color(0xffBEBEC4);
  Color profileIdColor = Color(0xff313131);
  Color profileFieldColor = Color(0xff4141414);
  Color profileBorderColor = Color(0xffffffff);
  Color profileHintColor = Color(0xff9B9B9B);
  Color customButtonColor = Color(0xffC40000);
  Color syncBackground = Colors.white;
  Color batteryDataColor = Color(0xff000000);
  Color runningTextColor = Color(0xffC40000);
  Color sensorDataTitleColor = Color(0xff343434);
  Color sensorDataInfoColor = Color(0xffA3A3A3);
  Color swipeBackgroundColor = Color(0xff111214);
  Color swipeTextColor = Color(0xffffffff);
  Color stoppedTextColor = Color(0xffffffff);
  Color processingBackground = Colors.black;
  Color emptyCardColor = Colors.white.withOpacity(0.4);
  Color hintColor = Color(0xffEAA4A4);

  Decoration backgroundBoxDecoration = BoxDecoration(
      color: Colors.black,
      image: DecorationImage(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.dstIn),
          fit: BoxFit.cover,
          image: const AssetImage("assets/background.png")));
}
