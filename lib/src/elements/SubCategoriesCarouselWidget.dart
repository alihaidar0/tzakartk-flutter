import 'package:flutter/material.dart';

import '../elements/CircularLoadingWidget.dart';
import '../elements/SubCategoriesCarouselItemWidget.dart';
import '../models/sub_category.dart';

// ignore: must_be_immutable
class SubCategoriesCarouselWidget extends StatelessWidget {
  List<SubCategory> subCategories;

  SubCategoriesCarouselWidget({Key key, this.subCategories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.subCategories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : Container(
            height: 150,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListView.builder(
              itemCount: this.subCategories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return new SubCategoriesCarouselItemWidget(
                  marginLeft: _marginLeft,
                  subCategory: this.subCategories.elementAt(index),
                );
              },
            ),
          );
  }
}
