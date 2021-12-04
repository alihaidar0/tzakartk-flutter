import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../elements/CircularLoadingWidget.dart';

class OurNewCarouselWidget extends StatelessWidget {
  final List<String> slides;

  OurNewCarouselWidget({Key key, this.slides}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.slides == null || this.slides.isEmpty
        ? CircularLoadingWidget(height: 170)
        : Container(
            height: 170,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListView.builder(
              itemCount: this.slides.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return Container(
                  margin: EdgeInsetsDirectional.only(start: _marginLeft, end: 20),
                  height: 170,
                  width: 250,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        blurRadius: 15,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 170,
                      width: 250,
                      fit: BoxFit.cover,
                      imageUrl: this.slides.elementAt(index),
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        height: 170,
                        width: 250,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
