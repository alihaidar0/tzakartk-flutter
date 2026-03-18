import 'package:flutter/material.dart';

Widget CityContainerInDialog(String name, double height, Color color) {
  return Container(
    width: double.infinity,
    height: height,
    alignment: Alignment.centerLeft,
    child: Row(
      children: [
        Text(
          name == null ? "" : name,
          style: TextStyle(
            fontSize: height / 2,
            color: color,
          ),
        ),
      ],
    ),
  );
}
