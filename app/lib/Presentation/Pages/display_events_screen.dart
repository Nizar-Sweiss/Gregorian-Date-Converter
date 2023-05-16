import 'package:app/Presentation/Widgets/build_Event_Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayEventScreen extends StatefulWidget {
  const DisplayEventScreen({super.key});

  @override
  State<DisplayEventScreen> createState() => _DisplayEventScreenState();
}

class _DisplayEventScreenState extends State<DisplayEventScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Data').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Show a loading indicator
        }
        //Fetch the Data From Firebase
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            DateTime dateTime = DateTime.parse(document['date']);
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            String eventText = document['text'];

            return buildEventData(
                formattedDate: formattedDate, eventText: eventText);
          },
        );
      },
    );
  }
}
