import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/route_argument.dart';
import '../models/sub_category.dart';

// ignore: must_be_immutable
class SubCategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  SubCategory subCategory;

  SubCategoriesCarouselItemWidget({Key key, this.marginLeft, this.subCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context)
            .pushNamed('/Category',
                arguments: RouteArgument(id: subCategory.id));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: subCategory.id,
            child: Container(
              margin:
                  EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.2),
                        offset: Offset(0, 2),
                        blurRadius: 7.0)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: subCategory.image.url.toLowerCase().endsWith('.svg')
                    ? SvgPicture.network(
                        subCategory.image.url,
                        color: Theme.of(context).accentColor,
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: subCategory.image.icon,
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
          Container(
            margin: EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
            child: Text(
              Localizations.localeOf(context).languageCode == "en"
                  ? subCategory?.en_name ?? ''
                  : subCategory?.ar_name ?? '',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
