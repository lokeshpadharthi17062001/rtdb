import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtdb/helpers/shared_preference.dart';
import 'package:rtdb/modules/sensor/pages/splash_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothAdvertise,
    Permission.bluetoothConnect,
    Permission.location,
    Permission.storage,
    Permission.camera
  ].request();

  await StorageManager.init();
  Wakelock.enable();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ConCon v1',
        theme: ThemeData.dark(),
        home: const SplashPage(),
      );
    });
  }
}
