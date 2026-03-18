import 'package:flutter/material.dart';

Widget CityContainer(String name, double height, Color color) {
  return Container(
    width: double.infinity,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            name == null ? "" : name,
            style: TextStyle(
              fontSize: height / 2,
              color: color,
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_outlined,
          color: color,
          size: height / 2,
        ),
      ],
    ),
  );
}
