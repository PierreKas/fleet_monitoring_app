import 'package:fleet_monitoring_app/model/car.dart';
import 'package:fleet_monitoring_app/service/api_service.dart';

class CarController {
  final ApiService _apiService = ApiService();
  List<Car> _carsList = [];
  Future<List<Car>> getCars() async {
    _carsList = await _apiService.fetchCars();
    return _carsList;
  }
}
