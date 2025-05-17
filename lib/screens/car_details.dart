import 'package:fleet_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarDetails extends StatefulWidget {
  const CarDetails({super.key});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  Widget _buildDetails(
      {required String title,
      required IconData icon,
      required final value1,
      required bool hasValue2,
      final value2}) {
    return Row(
      children: [
        Icon(icon),
        Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: MyColors.grey),
            ),
            if (!hasValue2)
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (hasValue2)
              Text(
                '${value1.toString()} ,${value2.toString()}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ],
    );
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-1.9577, 30.1127),
    zoom: 11.5,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        title: const Text(
          'Car X',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: MyColors.green,
                    ),
                    Text('Status'),
                  ],
                ),
                const Text(
                  'ID:',
                  style: TextStyle(color: MyColors.grey),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                _buildDetails(
                  icon: Icons.speed,
                  title: 'Speed',
                  value1: '25km/h',
                  hasValue2: false,
                ),
                const SizedBox(
                  width: 10,
                ),
                _buildDetails(
                  icon: Icons.location_on,
                  title: 'Location',
                  value1: '-1.8394',
                  hasValue2: true,
                  value2: '45.566',
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
                height: 500,
                width: 500,
                child: const GoogleMap(
                    initialCameraPosition: _initialCameraPosition))
          ],
        ),
      ),
    );
  }
}
