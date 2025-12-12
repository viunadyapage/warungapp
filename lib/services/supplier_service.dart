import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/api_response.dart';

class SupplierService {
  // Ambil semua data supplier untuk dropdown
  Future<ApiResponse> getSuppliers() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$baseURL/suppliers'), // Pastikan route ini ada di Laravel
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        // Asumsi response dari Laravel: { "data": [...] } atau langsung [...]
        // Sesuaikan dengan format JSON kamu
        var body = jsonDecode(response.body);
        if (body is Map && body.containsKey('data')) {
           apiResponse.data = body['data'];
        } else {
           apiResponse.data = body;
        }
      } else {
        apiResponse.error = "Gagal mengambil data supplier";
      }
    } catch (e) {
      apiResponse.error = "Server error: $e";
    }
    return apiResponse;
  }
}