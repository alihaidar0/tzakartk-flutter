import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatelessWidget {
  Category category;
  bool selected;
  final Function(String) onTap;

  CategoriesCarouselItemWidget({
    Key key,
    this.category,
    this.selected,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        onTap(category.id);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 5),
          Hero(
            tag: category.id,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(color: Colors.black12, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: selected != null && selected
                          ? Colors.black45
                          : Colors.white,
                      blurRadius: 5.0,
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: category.image.url.toLowerCase().endsWith('.svg')
                    ? SvgPicture.network(
                        category.image.url,
                        color: Theme.of(context).accentColor,
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: category.image.icon,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            Localizations.localeOf(context).languageCode == "en"
                ? category?.en_name ?? ''
                : category?.ar_name ?? '',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
