import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget CountryContainer(String name, String flag, double height, Color color) {
  return Container(
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
              child: flag != null
                  ? flag.toLowerCase().endsWith('.svg')
                      ? SvgPicture.network(
                          flag,
                        )
                      : CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: flag,
                        )
                  : SizedBox(),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: name == null && flag == null
                  ? SizedBox()
                  : VerticalDivider(
                      color: color,
                      thickness: 1,
                      width: 50,
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
        Icon(
          Icons.arrow_forward_ios_outlined,
          color: color,
          size: height / 2,
        ),
      ],
    ),
  );
}
