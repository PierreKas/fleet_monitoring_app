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
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-1.9577, 30.1127),
    zoom: 11.5,
  );
  late GoogleMapController _googleMapController;
  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   context.go('car-details');
      // }),
      body: Stack(children: [
        const GoogleMap(
          // myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _initialCameraPosition,
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
            SizedBox(
              height: 15,
            ),
            FilterButtons(),
            ElevatedButton.icon(
                onPressed: () {
                  context.go('/car-details');
                },
                label: Icon(Icons.add))
          ],
        )
      ]),
    );
  }
}
