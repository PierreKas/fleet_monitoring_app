import 'package:fleet_monitoring_app/model/car.dart';
import 'package:fleet_monitoring_app/service/api_service.dart';

class CarController {
  final ApiService _apiService = ApiService();
  List<Car> _carsList = [];
  Car? _car;
  Future<List<Car>> getCars() async {
    try {
      _carsList = await _apiService.fetchCars();

      return _carsList;
    } on Exception catch (e) {
      throw Exception('Error in controller $e');
    }
  }

  Future<Car?> getCarById(String id) async {
    try {
      _car = await _apiService.fetchCarById(id);
      return _car;
      // _carsList = await _apiService.fetchCars();

      // return _carsList.firstWhere((car) => car.id == id);
    } on Exception catch (e) {
      throw Exception('Error in controller $e');
    }
  }
}
