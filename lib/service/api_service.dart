import 'dart:convert';

import 'package:fleet_monitoring_app/model/car.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String baseUrl =
      'https://6826589b397e48c91315cb61.mockapi.io/byangu/gari/voiture';
  Future<List<Car>> fetchCars() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => Car.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cars data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cars data: $e');
    }
  }

  Future<Car> fetchCarById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        return Car.fromJson(jsonData);
      } else {
        throw Exception('Failed to load car data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching car data: $e');
    }
  }
}
