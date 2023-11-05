import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_mobile/models/weather_model.dart';
import 'package:weather_mobile/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("YOUR_API_KEY_HERE");

  Weather? _weather;
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String _getWeatherCondition(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json";

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return "assets/cloudy.json";
      case 'drizzle':
      case 'rain':
      case 'shower rain':
        return "assets/sunny_rain.json";
      case 'thunderstorm':
        return "assets/thunder_rain.json";
      case 'clear':
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  @override
  void initState() {
    _fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 39, 39, 39),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(
                  Icons.location_pin,
                  color: Color.fromARGB(255, 161, 161, 161),
                ),
                Text(
                  _weather?.cityName.toUpperCase() ?? "loading city...",
                  style: GoogleFonts.anton(
                    fontSize: 40,
                    color: Color.fromARGB(255, 161, 161, 161),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  _weather?.mainCondition ?? "",
                  style: GoogleFonts.oswald(
                      fontSize: 25, color: Color.fromARGB(255, 161, 161, 161)),
                ),
                Lottie.asset(_getWeatherCondition(_weather?.mainCondition)),
              ],
            ),
            Column(
              children: [
                Text(
                  "${_weather?.temperature.round()}ºC",
                  style: GoogleFonts.anton(
                    fontSize: 30,
                    color: Color.fromARGB(255, 161, 161, 161),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
