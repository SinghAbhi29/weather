import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Weather'),
    );
  }
}
class Weather extends StatelessWidget {
  final Map<String, dynamic> data;
  Weather(this.data);
  Widget build(BuildContext context) {
    return new Text(
      '${data['main']['temp'].toStringAsFixed(1)} °C',
      //'${data['name']}',
      style: Theme.of(context).textTheme.display2,
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = new TextEditingController();
  Future<http.Response> _response;
  void initState() {
    super.initState();
    initWeather();
  }
  void initWeather(){
    setState(() {
      _response = http.get(
          'https://api.openweathermap.org/data/2.5/weather?q=Delhi&units=metric&APPID=14cc828bff4e71286219858975c3e89a'
      );
    });
  }
  void getWeather() {
    setState(() {
      _response = http.get(
          'https://api.openweathermap.org/data/2.5/weather?q=${searchController.text}&units=metric&APPID=14cc828bff4e71286219858975c3e89a'
      );
      FocusScope.of(context).unfocus();
      searchController.clear();

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FutureBuilder(
                future: _response,
                builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
                  if (!response.hasData)
                    return new Text('Loading...');
                  else if (response.data.statusCode != 200) {
                    return new Text('Could not connect to weather service.');
                  } else {
                    Map<String, dynamic> json = jsonDecode(response.data.body);
                    if (json['cod']==200)
                      return new Weather(json);
                    else
                      return new Text('Weather service error:');
                  }
                }
            ),
            Container(
                width: 300,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Location',
                    hintText: 'Enter Location',
                  ),
                  autofocus: false,
                )
            ),
            Container(
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: getWeather,
                )),
          ],
        ),
      ),
    );
  }
}
