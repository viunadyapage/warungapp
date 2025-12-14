import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';

class AuthService {
  // ==========================================
  // LOGIN
  // ==========================================
  Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  print(">>> Mencoba login ke: $baseURL/login");

  try {
    final response = await http.post(
      Uri.parse('$baseURL/login'),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email,
        'password': password,
      },
    );

    print(">>> Status code: ${response.statusCode}");
    print(">>> Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // user = data['data']
      apiResponse.data = User.fromJson(data['data']);

      // simpan token
      await _saveToken(data['access_token']);
    } 
    else if (response.statusCode == 401) {
      apiResponse.error = "Email atau password salah";
    } 
    else {
      apiResponse.error = "Terjadi kesalahan server";
    }
  } catch (e) {
    apiResponse.error = "Tidak dapat terhubung ke server";
  }

  return apiResponse;
}

  // ==========================================
  // REGISTER
  // ==========================================
  Future<ApiResponse> register(
      String name, String email, String password, String confirmPassword) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      final response = await http.post(
        Uri.parse('$baseURL/register'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        apiResponse.data = User.fromJson(jsonDecode(response.body)['user']);
      } else {
        apiResponse.error = jsonDecode(response.body)['message'];
      }
    } catch (e) {
      apiResponse.error = "Tidak dapat terhubung ke server";
    }

    return apiResponse;
  }

  // ==========================================
  // GET USER
  // ==========================================
  Future<ApiResponse> getUser() async {
    ApiResponse apiResponse = ApiResponse();

    try {
      String token = await _getToken();

      final response = await http.get(
        Uri.parse('$baseURL/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        apiResponse.data = User.fromJson(jsonDecode(response.body));
      } else {
        apiResponse.error = "Gagal mengambil data user";
      }
    } catch (e) {
      apiResponse.error = "Tidak dapat terhubung ke server";
    }

    return apiResponse;
  }

  // logout
  Future<ApiResponse> logout() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseURL/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      // HAPUS TOKEN DI HP (WAJIB)
      await _removeToken();
      if (response.statusCode == 200) {
        apiResponse.data = "Logout success";
      } else {
        apiResponse.error = "Gagal logout";
      }
    } catch (e) {
      apiResponse.error = "Tidak dapat terhubung ke server";
    }
  return apiResponse;
}


  // ==========================================
  // UPDATE PROFILE
  // ==========================================
  Future<ApiResponse> updateProfile(
      String name, String email, String? password, String? confirmPassword) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      String token = await _getToken();

      Map<String, String> data = {
        'name': name,
        'email': email,
      };

      if (password != null && password.isNotEmpty) {
        data['password'] = password;
        data['password_confirmation'] = confirmPassword!;
      }

      final response = await http.put(
        Uri.parse('$baseURL/user/update'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        apiResponse.data = User.fromJson(jsonDecode(response.body)['user']);
      } else {
        apiResponse.error = "Gagal update profil";
      }
    } catch (e) {
      apiResponse.error = "Tidak dapat terhubung ke server";
    }

    return apiResponse;
  }

  // ==========================================
  // TOKEN HANDLING
  // ==========================================
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> _removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
