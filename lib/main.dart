import 'package:fleet_monitoring_app/configurations/routing_config.dart';
import 'package:fleet_monitoring_app/controller/car_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarController(),
      child: MaterialApp.router(
        routerConfig: RoutingConfiguration().router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
