import '../Presentation/Pages/date_convertor_class.dart';
import 'package:intl/intl.dart';

class DateFormater {
  static DateTime formatHijriDate(String hijridate) {
    List<String> dateParts = hijridate.split('-');

    int year = int.parse(dateParts[2]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[0]);
    DateTime formatedHijriDate = DateTime(year, month, day);
    return formatedHijriDate;
  }

  static String dateFormater() {
    String dateString = today.toString().split(" ")[0];
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateTime date = inputFormat.parse(dateString);
    var formate1 = "${date.day}-${date.month}-${date.year}";

    return formate1;
  }
}
