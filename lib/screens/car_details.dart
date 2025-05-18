import 'package:fleet_monitoring_app/controller/car_controller.dart';
import 'package:fleet_monitoring_app/model/car.dart';
import 'package:fleet_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarDetails extends StatefulWidget {
  final String cardId;
  const CarDetails({
    super.key,
    required this.cardId,
  });

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  Car? _car;
  bool _isLoading = false;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    customMarkerIcon();
    _fetchCarById();
    super.initState();
  }

  Future<void> _fetchCarById() async {
    try {
      _isLoading = true;

      final car = await CarController().getCarById(widget.cardId);
      setState(() {
        _car = car;
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;
      throw Exception('Error is $e');
    }
  }

  void customMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(60, 60),
            ),
            "assets/icons/car1.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

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

  // static final _initialCameraPosition = CameraPosition(
  //   // target: LatLng(-1.9577, 30.1127),
  //   target: LatLng(_car!.latitude, _car!.longitude),
  //   zoom: 13,
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        backgroundColor: MyColors.skyBlue,
        title: Text(
          _car?.name ?? 'Car details',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Text(
              'Fetching data...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: _car!.status == "Moving"
                                ? MyColors.green
                                : MyColors.grey,
                          ),
                          Text(_car!.status),
                        ],
                      ),
                      Text(
                        'ID: ${widget.cardId}',
                        style: const TextStyle(color: MyColors.grey),
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
                        value1: '${_car!.speed.toString()} Km/h',
                        hasValue2: false,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      _buildDetails(
                        icon: Icons.location_on,
                        title: 'Location',
                        value1: _car!.latitude.toString(),
                        hasValue2: true,
                        value2: _car!.longitude.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      // height: 500,
                      // width: 500,
                      child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            // target: LatLng(-1.9577, 30.1127),
                            target: LatLng(_car!.latitude, _car!.longitude),
                            zoom: 13,
                          ),
                          markers: {
                        Marker(
                          markerId: MarkerId(widget.cardId),
                          position: LatLng(_car!.latitude, _car!.longitude),
                          infoWindow: InfoWindow(
                            title: _car!.name,
                          ),
                          icon: markerIcon,
                        ),
                      }))
                ],
              ),
            ),
    );
  }
}
