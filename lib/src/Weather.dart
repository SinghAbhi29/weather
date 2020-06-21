import 'package:flutter/material.dart';
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
