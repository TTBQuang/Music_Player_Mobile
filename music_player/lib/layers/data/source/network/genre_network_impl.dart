import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:music_player/layers/data/dto/genre_dto.dart';
import 'package:music_player/layers/data/source/network/genre_network.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/strings.dart';

class GenreNetworkImpl extends GenreNetwork {
  final String baseUrl = 'http://192.168.1.13:8080/genre';

  @override
  Future<List<GenreDto>> getAllGenres() async {
    try {
      final url = Uri.parse('$baseUrl/get_all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((genre) => GenreDto.fromJson(genre)).toList();
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