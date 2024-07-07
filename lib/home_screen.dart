import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_api_service.dart';
import 'weather_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  late List<String> _recentCities;
  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _loadRecentCities();
  }

  void _loadRecentCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recentCities = prefs.getStringList('recentCities') ?? [];
    setState(() {
      _filteredCities = _recentCities;
    });
  }

  void _saveRecentCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recentCities.remove(city); // Remove if already exists
    _recentCities.insert(0, city); // Insert at the beginning
    if (_recentCities.length > 5) {
      _recentCities.removeLast(); // Limit to 5 recent cities
    }
    prefs.setStringList('recentCities', _recentCities);
    setState(() {
      _filteredCities = _recentCities;
    });
  }

  void _searchWeather(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final weatherApi = WeatherApiService();
    final response = await weatherApi.getWeatherData(_cityController.text);

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      Weather weather = Weather(
        cityName: response['name'],
        temperature: response['main']['temp'].toDouble(),
        weatherCondition: response['weather'][0]['main'],
        weatherIcon: response['weather'][0]['icon'],
        humidity: response['main']['humidity'],
        windSpeed: response['wind']['speed'].toDouble(),
      );

      _saveRecentCity(weather.cityName); // Save the searched city

      Navigator.pushNamed(
        context,
        '/weather_details',
        arguments: weather,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch weather data'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cloud9.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return ErrorWidget(error);
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Opacity(
                opacity: 0.8,
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: screenSize.width * 0.6,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "WEATHER APP",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'Enter city name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _filteredCities = _recentCities.where((city) =>
                                  city.toLowerCase().startsWith(value.toLowerCase())).toList();
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        if (_filteredCities.isNotEmpty) ...[
                          Text(
                            'Recent Cities:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _filteredCities
                                .map((city) => ElevatedButton(
                                      onPressed: () {
                                        _cityController.text = city;
                                      },
                                      child: Text(city),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: 16),
                        ],
                        ElevatedButton(
                          onPressed: () => _searchWeather(context),
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            textStyle: TextStyle(fontSize: 20, color: Colors.black),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.black, width: 1.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        _isLoading
                            ? SpinKitCircle(
                                color: Colors.blue,
                                size: 50.0,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
