import 'dart:async';

import 'package:fleet_monitoring_app/controller/car_controller.dart';
import 'package:fleet_monitoring_app/model/car.dart';
import 'package:fleet_monitoring_app/utils/colors.dart';
import 'package:fleet_monitoring_app/widgets/filter_buttons.dart';
import 'package:fleet_monitoring_app/widgets/my_snackbar.dart';
import 'package:fleet_monitoring_app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Car> _carsList = [];
  List<Car> _filteredCarsList = [];
  Set<Marker> _markers = {};
  final StreamController<List<Car>> _streamController =
      StreamController<List<Car>>();
  late Stream<List<Car>> _stream;
  Timer? _timer;

  String? _errorMessage;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-1.9577, 30.1127),
    zoom: 11.5,
  );

  @override
  void dispose() {
    _searchController.dispose();
    _streamController.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _fetchCars();
    customMarkerIcon();
    _stream = _streamController.stream.asBroadcastStream();
    Provider.of<CarController>(context, listen: false).initPrefs();
    super.initState();
  }

  void _startCarUpdate() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      for (var car in _carsList) {
        if (car.status.toLowerCase().contains('moving')) {
          if (int.tryParse(car.id)! >= 5) {
            car.latitude += 0.0005;
            car.longitude -= 0.0005;
            Provider.of<CarController>(context, listen: false).updateCar(car);
          } else {
            car.latitude -= 0.0005;
            car.longitude += 0.0005;
            Provider.of<CarController>(context, listen: false).updateCar(car);
          }
        }
      }
      setState(() {
        _createMarkers();
        _streamController.add(_carsList);
      });
    });
  }

  Future<void> _fetchCars() async {
    try {
      setState(() {
        _errorMessage = null;
      });
      _carsList = (await Provider.of<CarController>(context, listen: false)
              .getCars()) ??
          [];
      _filteredCarsList = _carsList;
      _createMarkers();
      _startCarUpdate();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      if (!mounted) {
        MySnackBar.showErrorMessage(_errorMessage!, context);
      }
      throw Exception('Error is $e');
    } finally {}
  }

  void filterCars(String query) {
    final filtered = _carsList.where((car) {
      final carName = car.name.toLowerCase();
      final input = query.toLowerCase();
      return carName.contains(input);
    }).toList();

    setState(() {
      _filteredCarsList = filtered;
      _createMarkers();
    });
  }

  void filterMovingCars() {
    final filtered = _carsList.where((car) {
      final movingCars = car.status.toLowerCase() == 'moving';
      return movingCars;
    }).toList();

    setState(() {
      _filteredCarsList = filtered;
      _createMarkers();
    });
  }

  void filterParkedCars() {
    final filtered = _carsList.where((car) {
      final parkedCars = car.status.toLowerCase() == 'parked';
      return parkedCars;
    }).toList();

    setState(() {
      _filteredCarsList = filtered;
      _createMarkers();
    });
  }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final TextEditingController _searchController = TextEditingController();
  void customMarkerIcon() {
    BitmapDescriptor.asset(
            const ImageConfiguration(
              size: Size(50, 50),
            ),
            "assets/icons/car2.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  void _createMarkers() {
    _markers = _filteredCarsList.map((car) {
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
      backgroundColor: MyColors.white,
      body: Consumer<CarController>(
        builder: (context, value, child) {
          return Stack(children: [
            StreamBuilder<List<Car>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GoogleMap(
                      myLocationButtonEnabled: false,
                      initialCameraPosition: _initialCameraPosition,
                      markers: _markers,
                    );
                  } else {
                    return const Center(
                        child: Text(
                      "Fetching data...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ));
                  }
                }),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: MySearchBar(
                    controller: _searchController,
                    onChanged: filterCars,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                FilterButtons(
                  onFilterChanged: (index) {
                    if (index == 1) {
                      filterMovingCars();
                    } else if (index == 2) {
                      filterParkedCars();
                    } else {
                      _fetchCars();
                    }
                  },
                ),
              ],
            )
          ]);
        },
      ),
    );
  }
}
