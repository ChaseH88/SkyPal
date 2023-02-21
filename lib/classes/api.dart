import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class API {
  static const String _baseUrl = 'http://192.168.1.203:4001';
  static String _apiKey = '';
  final cacheManager = CacheManager(
    Config(
      'weather_data_cache',
      stalePeriod: Duration(minutes: 10), // change to 1 minute in production
      maxNrOfCacheObjects: 20,
    ),
  );

  API() {
    dotenv.load().then((value) {
      _apiKey = dotenv.env['API_KEY'];
    });
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': _apiKey,
      };

  Future<Map<String, dynamic>> getWeather({
    double latitude,
    double longitude,
    bool dropCache = false,
  }) async {
    final url =
        Uri.parse('$_baseUrl/dummy?latitude=$latitude&longitude=$longitude');

    if (dropCache) {
      // Delete the cached response if dropCache is true
      print("========== DROP CACHE: $url ==========");
      await cacheManager.removeFile(url.toString());
    }

    // Try to fetch the response from cache first
    final fileInfo = await cacheManager.getFileFromCache(url.toString());
    if (fileInfo != null) {
      final file = fileInfo.file;
      final contents = await file.readAsString();
      final decodedJson = jsonDecode(contents);
      print('========== LOADED FROM CACHE ==========');
      return decodedJson;
    }

    // If cache is empty or stale, fetch the response from the network and cache it
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      await cacheManager.putFile(url.toString(), response.bodyBytes);
      print('========== LOADED FROM NETWORK ==========');
      return decodedJson;
    }

    return null;
  }
}
