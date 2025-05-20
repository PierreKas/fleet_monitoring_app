import 'dart:async';

import 'package:fleet_monitoring_app/model/car.dart';
import 'package:fleet_monitoring_app/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Car> _carsList = [];
  Car? _car;
  List<Car> get carList => _carsList;
  Car? get car => _car;
  //SharedPreferences? _preferences;

  // void initPrefs() async {
  //   _preferences = await SharedPreferences.getInstance();

  //   getPrefs();
  //   notifyListeners();
  // }

  // void setPrefs() {
  //   if (_car == null) {
  //     return;
  //   }

  //   _preferences?.setDouble('latitude', _car?.latitude ?? 0);
  //   _preferences?.setDouble('longitude', _car?.longitude ?? 0);
  //   _preferences?.setString('car_id', _car?.id ?? '');
  //   notifyListeners();
  // }

  // void getPrefs() {
  //   if (_car == null) {
  //     return;
  //   }
  //   final latitude = _preferences?.getDouble('latitude');
  //   final longitude = _preferences?.getDouble('longitude');
  //   final carId = _preferences?.getString('car_id');

  //   if (latitude != null && longitude != null) {
  //     _car?.latitude = latitude;
  //     _car?.longitude = longitude;
  //     _car?.id = carId!;
  //   }
  //   notifyListeners();
  // }

  Future<List<Car>> getCars() async {
    try {
      _carsList = await _apiService.fetchCars();
      notifyListeners();
      return _carsList;
    } on Exception catch (e) {
      throw Exception('Error in controller $e');
    }
  }

  Future<Car?> getCarById(String id) async {
    try {
      if (_carsList.isEmpty) {
        _carsList = await _apiService.fetchCars();
      }
      _car = _carsList.firstWhere(
        (car) => car.id == id,
      );
      notifyListeners();
      return _car;
    } on Exception catch (e) {
      throw Exception('Error in controller $e');
    }
  }

  // void updateCar(Car updatetedCar) {
  //   _car = updatetedCar;
  //   notifyListeners();
  // }
  Future<void> updateCar(Car carData) async {
    int index = _carsList.indexWhere((car) => car.id == carData.id);
    // _car = updatetedCar;
    if (index == -1) {
      throw Exception('Car data not found');
    } else {
      if (_car != null && _car!.status.toLowerCase().contains('moving')) {
        _carsList[index] = carData;
        _car = carData;
      }
    }
    notifyListeners();
  }
}
