import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get baseUrl => 'https://finance-tracker-vynh.onrender.com';
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'auth_username';

  static String? _token;
  static String? _username;

  static bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  static String? get currentUsername => _username;

  static Future<void> initializeSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _username = prefs.getString(_usernameKey);
  }

  static Future<void> logout() async {
    _token = null;
    _username = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _jsonHeaders(),
      body: jsonEncode({'username': username.trim(), 'password': password}),
    );

    return _saveAuthFromResponse(response);
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _jsonHeaders(),
      body: jsonEncode({'username': username.trim(), 'password': password}),
    );

    return _saveAuthFromResponse(response);
  }

  static Future<void> addExpense(String amount, String category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: _authorizedHeaders(),
      body: jsonEncode({'amount': amount, 'category': category}),
    );

    _decodeResponse(response);
  }

  static Future<List<dynamic>> fetchExpenses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/expenses'),
      headers: _authorizedHeaders(includeJson: false),
    );
    return List<dynamic>.from(_decodeResponse(response));
  }

  static Future<void> deleteExpense(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/expense/$id'),
      headers: _authorizedHeaders(includeJson: false),
    );

    _decodeResponse(response);
  }

  static Map<String, String> _jsonHeaders() {
    return {'Content-Type': 'application/json'};
  }

  static Map<String, String> _authorizedHeaders({bool includeJson = true}) {
    if (_token == null) {
      throw Exception('User is not authenticated.');
    }

    return {
      if (includeJson) 'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };
  }

  static Future<Map<String, dynamic>> _saveAuthFromResponse(
    http.Response response,
  ) async {
    final data = Map<String, dynamic>.from(_decodeResponse(response));
    final token = data['token']?.toString();
    final user = Map<String, dynamic>.from(data['user'] as Map);

    if (token == null || token.isEmpty) {
      throw Exception('Missing authentication token.');
    }

    _token = token;
    _username = user['username']?.toString();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, _token!);
    if (_username != null) {
      await prefs.setString(_usernameKey, _username!);
    }

    return data;
  }

  static dynamic _decodeResponse(http.Response response) {
    final body = response.body.trim();
    final contentType = response.headers['content-type'] ?? '';

    if (body.isNotEmpty &&
        (body.startsWith('<!DOCTYPE') ||
            body.startsWith('<html') ||
            contentType.contains('text/html'))) {
      throw Exception(
        'Backend returned HTML instead of JSON. Make sure the Node API server is running on $baseUrl and the API endpoint is correct.',
      );
    }

    final dynamic data = body.isEmpty ? {} : jsonDecode(body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final message = data is Map<String, dynamic> && data['message'] != null
        ? data['message'].toString()
        : 'Request failed with status ${response.statusCode}.';
    throw Exception(message);
  }
}
