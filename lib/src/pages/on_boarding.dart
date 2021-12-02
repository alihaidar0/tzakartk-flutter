import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tzakartk/src/library/custom_introduction_screen.dart';

import '../controllers/on_boarding_controller.dart';
import '../helpers/helper.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnBoardingScreenState();
  }
}

class OnBoardingScreenState extends StateMVC<OnBoardingScreen> {
  OnBoardingController _con;

  OnBoardingScreenState() : super(OnBoardingController()) {
    _con = controller;
  }

  @override
  void initState() {

    super.initState();
  }

  Widget buildImage(String path) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: path != null && path != ''
              ? path.toLowerCase().endsWith('.svg')
                  ? SvgPicture.network(path)
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: path,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                      ),
                    )
              : SizedBox(),
        ),
      );

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        activeColor: Theme.of(context).accentColor,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        body: SafeArea(
          child: _con.onBoardings.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: CustomIntroductionScreen(
                    done: SizedBox(),
                    onDone: () {},
                    showNextButton: false,
                    freeze: true,
                    dotsDecorator: getDotDecoration(),
                    isProgressTap: false,
                    skipFlex: 0,
                    nextFlex: 0,
                    pages: [
                      _con.onBoardings[0] != null
                          ? PageViewModel(
                              title: '',
                              body: Localizations.localeOf(context)
                                          .languageCode ==
                                      'en'
                                  ? _con.onBoardings[0]?.en_text ?? ''
                                  : _con.onBoardings[0]?.ar_text ?? '',
                              image: buildImage(
                                _con.onBoardings[0].image.url,
                              ),
                            )
                          : PageViewModel(
                              title: '',
                              body: '',
                              image: buildImage(''),
                            ),
                      _con.onBoardings[1] != null
                          ? PageViewModel(
                        title: '',
                        body: Localizations.localeOf(context)
                            .languageCode ==
                            'en'
                            ? _con.onBoardings[1]?.en_text ?? ''
                            : _con.onBoardings[1]?.ar_text ?? '',
                        image: buildImage(
                          _con.onBoardings[1].image.url,
                        ),
                      )
                          : PageViewModel(
                        title: '',
                        body: '',
                        image: buildImage(''),
                      ),
                      _con.onBoardings[2] != null
                          ? PageViewModel(
                        title: '',
                        body: Localizations.localeOf(context)
                            .languageCode ==
                            'en'
                            ? _con.onBoardings[2]?.en_text ?? ''
                            : _con.onBoardings[2]?.ar_text ?? '',
                        image: buildImage(
                          _con.onBoardings[2].image.url,
                        ),
                      )
                          : PageViewModel(
                        title: '',
                        body: '',
                        image: buildImage(''),
                      ),
                      _con.onBoardings[3] != null
                          ? PageViewModel(
                        title: '',
                        body: Localizations.localeOf(context)
                            .languageCode ==
                            'en'
                            ? _con.onBoardings[3]?.en_text ?? ''
                            : _con.onBoardings[3]?.ar_text ?? '',
                        image: buildImage(
                          _con.onBoardings[3].image.url,
                        ),
                      )
                          : PageViewModel(
                        title: '',
                        body: '',
                        image: buildImage(''),
                      ),
                      _con.onBoardings[4] != null
                          ? PageViewModel(
                        title: '',
                        body: Localizations.localeOf(context)
                            .languageCode ==
                            'en'
                            ? _con.onBoardings[4]?.en_text ?? ''
                            : _con.onBoardings[4]?.ar_text ?? '',
                        image: buildImage(
                          _con.onBoardings[4].image.url,
                        ),
                      )
                          : PageViewModel(
                        title: '',
                        body: '',
                        image: buildImage(''),
                      ),
                      _con.onBoardings[5] != null
                          ? PageViewModel(
                        title: '',
                        body: Localizations.localeOf(context)
                            .languageCode ==
                            'en'
                            ? _con.onBoardings[5]?.en_text ?? ''
                            : _con.onBoardings[5]?.ar_text ?? '',
                        image: buildImage(
                          _con.onBoardings[5].image.url,
                        ),
                      )
                          : PageViewModel(
                        title: '',
                        body: '',
                        image: buildImage(''),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).hintColor),
                  ),
                ),
        ),
      ),
    );
  }
}
