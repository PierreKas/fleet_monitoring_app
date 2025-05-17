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
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-1.9577, 30.1127),
    // target: LatLng(, 30.1127),
    zoom: 11.5,
  );
  late GoogleMapController _googleMapController;
  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCars();
    customMarkerIcon();
  }

  Future<void> _fetchCars() async {
    _carsList = await CarController().getCars();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          // myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _initialCameraPosition,
          markers: {
            Marker(
              markerId: MarkerId("Car"),
              position: LatLng(-1.9577, 30.1127),
              draggable: true,
              icon: markerIcon,
            )
          },
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
            ElevatedButton.icon(
                onPressed: () {
                  context.go('/car-details');
                },
                label: const Icon(Icons.add))
          ],
        )
      ]),
    );
  }
}
