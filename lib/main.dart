import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/WeatherProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => WeatherProvider(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(' '),
        ),
        body: Center(
          child: Column(children: [
            Text(
              'Weather',
              style: TextStyle(fontSize: 20.0),
            ),
            Consumer<WeatherProvider>(
              builder: (context, weatherProvider, child) {
                final weather = weatherProvider.weather;
                final LatLng = weatherProvider.position;
                final image = weatherProvider.image;
                print(image.toString());
                if (weather != null && image != null) {
                  return Column(
                    children: [
                      Text(weather.cityName),
                      Text(weather.temperature.toString()),
                      Text(weather.condition),
                      Text('${LatLng?.latitude} & ${LatLng?.longitude}'),
                      Container(
                        height: 300.0,
                        width: 600.0,
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<WeatherProvider>(context, listen: false)
                    .fetchWeatherByLocation();
              },
              child: Text('Get Weather'),
            ),
          ]),
        ));
  }
}
