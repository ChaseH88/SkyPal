import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class API {
  static const String _baseUrl = 'https://api.weatherbit.io/v2.0';
  static String _apiKey = '';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final cacheManager = CacheManager(
    Config(
      'weather_data_cache',
      stalePeriod: Duration(minutes: 10), // change to 1 minute in production
      maxNrOfCacheObjects: 20,
    ),
  );

  API() {
    dotenv.load().then((value) {
      _apiKey = dotenv.env['WEATHER_BIT_API_KEY'];
    });
  }

  Future<http.Response> getWeather({
    double latitude,
    double longitude,
    bool dropCache = false,
  }) async {
    final url = Uri.parse(
        '$_baseUrl/forecast/daily?lat=$latitude&lon=$longitude&key=$_apiKey');

    if (dropCache) {
      // Delete the cached response if dropCache is true
      await cacheManager.removeFile(url.toString());
    }

    // Try to fetch the response from cache first
    final fileInfo = await cacheManager.getFileFromCache(url.toString());
    if (fileInfo != null) {
      final file = fileInfo.file;
      final contents = await file.readAsString();
      // TODO: Fix type and convert to readable JSON
      print(contents);
      return contents;
    }

    // If cache is empty or stale, fetch the response from the network and cache it
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      await cacheManager.putFile(url.toString(), response.bodyBytes);
    }

    // TODO: Will need to return the response in desired format
    return response;
  }
}
