import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:music_player/layers/data/dto/playlist_dto.dart';
import 'package:music_player/layers/data/source/network/playlist_network.dart';

import '../../../../utils/strings.dart';

class PlaylistNetworkImpl extends PlaylistNetwork{
  final String baseUrl = 'http://192.168.1.14:8080/playlist';

  @override
  Future<List<PlaylistDto>> getGenrePlaylist(int pageNumber, int pageSize) async {
    final url = Uri.parse('$baseUrl/genre?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((playlist) => PlaylistDto.fromJson(playlist)).toList();
      } else {
        throw Exception('${Strings.errorOccurred}: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    }
  }

  @override
  Future<List<PlaylistDto>> getSingerPlaylist(int pageNumber, int pageSize) async {
    final url = Uri.parse('$baseUrl/singer?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((playlist) => PlaylistDto.fromJson(playlist)).toList();
      } else {
        throw Exception('${Strings.errorOccurred}: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    }
  }
}