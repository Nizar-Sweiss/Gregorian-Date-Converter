import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Data').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Show a loading indicator
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            DateTime dateTime = DateTime.parse(document['date']);
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            String eventText = document['text'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Text(
                      formattedDate.substring(8, 10),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  title: Text(
                    formattedDate,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    eventText,
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Handle list item tap
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
