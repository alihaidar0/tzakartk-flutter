import 'package:flutter/material.dart';

import 'src/models/route_argument.dart';
import 'src/pages/cart.dart';
import 'src/pages/category.dart';
import 'src/pages/checkout.dart';
import 'src/pages/countries_and_cities.dart';
import 'src/pages/delivery_addresses.dart';
import 'src/pages/delivery_pickup.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/login.dart';
import 'src/pages/on_boarding.dart';
import 'src/pages/order_success.dart';
import 'src/pages/pages.dart';
import 'src/pages/payment_methods.dart';
import 'src/pages/paypal_payment.dart';
import 'src/pages/product.dart';
import 'src/pages/profile.dart';
import 'src/pages/set_globals_screen.dart';
import 'src/pages/settings.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/tracking.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/OnBoardingsScreens':
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case '/SetGlobalsScreen':
        return MaterialPageRoute(builder: (_) => SetGlobalsScreen());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/DeliveryAddresses':
        return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget());
      case '/CountriesAndCities':
        return MaterialPageRoute(builder: (_) => CountriesAndCities());
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Cart':
        return MaterialPageRoute(
            builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      case '/Category':
        return MaterialPageRoute(
            builder: (_) =>
                CategoryWidget(routeArgument: args as RouteArgument));
      case '/Product':
        return MaterialPageRoute(
            builder: (_) =>
                ProductWidget(routeArgument: args as RouteArgument));
      case '/Tracking':
        return MaterialPageRoute(
            builder: (_) =>
                TrackingWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/DeliveryPickup':
        return MaterialPageRoute(
            builder: (_) =>
                DeliveryPickupWidget(routeArgument: args as RouteArgument));
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/PayPal':
        return MaterialPageRoute(
            builder: (_) =>
                PayPalPaymentWidget(routeArgument: args as RouteArgument));
      case '/OrderSuccess':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget());
      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
