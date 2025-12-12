import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/api_response.dart';
import '../models/barang_keluar.dart';

class BarangKeluarService {
  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // GET LIST
  Future<ApiResponse> getBarangKeluarList() async {
  ApiResponse response = ApiResponse();

  try {
    String token = await _getToken();
    final res = await http.get(
      Uri.parse("$baseURL/pengeluaran"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);

      // Jika API mengembalikan array langsung
      if (body is List) {
        response.data =
            body.map((x) => BarangKeluar.fromJson(x)).toList();
      }

      // Jika API mengembalikan { "data": [...] }
      else if (body is Map && body.containsKey("data")) {
        response.data =
            (body["data"] as List).map((x) => BarangKeluar.fromJson(x)).toList();
      }

      else {
        response.error = "Format data tidak dikenali";
      }
    } else {
      response.error = "Gagal memuat data barang keluar";
    }
  } catch (e) {
    response.error = "Tidak dapat terhubung ke server";
  }

  return response;
}

  // GET BY ID
  Future<ApiResponse> getBarangKeluarById(int id) async {
    ApiResponse response = ApiResponse();

    try {
      String token = await _getToken();
      final res = await http.get(
        Uri.parse("$baseURL/pengeluaran/$id"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);

        response.data = BarangKeluar.fromJson(body);
      } else {
        response.error = "Gagal memuat data barang keluar";
      }
    } catch (e) {
      response.error = "Tidak dapat terhubung ke server";
    }

    return response;
  }

  // CREATE
  Future<ApiResponse> createBarangKeluar({
    required int barangId,
    required int jumlah,
    required String alasan,
    required String tanggal,
    String? keterangan,
  }) async {
    ApiResponse response = ApiResponse();

    try {
      String token = await _getToken();
      final res = await http.post(
        Uri.parse("$baseURL/pengeluaran"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "barang_id": barangId.toString(),
          "jumlah": jumlah.toString(),
          "alasan": alasan,
          "tanggal": tanggal,
          "keterangan": keterangan ?? "",
        },
      );

      if (res.statusCode == 201) {
        response.data = "Success";
      } else {
        response.error = "Gagal menambahkan barang keluar";
      }
    } catch (e) {
      response.error = "Tidak dapat terhubung ke server";
    }

    return response;
  }

  // UPDATE
  Future<ApiResponse> updateBarangKeluar({
    required int id,
    required int barangId,
    required int jumlah,
    required String alasan,
    required String tanggal,
    String? keterangan,
  }) async {
    ApiResponse response = ApiResponse();

    try {
      String token = await _getToken();
      final res = await http.put(
        Uri.parse("$baseURL/pengeluaran/$id"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "barang_id": barangId.toString(),
          "jumlah": jumlah.toString(),
          "alasan": alasan,
          "tanggal": tanggal,
          "keterangan": keterangan ?? "",
        },
      );

      if (res.statusCode == 200) {
        response.data = "Success";
      } else {
        response.error = "Gagal memperbarui data barang keluar";
      }
    } catch (e) {
      response.error = "Tidak dapat terhubung ke server";
    }

    return response;
  }

  // DELETE
  Future<ApiResponse> deleteBarangKeluar(int id) async {
    ApiResponse response = ApiResponse();

    try {
      String token = await _getToken();
      final res = await http.delete(
        Uri.parse("$baseURL/pengeluaran/$id"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        response.data = "Deleted";
      } else {
        response.error = "Gagal menghapus data";
      }
    } catch (e) {
      response.error = "Tidak dapat terhubung ke server";
    }

    return response;
  }
}
