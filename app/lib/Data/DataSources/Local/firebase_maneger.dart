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
}
