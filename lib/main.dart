import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtdb_view/constant.dart';
import 'package:rtdb_view/grid_view.dart';
import 'package:rtdb_view/storage_manager.dart';
import 'package:rtdb_view/styles.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await StorageManager.init();
  runApp(const MaterialApp(
    title: 'Conqur Live',
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String displayData = "";
  String accessId = "ACCESS";
  TextEditingController codeController = TextEditingController();
  bool _isEditingText=false;
  TextEditingController? _editingController;
  String initialText = "Tap to enter code";
  var fetchedData;
  var dataBaseAccess;
  StreamSubscription? subscr;

  @override
  void initState() {
    super.initState();
    fetchData(initialText, true);
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    _editingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size scrSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Constant().primary,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Image.asset(
                        "assets/conqur_live_logo.png",
                        height: 50,
                        width: 120,
                      ),
                    ),
                    editTitleTextField(),
                    Image.asset(
                      'assets/netrin_logo.png',
                      scale: 10,
                      height: 40,
                      width: 80,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GridViewer(scrSize, fetchedData),
          ],
        ),
      ),
    );
  }

  Widget editTitleTextField() {
    if (_isEditingText) {
      return SizedBox(
        width: 150,
        height: 35,
        child: TextField(
          maxLength: 6,
          style: TextStyle(color: Constant().cursorColor,fontSize: 18),
          cursorColor: Constant().cursorColor,
          decoration: textFieldDecoration(hintText: "code"),
          onSubmitted: (newValue) {
            fetchData(initialText, false);
            setState(() {
              initialText =
                  (newValue.isNotEmpty) ? newValue : "Tap to enter code";
              accessId = initialText;
              _isEditingText = false;
            });
            fetchData(initialText, true);
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    }
    return SizedBox(
      height: 35,
      width: 150,
      child: InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Align(
          alignment: Alignment.center,
          child: Text(initialText,
              style: TextStyle(
                color: Constant().cursorColor,
                fontSize: 18.0,
              )),
        ),
      ),
    );
  }



  void fetchData(text, bool fetch) {
    if(fetch==true) {
      setState((){
        dataBaseAccess =
            FirebaseDatabase.instance
                .ref('data/$text')
                .onValue;
        subscr= dataBaseAccess.listen((event) {
          if (event.snapshot.value != null) {
            setState(() {
              fetchedData = Map.from(event.snapshot.value as Map);
            });
          } else {
            setState(() {
              fetchedData = null;
            });
          }
        });
      });

      }
    else
      {
        subscr!.cancel();
      }
  }
}
