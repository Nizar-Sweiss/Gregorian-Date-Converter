class EventData {
  String text;
  String date;
  EventData({required this.date, required this.text});
  Map<String, dynamic> toJson() => {'text': text, 'date': date};
  static EventData fromJson(Map<String, dynamic> json) =>
      EventData(date: json['date'], text: json['text']);
}
