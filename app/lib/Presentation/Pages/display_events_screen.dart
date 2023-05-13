import 'package:app/Models/EventData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayEvent extends StatefulWidget {
  const DisplayEvent({super.key});

  @override
  State<DisplayEvent> createState() => _DisplayEventState();
}

class _DisplayEventState extends State<DisplayEvent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventData>>(
        stream: readData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something Went Wrong ! ");
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView(
              children: data.map(buildEventData).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 0, 0, 0)),
            );
          }
        });
  }

  Widget buildEventData(EventData data) => ListTile(
        leading: Text(data.date.toString()),
        title: Text(data.text),
      );
  Stream<List<EventData>> readData() => FirebaseFirestore.instance
      .collection("Data")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => EventData.fromJson(doc.data())).toList());
}
