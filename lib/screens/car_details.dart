import 'dart:async';

import 'package:fleet_monitoring_app/controller/car_controller.dart';
import 'package:fleet_monitoring_app/model/car.dart';
import 'package:fleet_monitoring_app/utils/colors.dart';
import 'package:fleet_monitoring_app/widgets/tracking_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
  bool _isTracking = false;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late double lastLatitude;
  late double lastLongitude;
  StreamSubscription? _trackingSubscription;
  GoogleMapController? _googleMapController;
  @override
  void initState() {
    customMarkerIcon();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCarById();
    });
    // _fetchCarById();
    // Provider.of<CarController>(context, listen: false).initPrefs();
    super.initState();
  }

  @override
  void dispose() {
    _stopTracking();
    _googleMapController?.dispose();
    super.dispose();
  }

  Future<void> _fetchCarById() async {
    try {
      _isLoading = true;

      _car = await Provider.of<CarController>(context, listen: false)
          .getCarById(widget.cardId);
      lastLatitude = _car!.latitude;
      lastLongitude = _car!.longitude;
      // print(
      //     'Coordinates on details page are latidude: ${_car!.latitude} , longiude: ${_car!.longitude}');
      setState(() {
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
      "assets/icons/car1.png",
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  void _startTracking() {
    if (_trackingSubscription != null) {
      return;
    }

    final carController = Provider.of<CarController>(context, listen: false);

    _trackingSubscription =
        Stream.periodic(const Duration(seconds: 5)).listen((_) async {
      try {
        if (mounted && _isTracking) {
          setState(() {
            lastLatitude = carController.car!.latitude;
            lastLongitude = carController.car!.longitude;
          });
          _googleMapController?.animateCamera(
            CameraUpdate.newLatLng(LatLng(lastLatitude, lastLongitude)),
          );
        }
      } catch (e) {
        throw Exception('Error tracking car location');
      }
    });

    setState(() {
      _isTracking = true;
    });
  }

  void _stopTracking() {
    _trackingSubscription?.cancel();
    _trackingSubscription = null;
    setState(() {});
    if (mounted) {
      _isTracking = false;
    }
  }

  void _toggleTracking() {
    if (_isTracking) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  Widget _buildDetails(
      {required String title,
      required IconData icon,
      required final value1,
      required bool hasValue2,
      final value2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
                  fontSize: 15,
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

  Widget _buildMap() {
    return Consumer<CarController>(
      builder: (context, myCar, child) {
        _car = myCar.car;
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            // target: LatLng(-1.9577, 30.1127),
            target: LatLng(_car!.latitude, _car!.longitude),
            zoom: 13,
          ),
          markers: {
            Marker(
              markerId: MarkerId(widget.cardId),
              position: LatLng(
                _isTracking ? _car!.latitude : lastLatitude,
                _isTracking ? _car!.longitude : lastLongitude,
              ),
              infoWindow: InfoWindow(
                title: _car!.name,
              ),
              icon: markerIcon,
            ),
          },
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
        );
      },
    );
  }

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
          : _car == null
              ? const Center(
                  child: Text(
                  'Car not found.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Consumer<CarController>(
                              builder: (context, car, _) {
                                return _buildDetails(
                                  icon: Icons.location_on,
                                  title: 'last location',
                                  value1: _isTracking
                                      ? car.car!.latitude.toStringAsFixed(5)
                                      : lastLatitude.toStringAsFixed(5),
                                  hasValue2: true,
                                  value2: _isTracking
                                      ? car.car!.longitude.toStringAsFixed(5)
                                      : lastLongitude.toStringAsFixed(5),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TrackingButton(
                        onPressed: () {
                          _toggleTracking();
                        },
                        isTracking: _isTracking,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: _buildMap(),
                      ),
                    ],
                  ),
                ),
    );
  }
}
