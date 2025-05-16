import 'package:fleet_monitoring_app/screens/car_details.dart';
import 'package:fleet_monitoring_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutingConfig {
  GoRouter router = GoRouter(routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'car-details',
            builder: (BuildContext context, GoRouterState state) {
              return const CarDetails();
            },
          ),
        ])
  ]);
}
