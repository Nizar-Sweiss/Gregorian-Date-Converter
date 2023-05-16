import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Presentation/Pages/date_convertor_class.dart';

class ConvertHijri {
  static Future<String> getHijriDate(String gregorianDate) async {
    final url = Uri.parse('http://api.aladhan.com/v1/gToH/$gregorianDate');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      hijriDate = jsonResponse['data']['hijri']['date'];
      return jsonResponse['data']['hijri']['date'];
    } else {
      throw Exception('Failed to convert date');
    }
  }
}
