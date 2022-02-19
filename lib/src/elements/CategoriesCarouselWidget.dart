import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';
import 'CategoriesCarouselItemWidget.dart';

// ignore: must_be_immutable
class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;
  List<bool> selected;
  final Function(String, int) onPressed;

  CategoriesCarouselWidget({
    Key key,
    this.categories,
    this.selected,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : CarouselSlider.builder(
            options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              autoPlay: this.categories.length > 1 ? true : false,
              autoPlayInterval: Duration(seconds: 3),
              height: 150,
              initialPage: 1,
              enableInfiniteScroll: false,
              disableCenter: true,
              viewportFraction: 0.33,
            ),
            itemCount: this.categories.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              double _marginLeft = 0;
              return CategoriesCarouselItemWidget(
                marginLeft: _marginLeft,
                category: this.categories.elementAt(itemIndex),
                selected: selected[itemIndex],
                onTap: (String categoryId) {
                  onPressed(categoryId, itemIndex);
                },
              );
            },
          );
  }
}
