import 'package:edutech/constants/route_name.dart';
import 'package:edutech/ui/views/account/user_account_view.dart';
import 'package:edutech/ui/views/changePwd/change_pwd_view.dart';
import 'package:edutech/ui/views/complete/signup_complete_view.dart';
import 'package:edutech/ui/views/dashboard/dash_view.dart';
import 'package:edutech/ui/views/forgot_password/forgot_view.dart';
import 'package:edutech/ui/views/home/home_view.dart';
import 'package:edutech/ui/views/login/login_view.dart';
import 'package:edutech/ui/views/profile/profile_view.dart';
import 'package:edutech/ui/views/sales/add_sale_view.dart';
import 'package:edutech/ui/views/salesmen/salesmen_view.dart';
import 'package:edutech/ui/views/signup/signup_view.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case SignUpCompleteRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpCompleteView(),
      );
    case ProfileViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );

    case FogotPasswordRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ForgotView(),
      );
    case ChangePwdViewRoute:
      var email = settings.arguments as String;
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ChangePasswordView(),
      );
    case AddSaleViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: AddSaleView(),
      );

    case UserAccountViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: UserAccountView(),
      );

    case ForgotPwdRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ForgotView(),
      );
    case DashboardViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: DashView(),
      );
    case SalesmenViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SalesmenView(),
      );

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
