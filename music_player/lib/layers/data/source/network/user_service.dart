import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://192.168.1.11:8080/user';

  Future<void> registerUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('User registered successfully');
    } else if (response.statusCode == 409) {
      // Handle unique constraint violation
      throw Exception('Tên đăng nhập đã tồn tại');
    } else {
      throw Exception('Failed to register user: ${response.statusCode}');
    }
  }
}
