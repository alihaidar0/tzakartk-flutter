import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../elements/CircularLoadingWidget.dart';

class OurNewCarouselWidget extends StatelessWidget {
  final List<String> slides;

  OurNewCarouselWidget({Key key, this.slides}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.slides == null || this.slides.isEmpty
        ? CircularLoadingWidget(height: 110)
        : CarouselSlider(
            options: CarouselOptions(
              autoPlay: this.slides.length > 1 ? true : false,
              autoPlayInterval: Duration(seconds: 7),
              height: 110,
              viewportFraction: 0.5,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {},
            ),
            items: this.slides.map((String slide) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    width: 220,
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
