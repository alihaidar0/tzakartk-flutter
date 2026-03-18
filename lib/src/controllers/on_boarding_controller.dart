import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/on_boarding.dart';
import '../repository/on_boarding_repository.dart';

class OnBoardingController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<OnBoarding> onBoardings = <OnBoarding>[];

  OnBoardingController() {
    listenForOnBoardings();
  }

  Future<void> listenForOnBoardings() async {
    final Stream<OnBoarding> stream = await getOnBoardings();
    stream.listen(
      (OnBoarding _onBoarding) {
        setState(() => onBoardings.add(_onBoarding));
      },
      onError: (a) {
        print("##################");
        print("######### Error getOnBoardings #########");
        print("##################");
        print(a);
      },
      onDone: () {},
    );
  }
}
