import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/checkbox_form_field.dart';
import '../library/globals.dart' as globals;
import '../models/address.dart';

// ignore: must_be_immutable
class DeliveryAddressDialog {
  BuildContext context;
  Address address;
  ValueChanged<Address> onChanged;
  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();

  DeliveryAddressDialog({this.context, this.address, this.onChanged}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.place_outlined,
                  color: Theme.of(context).hintColor,
                ),
                SizedBox(width: 10),
                Text(
                  S.of(context).add_delivery_address,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).country,
                      style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).hintColor),
                          ),
                    ),
                    SizedBox(
                      height: 6,
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
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).city,
                      style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).hintColor),
                          ),
                    ),
                    SizedBox(
                      height: 6,
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
              ),
              Form(
                key: _deliveryAddressFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                          hintText: S.of(context).areaAndStreet,
                          labelText: S.of(context).description,
                        ),
                        initialValue: address != null
                            ? address.description?.isNotEmpty ?? false
                                ? address.description
                                : null
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? 'Not valid address description'
                            : null,
                        onSaved: (input) => address.description = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            labelText: S.of(context).full_address),
                        initialValue: address != null
                            ? address.address?.isNotEmpty ?? false
                                ? address.address
                                : null
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? S.of(context).notValidAddress
                            : null,
                        onSaved: (input) {
                          input = Localizations.localeOf(context)
                                      .languageCode ==
                                  'en'
                              ? "${globals.country.en_name}, ${globals.city.en_name}, " +
                                  input
                              : "${globals.country.ar_name}, ${globals.city.ar_name}, " +
                                  input;
                          address.address = input;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            labelText: S.of(context).receiverFullName),
                        initialValue: address != null
                            ? address.receiver_name?.isNotEmpty ?? false
                                ? address.receiver_name
                                : null
                            : null,
                        validator: (input) => input.length < 3
                            ? S.of(context).should_be_more_than_3_letters
                            : null,
                        onSaved: (input) => address.receiver_name = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.phone,
                        decoration: getInputDecoration(
                            labelText: S.of(context).receiver_phone,
                            prefixText: "${globals.country.code} "),
                        initialValue: address != null
                            ? address.receiver_phone?.isNotEmpty ?? false
                                ? address.receiver_phone
                                : null
                            : null,
                        validator: (input) {
                          input = input.replaceAll(' ', '');
                          input = "${globals.country.code}" + input;
                          return 11 <= input.length && 12 >=input.length
                              ? null
                              : "Should be valid mobile number";
                        },
                        onSaved: (input) {
                          input = input.replaceAll(' ', '');
                          input = "${globals.country.code}" + input;
                          address.receiver_phone = input;
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CheckboxFormField(
                        context: context,
                        initialValue: address != null
                            ? address.isDefault ?? false
                            : false,
                        onSaved: (input) => address.isDefault = input,
                        title: Text(S.of(context).makeItDefault),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _submit,
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  InputDecoration getInputDecoration(
      {String hintText, String labelText, String prefixText}) {
    return new InputDecoration(
      prefixText: prefixText,
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_deliveryAddressFormKey.currentState.validate()) {
      _deliveryAddressFormKey.currentState.save();
      onChanged(address);
      Navigator.pop(context);
    }
  }
}
