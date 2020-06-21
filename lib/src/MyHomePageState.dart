import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Weather.dart';
import '../main.dart';
class MyHomePageState extends State<MyHomePage> {
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
