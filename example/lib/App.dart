import 'package:example/route/GlobalNavigatorKey.dart';
import 'package:example/route/RouteConfig.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final String initialRoute;
  const App({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: RouteConfig.routes, initialRoute: initialRoute, key: globalNavigatorKey);
  }
}
