import 'package:app/Config/Theme/colors_palets.dart';
import 'package:app/Data/DataSources/Local/firebase_maneger.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _eventsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.white_Text,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: AppColors.red_error,
                child: const Icon(Icons.delete, color: AppColors.white_Text),
              ),
              onDismissed: (_) => FireBaseManeger.deleteEvent(eventId),
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(formattedDate),
                  subtitle: Text(eventText),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
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
          title: const Text('Edit Event'),
          content: TextField(
            controller: textEditingController,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(currentText);
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(textEditingController.text);
              },
            ),
          ],
        );
      },
    );
    if (updatedText != null && updatedText != currentText) {
      FireBaseManeger.updateEvent(eventId, updatedText);
    }
  }
}
