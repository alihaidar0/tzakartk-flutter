import 'package:flutter/material.dart';

Widget LanguageContainerInDialog(
    String name, String flag, double height, Color color) {
  return Container(
    width: double.infinity,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: flag != null ? Image.asset(flag) : SizedBox(),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: name == null && flag == null
              ? SizedBox()
              : VerticalDivider(
                  width: 30,
                  color: color,
                  thickness: 1,
                ),
        ),
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
