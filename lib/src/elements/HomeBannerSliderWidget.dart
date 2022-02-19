import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../elements/CircularLoadingWidget.dart';

class HomeBannerSliderWidget extends StatefulWidget {
  final List<String> slides;

  @override
  _HomeBannerSliderWidgetState createState() => _HomeBannerSliderWidgetState();

  HomeBannerSliderWidget({Key key, this.slides}) : super(key: key);
}

class _HomeBannerSliderWidgetState extends State<HomeBannerSliderWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return widget.slides == null || widget.slides.isEmpty
        ? CircularLoadingWidget(height: 140)
        : CarouselSlider(
            options: CarouselOptions(
              autoPlay: widget.slides.length > 1 ? true : false,
              autoPlayInterval: Duration(seconds: 7),
              height: 140,
              viewportFraction: 0.6,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: widget.slides.map((String slide) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    width: 250,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.15),
                            blurRadius: 15,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: slide,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
  }
}
