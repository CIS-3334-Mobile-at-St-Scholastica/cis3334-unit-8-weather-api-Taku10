import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data_models/weather_model.dart';



class MyRestAPI{

  Future<List<DailyForcast>> fetchWeatherForcast() async {
    final response = await http
        .get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=duluth&units=imperial&cnt=8&appid=5aa6c40803fbb300fe98c6728bdafce7'));
    //print("Response = "+response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print("Parsing team data");
      WeatherModel list = weatherModelFromJson(response.body);
      //Baseball_Teams list = Baseball_Teams.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      //print("list copyright = "+list.copyright);
      //print("list size = "+list.teams.length.toString());
      return list.list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //print("Team Response Error "+response.statusCode.toString());
      throw Exception('Failed to load teams');
    }
  }






}