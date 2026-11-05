import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/brand.dart';
import '../models/vehicle_model.dart';

class FipeService {
  static const String baseUrl = 'https://api.invertexto.com/v1/fipe';

  static const String token = '29130|TTNsNlkdhWINhiPtjRc3sRCrZ9DJhg4U';

  static const Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  Future<dynamic> _get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Erro ${response.statusCode}: ${response.body}');
  }

  Future<List<Brand>> getBrands() async {
    final data = await _get('/brands/1');

    return (data as List).map((item) => Brand.fromJson(item)).toList();
  }

  Future<List<VehicleModel>> getModels(int brandId) async {
    final data = await _get('/models/$brandId');

    return (data as List).map((item) => VehicleModel.fromJson(item)).toList();
  }

  Future<Map<String, dynamic>> getYears(String fipeCode) async {
    final data = await _get('/years/$fipeCode');

    return data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHistory(
    String fipeCode,
    String yearId,
  ) async {
    final query = Uri(
      queryParameters: {'fipe_code': fipeCode, 'year_id': yearId},
    ).query;

    final data = await _get('/history?$query');

    return data as Map<String, dynamic>;
  }
}
