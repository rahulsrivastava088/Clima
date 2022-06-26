import 'package:flutter/material.dart';
import 'package:clima_self/utilities/constants.dart';
import 'package:clima_self/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final weatherData;
  LocationScreen({this.weatherData});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  late int temp;
  late String weatherIcon;
  late String weatherMessage;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temp = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to access location !';
        return;
      }
      temp = weatherData['main']['temp'].toInt();
      weatherIcon =
          weatherModel.getWeatherIcon(weatherData['weather'][0]['id']);
      weatherMessage =
          '${weatherModel.getMessage(temp)} in ${weatherData['name']} !';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                    ),
                    onPressed: () async {
                      updateUI(await weatherModel.getLocationWeather());
                    },
                    child: Icon(
                      Icons.location_pin,
                      size: 50.0,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                    ),
                    onPressed: () async {
                      var typedCityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedCityName != null) {
                        updateUI(
                          await weatherModel.getCityWeather(typedCityName),
                        );
                      };
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
