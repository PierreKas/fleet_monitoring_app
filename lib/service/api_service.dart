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
    } on http.ClientException {
      throw Exception('Network error: Unable to connect to server');
    } catch (e) {
      throw Exception(
          'Connection error: Please check your internet connection');
    }
  }
}
