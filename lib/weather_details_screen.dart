import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'weather_model.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherDetailsScreen extends StatefulWidget {
  @override
  _WeatherDetailsScreenState createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late Weather _weather;
  bool _isRefreshing = false;
DateTime? _sunrise, _sunset;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherData = ModalRoute.of(context)?.settings.arguments as Weather?;
      if (weatherData != null) {
        _weather = weatherData;
        _fetchInitialWeatherData();
      } else {
         if (mounted) {
        // If no weather data is passed, initialize with a default city name
        _weather = Weather(
          cityName: 'Default City',
          temperature: 0.0,
          weatherCondition: 'Unknown',
          humidity: 0,
          windSpeed: 0.0,
          weatherIcon: '01d',
        );
        _fetchInitialWeatherData();
      }
        _fetchInitialWeatherData();
      }
    });
  }

  Future<void> _fetchInitialWeatherData() async {
    await _fetchUpdatedWeatherData(_weather.cityName);
  }

  Future<Weather> _fetchUpdatedWeatherData(String cityName) async {
    try {
      setState(() {
        _isRefreshing = true; // Show circular progress indicator
      });

      final updatedWeather = await _fetchWeatherData(cityName);
      setState(() {
        _weather = updatedWeather;
        _isRefreshing = false; // Hide circular progress indicator
      });
      return updatedWeather;
    } catch (e) {
      setState(() {
        _isRefreshing = false; // Hide circular progress indicator on error
      });
      print('Error fetching updated weather data: $e');
      rethrow; // Rethrow the exception
    }
  }
  Future<Weather> _fetchWeatherData(String cityName) async {
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
    final apiKey = 'e24cc91a1fcee1a96cde1de5292f1a4c';
    final url = Uri.parse('$apiUrl?q=$cityName&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather(
        cityName: data['name'],
        temperature: data['main']['temp'].toDouble(),
        weatherCondition: data['weather'][0]['description'],
        humidity: data['main']['humidity'].toDouble(),
        windSpeed: data['wind']['speed'].toDouble(),
        weatherIcon: data['weather'][0]['icon'],
      );
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
void _getSunriseAndSunset() async {
  final apiUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final apiKey = 'e24cc91a1fcee1a96cde1de5292f1a4c';
  final url = Uri.parse('$apiUrl?q=${_weather.cityName}&appid=$apiKey&units=metric');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final sunriseTimestamp = data['sys']['sunrise'];
    final sunsetTimestamp = data['sys']['sunset'];
    final timezone = data['timezone'];

    // Convert sunrise and sunset timestamps to local time based on timezone
    _sunrise = DateTime.fromMillisecondsSinceEpoch((sunriseTimestamp + timezone) * 1000);
    _sunset = DateTime.fromMillisecondsSinceEpoch((sunsetTimestamp + timezone) * 1000);
  } else {
    print('Error fetching sunrise and sunset data: ${response.statusCode}');
  }
}

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isDaytime = now.isAfter(_sunrise ?? DateTime(0)) && now.isBefore(_sunset ?? DateTime(0));
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
               Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(isDaytime
                        ? 'assets/images/day_bg.jpg'
                        : 'assets/images/night_bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Positioned.fill(
                    //   child: Container(
                    //     color: Colors.black.withOpacity(0.4),
                    //   ),
                    // ),
                    // BackdropFilter(
                    //   //filter: ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    //   child: Container(
                    //     color: Colors.transparent,
                    //   ),
                    // ),
                    Positioned(
                      top: 30.0,
                      left: 10.0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(constraints.maxWidth > 600 ? 20.0 : 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Card(
      elevation: 4.0,
      color: Colors.transparent.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://openweathermap.org/img/w/${_weather.weatherIcon}.png',
              
              scale: 0.2,
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_weather.cityName}',
                  style: GoogleFonts.lato(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${_weather.temperature} °C',
                  style: GoogleFonts.lato(
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${_weather.weatherCondition}',
                  style: GoogleFonts.lato(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Humidity: ${_weather.humidity}%',
                  style: GoogleFonts.lato(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Wind Speed: ${_weather.windSpeed} m/s',
                  style: GoogleFonts.lato(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ],
),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isRefreshing)
              Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _fetchUpdatedWeatherData(_weather.cityName);
                },
                
                label: Text(
                  'Refresh',
                  style: TextStyle(
                    color: isDaytime ? Colors.white : Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDaytime ? Colors.blue : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}}