import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:music_player/layers/data/dto/user_dto.dart';
import 'package:music_player/layers/data/source/network/user_network.dart';

import '../../../../utils/strings.dart';
import '../../../domain/entity/user.dart';

class UserNetworkImpl implements UserNetwork {
  final String baseUrl = 'http://192.168.1.11:8080/user';

  @override
  Future<bool> registerUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 409) {
        // Handle unique constraint violation
        throw Exception(Strings.usernameExisted);
      } else {
        throw Exception('${Strings.errorOccurred}: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<UserDto> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // User registered successfully
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        UserDto authenticatedUser = UserDto.fromJson(responseData);
        return authenticatedUser;
      } else if (response.statusCode == 401) {
        throw Exception(Strings.wrongUsernameOrPassword);
      } else {
        throw Exception('${Strings.errorOccurred}: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<bool> updateUser(User user) async {
    final url = Uri.parse('$baseUrl/update');
    UserDto userDto = UserDto.fromUser(user);
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            userDto.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('${Strings.errorOccurred}: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }
}
