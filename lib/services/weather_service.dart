import 'dart:collection';
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_mobile/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const base_url = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final respons = await http
        .get(Uri.parse("$base_url?q=$cityName&appid=$apiKey&units=metric"));

    if (respons.statusCode == 200) {
      return Weather.fromJson(jsonDecode(respons.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String? city = placemarks[0].locality;
    return city ?? "";
  }
}