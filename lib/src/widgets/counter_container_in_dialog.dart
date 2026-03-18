import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget CountryContainerInDialog(
    String name, String flag, double height, Color color) {
  return Container(
    width: double.infinity,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
