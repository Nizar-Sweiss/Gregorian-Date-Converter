import 'package:flutter/material.dart';

class buildEventData extends StatelessWidget {
  const buildEventData({
    super.key,
    required this.formattedDate,
    required this.eventText,
  });

  final String formattedDate;
  final String eventText;

  @override
  Widget build(BuildContext context) {
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  }
}
