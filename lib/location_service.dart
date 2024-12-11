import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _ipGeolocationUrl = 'http://ip-api.com/json/';

  Future<String?> getCountryCode() async {
    try {
      final response = await http.get(Uri.parse(_ipGeolocationUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['countryCode'];
      } else {
        print('Ошибка IP Geolocation: статус ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Ошибка при запросе IP Geolocation: $e');
      return null;
    }
  }
}
