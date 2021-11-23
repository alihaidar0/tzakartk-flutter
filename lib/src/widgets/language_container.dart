import 'package:flutter/material.dart';

Widget LanguageContainer(String name, String flag, double height) {
  return Container(
    width: double.infinity,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: height,
              child: flag != null ? Image.asset(flag) : SizedBox(),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: name == null && flag == null
                  ? SizedBox()
                  : VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                      width: 50,
                    ),
            ),
            Text(
              name == null ? "" : name,
              style: TextStyle(
                fontSize: height / 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.white,
          size: height / 2,
        ),
      ],
    ),
  );
}
