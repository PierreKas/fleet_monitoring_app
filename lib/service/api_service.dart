import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fleet_monitoring_app/model/car.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String baseUrl = 'https://682de0cd746f8ca4a47afaa5.mockapi.io/cars';
  Future<List<Car>> fetchCars() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => Car.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cars data: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception(
          'Connection timeout: The server took too long to respond');
    } on SocketException {
      throw Exception(
          'No internet connection: Please check your network settings');
    } on http.ClientException {
      throw Exception('Network error: Unable to connect to server');
    } catch (e) {
      throw Exception(
          'Connection error: Please check your internet connection');
    }
  }
}
