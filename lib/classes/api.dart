import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class API {
  static const String _baseUrl = 'https://api.weatherbit.io/v2.0';
  static String _apiKey = '';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  API() {
    dotenv.load().then((value) {
      _apiKey = dotenv.env['WEATHER_BIT_API_KEY'];
    });
  }

  void getWeather(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/forecast/daily?lat=$latitude&lon=$longitude&key=$_apiKey');
      final response = await http.get(url, headers: _headers);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
