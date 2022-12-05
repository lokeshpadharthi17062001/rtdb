import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key}) : super(key: key);

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  String displayData = "";

  // DatabaseReference ref = FirebaseDatabase.instance.ref("data");

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(displayData);
  }

  void fetchData() {
    final database = FirebaseDatabase.instance.ref('data');
    database.onValue.listen((event) {
      setState(() {
        displayData = "${event.snapshot.value}"
            .substring(1, "${event.snapshot.value}".length - 1)
            .replaceAll("Movesense", "\nMovesense");
      });
    });
  }
}
