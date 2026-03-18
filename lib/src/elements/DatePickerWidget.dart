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
      return DateFormat('dd/MM/yyyy   hh:mm  a').format(DateTime);
    }
  }

  Future pickDay(BuildContext context) async {
    final initialDate = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    final newDate = await showDatePicker(
      context: context,
      initialDate: this.deliveryDay ?? initialDate,
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (newDate == null)
      return null;
    else {
      return newDate;
    }
  }

  Future pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute,
      ),
    );
    if (newTime == null)
      return DateTime.now();
    else {
      return newTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                onPressed: () {
                  pickDay(context).then(
                    (day) {
                      pickTime(context).then(
                        (time) {
                          onChanged(
                            DateTime(
                              day.year,
                              day.month,
                              day.day,
                              time.hour,
                              time.minute,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
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
