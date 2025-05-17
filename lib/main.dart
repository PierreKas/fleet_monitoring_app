import 'package:fleet_monitoring_app/configurations/routing_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RoutingConfiguration().router,
      debugShowCheckedModeBanner: false,
    );
  }
}
