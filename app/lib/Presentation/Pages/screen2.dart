import 'package:app/Models/EventData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayEventScreen extends StatefulWidget {
  const DisplayEventScreen({super.key});

  @override
  State<DisplayEventScreen> createState() => _DisplayEventScreenState();
}

class _DisplayEventScreenState extends State<DisplayEventScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(readData() as String),
      ),
      // body: StreamBuilder<List<EventData>>(
      //     stream: readData(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) {
      //         return const Text("Something Went Wrong ! ");
      //       } else if (snapshot.hasData) {
      //         final data = snapshot.data!;
      //         return ListView(
      //           children: data.map(buildEventData).toList(),
      //         );
      //       } else {
      //         return const Center(
      //           child: CircularProgressIndicator(
      //               color: Color.fromARGB(255, 0, 0, 0)),
      //         );
      //       }
      //     }),
    );
  }

  Widget buildEventData(EventData data) => ListTile(
        leading: Text(data.date.toString()),
        title: Text(data.text),
      );
  Stream<DocumentSnapshot<Map<String, dynamic>>> readData() =>
      FirebaseFirestore.instance
          .collection("Data")
          .doc("1TDr2kvyB1GZfkmy7AOD")
          .snapshots();
}
