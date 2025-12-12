import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/api_response.dart';
import '../models/barang.dart';

class BarangService {
  // GET semua barang
  Future<ApiResponse> getBarangList() async {
    ApiResponse apiResponse = ApiResponse();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse("$baseURL/barang"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        apiResponse.data = data.map((item) => Barang.fromJson(item)).toList();
      } else {
        apiResponse.error = "Gagal memuat data barang";
      }
    } catch (e) {
      apiResponse.error = "Tidak dapat terhubung ke server";
    }

    return apiResponse;
  }

  // CREATE barang
  Future<ApiResponse> createBarang({
    required String kode,
    required String nama,
    required String kategori,
    required int stok,
    required double hargaBeli,
    required double hargaJual,
  }) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse("$baseURL/barang"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          "kode": kode,
          "nama_barang": nama,
          "kategori": kategori,
          "stok": stok.toString(),
          "harga_beli": hargaBeli.toString(),
          "harga_jual": hargaJual.toString(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        apiResponse.data = "Success";
      } else {
        apiResponse.error =
            "Gagal menambahkan barang: ${response.statusCode} | ${response.body}";
      }
    } catch (e) {
      apiResponse.error = "Tidak dapat terhubung ke server";
    }

    return apiResponse;
  }

  // UPDATE barang
  Future<ApiResponse> updateBarang({
    required int id,
    required String nama,
    required String kategori,
    required int stok,
    required double hargaBeli,
    required double hargaJual,
  }) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.put(
        Uri.parse("$baseURL/barang/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          "nama_barang": nama,
          "kategori": kategori,
          "stok": stok.toString(),
          "harga_beli": hargaBeli.toString(),
          "harga_jual": hargaJual.toString(),
        },
      );

      if (response.statusCode == 200) {
        apiResponse.data = "Success";
      } else {
        apiResponse.error = "Gagal update barang";
      }
    } catch (e) {
      apiResponse.error = "Tidak dapat terhubung ke server";
    }

    return apiResponse;
  }

  // get barang by id
  Future<ApiResponse> getBarangById(int id) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse("$baseURL/barang/$id"),
        headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        },
    ) ;

      if (response.statusCode == 200) {
        apiResponse.data = Barang.fromJson(jsonDecode(response.body));
        } else {
          apiResponse.error = "Gagal memuat data";
          }
          } catch (e) {
            apiResponse.error = "Tidak dapat terhubung ke server";
          }
    return apiResponse;
  }

  // DELETE barang
  Future<ApiResponse> deleteBarang(int id) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.delete(
        Uri.parse("$baseURL/barang/$id"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        apiResponse.data = "Deleted";
      } else {
        apiResponse.error = "Gagal menghapus barang";
      }
    } catch (e) {
      apiResponse.error = "Tidak dapat terhubung ke server";
    }

    return apiResponse;
  }
}
