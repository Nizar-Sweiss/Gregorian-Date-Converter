import 'package:app/Models/EventData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseManeger {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future addDataToFirebase(String text, DateTime selectedDate) async {
    final docData = FirebaseFirestore.instance.collection("Data").doc();
    final eventData = EventData(date: selectedDate.toString(), text: text);
    final json = eventData.toJson();
    await docData.set(json);
  }

  static Future<void> deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance.collection('Data').doc(eventId).delete();
      // Show a success message or perform any additional actions
    } catch (e) {
      // Handle the error
      print('Error deleting event: $e');
    }
  }

  static Future<void> updateEvent(String eventId, String updatedText) async {
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
}
