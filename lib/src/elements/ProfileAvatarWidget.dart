import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final User user;

  ProfileAvatarWidget({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Center(
        child: Text(
          user.name,
          style: Theme.of(context)
              .textTheme
              .headline5
              .merge(TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ),
    );
  }
}
