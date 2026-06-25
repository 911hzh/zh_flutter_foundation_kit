import 'package:example/module/usecase/pages/apiImpl/ApiImplPage.dart';
import 'package:example/module/usecase/pages/cutil/CUtilPage.dart';
import 'package:example/module/usecase/pages/home/HomePage.dart';
import 'package:example/module/usecase/pages/login/LoginPage.dart';
import 'package:example/module/usecase/pages/logout/LogoutPage.dart';
import 'package:example/module/usecase/pages/logger/LoggerPage.dart';
import 'package:example/module/usecase/pages/settings/SettingsDemoPage.dart';
import 'package:example/module/usecase/pages/store/StoreDemoPage.dart';
import 'package:example/module/usecase/pages/userStore/UserStoreDemoPage.dart';
import 'package:go_router/go_router.dart';

class RouteConfig {
  static GoRouter getRouter(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
        GoRoute(
          path: "/logout",
          builder: (context, state) => const LogoutPage(),
        ),
        GoRoute(path: "/home", builder: (context, state) => const HomePage()),
        GoRoute(path: "/cutil", builder: (context, state) => const CUtilPage()),
        GoRoute(
          path: "/apiImpl",
          builder: (context, state) => const ApiImplPage(),
        ),
        GoRoute(
          path: "/logger",
          builder: (context, state) => const LoggerPage(),
        ),
        GoRoute(
          path: "/settings",
          builder: (context, state) => const SettingsDemoPage(),
        ),
        GoRoute(
          path: "/store",
          builder: (context, state) => const StoreDemoPage(),
        ),
        GoRoute(
          path: "/userStore",
          builder: (context, state) => const UserStoreDemoPage(),
        ),
      ],
    );
  }
}
