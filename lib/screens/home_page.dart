import 'dart:async';

import 'package:fleet_monitoring_app/controller/car_controller.dart';
import 'package:fleet_monitoring_app/model/car.dart';
import 'package:fleet_monitoring_app/widgets/filter_buttons.dart';
import 'package:fleet_monitoring_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Car> _carsList = [];
  Set<Marker> _markers = {};
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-1.9577, 30.1127),
    zoom: 13,
  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCars();
    customMarkerIcon();
  }

  Future<void> _fetchCars() async {
    try {
      final cars = await CarController().getCars();
      setState(() {
        _carsList = cars;
        _createMarkers();
      });
    } catch (e) {
      throw Exception('Error is $e');
    }
  }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  TextEditingController _searchController = TextEditingController();
  void customMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(50, 50), //devicePixelRatio: 2.5
            ),
            "assets/icons/car2.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  void _createMarkers() {
    _markers = _carsList.map((car) {
      return Marker(
          markerId: MarkerId(car.id),
          position: LatLng(car.latitude, car.longitude),
          infoWindow: InfoWindow(
            title: car.name,
          ),
          icon: markerIcon,
          onTap: () {
            context.go('/car-details/${car.id}');
          });
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          myLocationButtonEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          markers: _markers,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: MySearchBar(
                controller: _searchController,
                onChanged: (p0) {},
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const FilterButtons(),
          ],
        )
      ]),
    );
  }
}
