import 'package:app/Presentation/Widgets/build_Event_Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayEventScreen extends StatefulWidget {
  const DisplayEventScreen({Key? key}) : super(key: key);

  @override
  State<DisplayEventScreen> createState() => _DisplayEventScreenState();
}

class _DisplayEventScreenState extends State<DisplayEventScreen> {
  late Stream<QuerySnapshot> _eventsStream;

  @override
  void initState() {
    super.initState();
    _eventsStream = FirebaseFirestore.instance.collection('Data').snapshots();
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance.collection('Data').doc(eventId).delete();
      // Show a success message or perform any additional actions
    } catch (e) {
      // Handle the error
      print('Error deleting event: $e');
    }
  }

  Future<void> _updateEvent(String eventId, String updatedText) async {
    try {
      await FirebaseFirestore.instance
          .collection('Data')
          .doc(eventId)
          .update({'text': updatedText});
      // Show a success message or perform any additional actions
    } catch (e) {
      // Handle the error
      print('Error updating event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _eventsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No events found.'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            DateTime dateTime = DateTime.parse(document['date']);
            String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
            String eventText = document['text'];
            String eventId = document.id;

            return Dismissible(
              key: Key(eventId),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) => _deleteEvent(eventId),
              child: Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(formattedDate),
                  subtitle: Text(eventText),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditDialog(eventId, eventText),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showEditDialog(String eventId, String currentText) async {
    String updatedText = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController textEditingController =
            TextEditingController(text: currentText);
        return AlertDialog(
          title: Text('Edit Event'),
          content: TextField(
            controller: textEditingController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(currentText);
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(textEditingController.text);
              },
            ),
          ],
        );
      },
    );
    if (updatedText != null && updatedText != currentText) {
      _updateEvent(eventId, updatedText);
    }
  }
}
