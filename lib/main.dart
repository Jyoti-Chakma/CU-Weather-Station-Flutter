import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MaterialApp(
      title: "CU Weather",
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
    ));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp;
  var feels_like;
  var description;
  var weather;
  var humidity;
  var windSpeed;
  var location;

  Future getWeather(String location) async {
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=7f878c0faa2ff8b3bcd800e5e4633fe5");

    if (response.statusCode != 200) {
      throw Exception();
    } else {
      var results = jsonDecode(response.body);
      setState(() {
        this.temp = results['main']["temp"];
        this.feels_like = results['main']['feels_like'];
        this.description = results['weather'][0]["description"];
        this.weather = results['weather'][0]["main"];
        this.humidity = results['main']["humidity"];
        this.windSpeed = results['wind']["speed"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getWeather("Chittagong");
  }

  onTextFieldSubmitted(String input) {
    location = input;
    getWeather(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 70, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "CU Weather Station",
              style: TextStyle(fontSize: 30),
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    onSubmitted: (String input) {
                      onTextFieldSubmitted(input);
                      this.getWeather(input);
                    },
                    style: TextStyle(color: Colors.teal[400], fontSize: 25.0),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      hintText: "Search Location",
                      hintStyle:
                          TextStyle(color: Colors.teal[400], fontSize: 18.0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.teal,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 60,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.teal,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  location != null ? location.toString() : "Chittagong",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.thermometerHalf,
                          color: Colors.teal[400]),
                      title: Text(
                        "Temperature",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      trailing: Text(
                        temp != null
                            ? temp.toString() + "\u00B0"
                            : "Can't load data",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.thermometer,
                          color: Colors.teal[400]),
                      title: Text(
                        "Feels Like",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      trailing: Text(
                        feels_like != null
                            ? feels_like.toString() + "\u00B0"
                            : "Can't load data",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.cloud,
                          color: Colors.teal[400]),
                      title: Text(
                        "Weather",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      trailing: Text(
                        description != null
                            ? description.toString()
                            : "Can't load data",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    ListTile(
                      leading:
                          FaIcon(FontAwesomeIcons.sun, color: Colors.teal[400]),
                      title: Text(
                        "Humidity",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      trailing: Text(
                        humidity != null
                            ? humidity.toString() + " %"
                            : "Can't load data",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.wind,
                        color: Colors.teal[400],
                      ),
                      title: Text(
                        "Wind Speed",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      trailing: Text(
                        windSpeed != null
                            ? windSpeed.toString() + " km/h"
                            : "Can't load data",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
