import 'dart:async';
import 'dart:convert';

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
  SharedPreferences? _preferences;

  Future<void> initPrefs() async {
    try {
      _preferences = await SharedPreferences.getInstance();

      if (_preferences != null) {
        await _loadCarsFromPreferences();
      }
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> _saveCarsToPreferences() async {
    if (_preferences == null) {
      return;
    }
    List<String> carsJsonList =
        _carsList.map((car) => jsonEncode(car.toJson())).toList();
    await _preferences!.setStringList('cars_data', carsJsonList);
  }

  Future<void> _loadCarsFromPreferences() async {
    if (_preferences == null) {
      return;
    }
    List<String>? carsJsonList = _preferences!.getStringList('cars_data');
    if (carsJsonList != null && carsJsonList.isNotEmpty) {
      _carsList = carsJsonList
          .map((carJson) => Car.fromJson(jsonDecode(carJson)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveACarToPreferences(Car car) async {
    if (_preferences == null) {
      return;
    }
    if (_preferences == null) {
      return;
    }
    await _preferences!.setString('car_${car.id}', jsonEncode(car.toJson()));
  }

  Future<Car?> _loadACarFromPreferences(String id) async {
    if (_preferences == null) {
      return null;
    }
    String? carJson = _preferences!.getString('car_$id');
    if (carJson != null) {
      return Car.fromJson(jsonDecode(carJson));
    }
    return null;
  }

  Future<List<Car>?> getCars() async {
    try {
      if (_carsList.isEmpty) {
        await _loadCarsFromPreferences();
        if (_carsList.isEmpty) {
          _carsList = await _apiService.fetchCars();
          await _saveCarsToPreferences();
        }
      }

      notifyListeners();
      return _carsList;
    } on Exception catch (e) {
      debugPrint('Error loading car data $e');
    }
    return null;
  }

  Future<Car?> getCarById(String id) async {
    try {
      // if (_carsList.isEmpty) {
      //   _carsList = await _apiService.fetchCars();
      // }
      _car = await _loadACarFromPreferences(id);
      if (_car == null) {
        if (_carsList.isEmpty) {
          await getCars();
        }
      }

      try {
        _car = _carsList.firstWhere(
          (car) => car.id == id,
        );

        if (_car != null) {
          await _saveACarToPreferences(_car!);
        }
      } on Exception catch (e) {
        throw Exception('Car not found: $e');
      }
      notifyListeners();
      return _car;
    } on Exception catch (e) {
      throw Exception('Error in controller $e');
    }
  }

  Future<void> updateCar(Car updatedCar) async {
    int index = _carsList.indexWhere((car) => car.id == updatedCar.id);
    if (index == -1) {
      throw Exception('Car data not found');
    } else {
      if (_car != null && _car!.status.toLowerCase().contains('moving')) {
        _carsList[index] = updatedCar;
        _car = updatedCar;

        await _saveACarToPreferences(updatedCar);
        await _saveCarsToPreferences();
      }
    }
    notifyListeners();
  }
}
