import 'dart:async';

import 'package:fleet_monitoring_app/controller/car_controller.dart';
import 'package:fleet_monitoring_app/model/car.dart';
import 'package:fleet_monitoring_app/utils/colors.dart';
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
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final StreamController<double> _streamController = StreamController<double>();
  late Stream<double> _stream;
  Timer? _timer;
  @override
  void initState() {
    _stream = _streamController.stream.asBroadcastStream();
    customMarkerIcon();
    _fetchCarById();

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamController.close();
    super.dispose();
  }

  Future<void> _fetchCarById() async {
    try {
      _isLoading = true;

      final car = await CarController().getCarById(widget.cardId);
      setState(() {
        _car = car;

        _isLoading = false;
      });
      // if (_car!.status.toLowerCase().contains('moving')) {
      _startCarUpdate();
      // }
    } catch (e) {
      _isLoading = false;
      throw Exception('Error is $e');
    }
  }

  void _startCarUpdate() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_car != null) {
        if (_car!.status.toLowerCase().contains('moving')) {
          _car!.latitude += 0.0005;
          _car!.longitude -= 0.005;
        }
        _streamController.add(_car!.latitude);
        _streamController.add(_car!.longitude);
        // setState(() {
        //   _car!.latitude += 0.0005;
        //   _car!.longitude -= 0.005;
        //   _streamController.add(_car!.latitude);
        //   _streamController.add(_car!.longitude);
        // });
        Provider.of<CarController>(context, listen: false).updateCar(_car!);
      }
    });
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

  Widget _buildMap() {
    return Consumer<CarController>(
      builder: (context, ccar, _) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            // target: LatLng(_car!.latitude, _car!.longitude),
            target: LatLng(ccar.car.latitude, ccar.car.longitude),
            zoom: 13,
          ),
          markers: {
            Marker(
              markerId: MarkerId(widget.cardId),
              position: LatLng(
                  ccar.car.latitude,
                  ccar.car
                      .longitude), //LatLng(_car!.latitude, _car!.longitude),
              infoWindow: InfoWindow(
                title: ccar.car.name, //_car!.name,
              ),
              icon: markerIcon,
            ),
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final ccar=context.watch<CarController>();
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
                            return StreamBuilder<double>(
                                stream: _stream,
                                builder: (context, snapshot) {
                                  // if (_car!.status
                                  //     .toLowerCase()
                                  //     .contains('moving')) {
                                  if (snapshot.hasData) {
                                    return _buildDetails(
                                        icon: Icons.location_on,
                                        title: 'Location',
                                        value1: car.car.latitude.toStringAsFixed(
                                            5), // _car!.latitude.toStringAsFixed(5),
                                        hasValue2: true,
                                        value2:
                                            car.car.longitude.toStringAsFixed(5)
                                        // _car!.longitude.toStringAsFixed(5),
                                        );
                                  } else {
                                    return _buildDetails(
                                      icon: Icons.location_on,
                                      title: 'Location',
                                      value1: 'Searching coordinates...',
                                      hasValue2: false,
                                    );
                                  }
                                }
                                // else {
                                //   return _buildDetails(
                                //     icon: Icons.location_on,
                                //     title: 'Location',
                                //     value1: car.car.latitude.toStringAsFixed(
                                //         5), //_car!.latitude.toStringAsFixed(5),
                                //     hasValue2: true,
                                //     value2: car.car.longitude.toStringAsFixed(
                                //         5), // _car!.longitude.toStringAsFixed(5),
                                //   );
                                // }
                                //  },
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder<Object>(
                        stream: _stream,
                        builder: (context, snapshot) {
                          // if (_car!.status.toLowerCase().contains('moving')) {
                          if (snapshot.hasData) {
                            return _buildMap();
                          } else {
                            return const Center(
                                child: Text(
                              'Searching coordinates...',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ));
                          }
                        }
                        // else {
                        //   return _buildMap();
                        // }
                        //},
                        ),
                  ),
                ],
              ),
            ),
    );
  }
}
