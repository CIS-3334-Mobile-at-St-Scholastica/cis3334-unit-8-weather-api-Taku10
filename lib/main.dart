import 'package:flutter/material.dart';
import '../data_models/weather_model.dart';
import '../services/weather_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CIS 3334 Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<DailyForcast>> futureWeatherForcasts;
  final Map<String, String> _imageMap = {
    "clear": 'graphics/sun.png',
    "clouds": 'graphics/cloud.png',
    "rain": 'graphics/rain.png'};

  @override
  void initState() {
    super.initState();
    MyRestAPI api = new MyRestAPI();
    futureWeatherForcasts = api.fetchWeatherForcast();
    
  }
  Widget weatherImage(DailyForcast f) {
    final main = (f.weather.isNotEmpty ? f.weather.first.main : '').toLowerCase();
    final assetPath = _imageMap[main] ?? 'graphics/sun.png'; // so thisa is the fallbank image
    return Image.asset(assetPath);
  }

  Widget weatherTile(DailyForcast f) {
    return ListTile(
      leading: weatherImage(f),
      title: Text("Weather for ${f.dtTxt.month}/${f.dtTxt.day} at ${f.dtTxt.hour}:00"),
      subtitle: Text(
        "${f.weather.first.description} — temp: ${f.main.temp.toStringAsFixed(0)}°",
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<DailyForcast>>(
        future: futureWeatherForcasts,
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }


          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // empty (null or empty list) → return an empty container
          final items = snapshot.data;
          if (items == null || items.isEmpty) {
            return Container();
          }

          // data
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Card(
              child: weatherTile(items[index]),
            ),
          );
        },
      )
      ,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}