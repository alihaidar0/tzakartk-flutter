import 'package:flutter/material.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

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
        : Container(
            height: 150,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListView.builder(
              itemCount: this.categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return new CategoriesCarouselItemWidget(
                  marginLeft: _marginLeft,
                  category: this.categories.elementAt(index),
                  selected: selected[index],
                  onTap: (String categoryId) {
                    onPressed(categoryId, index);
                  },
                );
              },
            ),
          );
  }
}
