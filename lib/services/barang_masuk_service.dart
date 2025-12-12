import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/api_response.dart';
import '../models/barang_masuk.dart';

class BarangMasukService {
  
  // 1. GET List (URL disesuaikan ke /pembelian)
  Future<ApiResponse> getBarangMasukList() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      // PERUBAHAN URL DISINI
      final response = await http.get(
        Uri.parse("$baseURL/pembelian"), 
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Sesuaikan dengan format return controller kamu:
        // { "success": true, "data": [...] }
        var body = jsonDecode(response.body);
        
        // Ambil list dari key 'data'
        List data = body['data']; 
        
        apiResponse.data = data.map((p) => BarangMasuk.fromJson(p)).toList();
      } else {
        apiResponse.error = "Gagal memuat data";
      }
    } catch (e) {
      apiResponse.error = "Server error: $e";
    }
    return apiResponse;
  }

  // 2. CREATE (URL disesuaikan ke /pembelian)
  Future<ApiResponse> createBarangMasuk({
    required int supplierId,
    required int barangId,
    required int jumlah,
    required String tanggal,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      // PERUBAHAN URL DISINI
      final response = await http.post(
        Uri.parse("$baseURL/pembelian"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          "supplier_id": supplierId.toString(),
          "barang_id": barangId.toString(),
          
          // PERBAIKAN DISINI: Pastikan key-nya 'jumlah'
          "jumlah": jumlah.toString(), 
          
          "tanggal_masuk": tanggal,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        apiResponse.data = "Success";
      } else {
        var errorBody = jsonDecode(response.body);
        apiResponse.error = errorBody['message'] ?? "Gagal menyimpan";
      }
    } catch (e) {
      apiResponse.error = "Server error";
    }
    return apiResponse;
  }

  // 3. UPDATE
  Future<ApiResponse> updateBarangMasuk({
    required int id,
    required int supplierId,
    required int barangId,
    required int jumlah,
    required String tanggal,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      // PERUBAHAN URL DISINI
      final response = await http.put(
        Uri.parse("$baseURL/pembelian/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          "supplier_id": supplierId.toString(),
          "barang_id": barangId.toString(),
          "jumlah": jumlah.toString(), 
          "tanggal_masuk": tanggal,
        },
      );

      if (response.statusCode == 200) {
        apiResponse.data = "Success";
      } else {
        apiResponse.error = "Gagal update";
      }
    } catch (e) {
      apiResponse.error = "Server error";
    }
    return apiResponse;
  }

  // 4. DELETE
  Future<ApiResponse> deleteBarangMasuk(int id) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      // PERUBAHAN URL DISINI
      final response = await http.delete(
        Uri.parse("$baseURL/pembelian/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        apiResponse.data = "Deleted";
      } else {
        apiResponse.error = "Gagal hapus";
      }
    } catch (e) {
      apiResponse.error = "Server error";
    }
    return apiResponse;
  }
}