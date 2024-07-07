import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_api_service.dart';
import 'home_screen.dart';
import 'weather_details_screen.dart';

void main() {
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherApiService>(
      create: (context) => WeatherApiService(),
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/weather_details': (context) => WeatherDetailsScreen(),
        },
      ),
    );
  }
}

