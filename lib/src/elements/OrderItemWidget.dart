import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../generated/l10n.dart';
import '../elements/ProductOrderItemWidget.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/route_argument.dart';

class OrderItemWidget extends StatefulWidget {
  final bool expanded;
  final Order order;

  OrderItemWidget({Key key, this.expanded, this.order}) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: widget.order.orderStatus.flag != 2 ? 1 : 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: EdgeInsets.only(top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: widget.expanded,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            '${S.of(context).order_code}: #${widget.order.order_code}'),
                        Row(
                          children: [
                            Text(
                              S.of(context).createdAt + ': ',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              DateFormat('dd-MM-yyyy | HH:mm')
                                  .format(widget.order.dateTime),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              S.of(context).delivery_day + ': ',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(widget.order.deliveryDate),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Helper.getPrice(widget.order.payment.price, context,
                            style: Theme.of(context).textTheme.headline4),
                        Text(
                          '${widget.order.payment.method}',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    children: <Widget>[
                      Column(
                        children: List.generate(
                          widget.order.productOrders.length,
                          (indexProduct) {
                            return ProductOrderItemWidget(
                                heroTag: 'mywidget.orders',
                                order: widget.order,
                                productOrder: widget.order.productOrders
                                    .elementAt(indexProduct));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Tracking',
                            arguments: RouteArgument(id: widget.order.id));
                      },
                      textColor: Theme.of(context).hintColor,
                      child: Wrap(
                        children: <Widget>[Text(S.of(context).view)],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: widget.order.orderStatus.flag != 2
                ? Theme.of(context).accentColor
                : Colors.redAccent,
          ),
          alignment: AlignmentDirectional.center,
          child: Text(
            Localizations.localeOf(context).languageCode == 'en'
                ? widget.order.orderStatus.status
                : widget.order.orderStatus.ar_status,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.caption.merge(
                TextStyle(height: 1, color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }
}
