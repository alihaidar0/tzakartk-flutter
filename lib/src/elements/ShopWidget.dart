import 'package:flutter/material.dart';

import '../models/shop.dart';
import '../library/globals.dart' as globals;
import '../../generated/l10n.dart';

class ShopWidget extends StatelessWidget {
  final Shop shop;

  ShopWidget({
    Key key,
    this.shop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).focusColor.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                S.of(context).shop + ' : ',
                style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                Localizations.localeOf(context).languageCode == 'en'
                    ? shop.en_name
                    : shop.ar_name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                S.of(context).country + ' : ',
                style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                Localizations.localeOf(context).languageCode == 'en'
                    ? "${globals.country.en_name}"
                    : "${globals.country.ar_name}",
                style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                S.of(context).city + ' : ',
                style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                Localizations.localeOf(context).languageCode == 'en'
                    ? "${globals.city.en_name}"
                    : "${globals.city.ar_name}",
                style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                S.of(context).address + ' : ',
                style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                Localizations.localeOf(context).languageCode == 'en'
                    ? shop.en_description
                    : shop.ar_description,
                style: Theme.of(context).textTheme.headline6.merge(
                  TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
