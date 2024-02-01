import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/model/weather.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  Position? _position;
  String? _image;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  Position? get position => _position;
  String? get image => _image;

  void fetchWeather(String cityName) async {
    // Make HTTP request to OpenWeatherMap API
    // Ensure to replace 'YOUR_API_KEY' with your actual API key
    final apiKey = '';
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=c36d00a1ade6f97e5f7d9861c3dff92c'));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      _weather = Weather(
          cityName: weatherData['name'],
          temperature: (weatherData['main']['temp'] - 273.15),
          condition: (weatherData['weather'][0]['description']));
      notifyListeners();
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> fetchWeatherByLocation() async {
    try {
      _isLoading = true;
      notifyListeners();

      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final apiKey = 'YOUR_API_KEY';
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position?.latitude}&lon=${position?.longitude}&appid=c36d00a1ade6f97e5f7d9861c3dff92c'));
      print(response.body);
      final a =
          'http://maps.googleapis.com/maps/api/staticmap?center=${position?.latitude},${position?.longitude}=&zoom=100&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${position?.latitude},${position?.longitude}&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag';
      _image = a;
      if (response.statusCode == 200) {
        final weatherData = json.decode(response.body);
        _weather = Weather(
            cityName: weatherData['name'],
            temperature: (weatherData['main']['temp'] - 273.15),
            condition: (weatherData['weather'][0]['description']));
        notifyListeners();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // Handle errors, e.g., location services are disabled
      print('Error fetching location: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
