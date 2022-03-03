import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  _DrawerWidgetState() : super(ProfileController()) {}

  void launchWhatApp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("can't open whatsapp");
  }

  void launchTiktok({@required user}) async {
    String url = "https://tiktok.com/$user";
    await canLaunch(url) ? launch(url) : print("can't open whatsapp");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.apiToken != null
                  ? Navigator.of(context).pushNamed('/Profile')
                  : Navigator.of(context)
                      .pushReplacementNamed('/Login', arguments: false);
            },
            child: currentUser.value.apiToken != null
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    accountName: Text(
                      currentUser.value.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    accountEmail: Text(
                      currentUser.value.email,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).welcome,
                            style: Theme.of(context).textTheme.headline4.merge(
                                TextStyle(
                                    color: Theme.of(context).accentColor))),
                        SizedBox(height: 5),
                        Text(S.of(context).loginAccountOrCreateNewOneForFree,
                            style: Theme.of(context).textTheme.bodyText2),
                        SizedBox(height: 15),
                        Wrap(
                          spacing: 10,
                          children: <Widget>[
                            MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    '/Login',
                                    arguments: false);
                              },
                              color: Theme.of(context).accentColor,
                              height: 40,
                              child: Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 9,
                                children: [
                                  Icon(Icons.exit_to_app_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: 24),
                                  Text(
                                    S.of(context).login,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .merge(TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ],
                              ),
                              shape: StadiumBorder(),
                            ),
                            MaterialButton(
                              elevation: 0,
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.2),
                              height: 40,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/SignUp');
                              },
                              child: Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 9,
                                children: [
                                  Icon(Icons.person_add_outlined,
                                      color: Theme.of(context).hintColor,
                                      size: 24),
                                  Text(
                                    S.of(context).register,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .merge(TextStyle(
                                            color:
                                                Theme.of(context).hintColor)),
                                  ),
                                ],
                              ),
                              shape: StadiumBorder(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 1);
            },
            leading: Icon(
              Icons.home_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).home,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 0);
            },
            leading: Icon(
              Icons.notifications_none_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).notifications,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              Icons.local_mall_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).my_orders,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              S.of(context).application_preferences,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).pushNamed('/Settings');
              } else {
                Navigator.of(context)
                    .pushReplacementNamed('/Login', arguments: false);
              }
            },
            leading: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).settings,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/CountriesAndCities');
            },
            leading: Icon(
              Icons.location_city_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).countriesAndCities,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).languages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                setBrightness(Brightness.light);
                setting.value.brightness.value = Brightness.light;
              } else {
                setting.value.brightness.value = Brightness.dark;
                setBrightness(Brightness.dark);
              }
              setting.notifyListeners();
            },
            leading: Icon(
              Icons.brightness_6_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark
                  ? S.of(context).light_mode
                  : S.of(context).dark_mode,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                logout().then((value) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Pages', (Route<dynamic> route) => false,
                      arguments: 1);
                });
              } else {
                Navigator.of(context)
                    .pushReplacementNamed('/Login', arguments: false);
              }
            },
            leading: Icon(
              Icons.exit_to_app_outlined,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              currentUser.value.apiToken != null
                  ? S.of(context).log_out
                  : S.of(context).login,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          currentUser.value.apiToken == null
              ? ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/SignUp');
                  },
                  leading: Icon(
                    Icons.person_add_outlined,
                    color: Theme.of(context).focusColor.withOpacity(1),
                  ),
                  title: Text(
                    S.of(context).register,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )
              : SizedBox(height: 0),
          setting.value.enableVersion
              ? ListTile(
                  dense: true,
                  title: Text(
                    S.of(context).version + " " + setting.value.appVersion,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                )
              : SizedBox(),
          Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/logo.png',
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 20),
                    Text(
                      S.of(context).tzakartk,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).email + ": ",
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'customerservice@tzakartk.com',
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onTap: () async {
                          await launch("mailto:customerservice@tzakartk.com");
                        },
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).phoneNumber + ": ",
                                  style: Theme.of(context).textTheme.subtitle2,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '+9611252213',
                                  style: Theme.of(context).textTheme.subtitle2,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Text(
                              '9:00AM - 3:00PM',
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onTap: () async {
                          await launch("tel://+9611252213");
                        },
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).mobileNumber + ": ",
                                  style: Theme.of(context).textTheme.subtitle2,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '+96170701670',
                                  style: Theme.of(context).textTheme.subtitle2,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Text(
                              '10:00AM - 6:00PM',
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onTap: () async {
                          await launch("tel://+96170701670");
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3.0,
                    horizontal: 50,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).or +
                            '\n' +
                            S.of(context).contactUsVia +
                            ":",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              launchTiktok(user: '@tzakartk');
                            },
                            icon: SvgPicture.asset(
                              'assets/img/tiktok.svg',
                              height: 50,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              String fbProtocolUrl;
                              if (Platform.isIOS) {
                                fbProtocolUrl = 'fb://profile/106365055297270';
                              } else {
                                fbProtocolUrl = 'fb://page/106365055297270';
                              }

                              String fallbackUrl = 'https://www.facebook.com/tzakartk';

                              try {
                                bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

                                if (!launched) {
                                  await launch(fallbackUrl, forceSafariVC: false);
                                }
                              } catch (e) {
                                await launch(fallbackUrl, forceSafariVC: false);
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/img/facebook.svg',
                              height: 50,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              var url = 'https://www.instagram.com/tzakartk/';

                              if (await canLaunch(url)) {
                                await launch(
                                  url,
                                  universalLinksOnly: true,
                                );
                              } else {
                                throw 'There was a problem to open the url: $url';
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/img/instagram.svg',
                              height: 50,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              launchWhatApp(
                                  number: '+96170701670', message: '');
                            },
                            icon: SvgPicture.asset(
                              'assets/img/whatsapp.svg',
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
