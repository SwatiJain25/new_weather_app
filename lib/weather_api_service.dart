
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class WeatherApiService extends ChangeNotifier{
  static const String apiKey = 'e24cc91a1fcee1a96cde1de5292f1a4c'; // Replace with your API key

  Future<Map<String, dynamic>?> getWeatherData(String city) async {
    final Uri uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {'q': city, 'appid': apiKey, 'units': 'metric'},
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error fetching weather data: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }
}