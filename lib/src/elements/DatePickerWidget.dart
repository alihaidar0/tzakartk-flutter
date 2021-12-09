import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

// ignore: must_be_immutable
class DatePickerWidget extends StatelessWidget {
  DateTime deliveryDay;
  ValueChanged<DateTime> onChanged;

  DatePickerWidget({
    this.deliveryDay,
    this.onChanged,
    Key key,
  }) : super(key: key);

  String getText(DateTime) {
    if (DateTime == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd/MM/yyyy').format(DateTime);
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 2);
    final newDate = await showDatePicker(
      context: context,
      initialDate: this.deliveryDay ?? initialDate,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 2),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (newDate == null)
      return null;
    else {
      return newDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).hintColor.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              getText(deliveryDay),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            ButtonTheme(
              padding: EdgeInsets.all(0),
              minWidth: 50.0,
              height: 10.0,
              child: MaterialButton(
                elevation: 0,
                onPressed: () => pickDate(context).then(
                  (value) => onChanged(value),
                ),
                child: Text(
                  S.of(context).edit,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
