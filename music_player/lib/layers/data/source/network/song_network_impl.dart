import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:music_player/layers/data/dto/song_dto.dart';
import 'package:music_player/layers/data/source/network/song_network.dart';

import '../../../../utils/strings.dart';

class SongNetworkImpl extends SongNetwork{
  final String baseUrl = 'http://192.168.1.14:8080/song';

  @override
  Future<List<SongDto>> getNewSongs(int pageNumber, int pageSize) async {
    final url = Uri.parse('$baseUrl/new?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((song) => SongDto.fromJson(song)).toList();
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
  Future<List<SongDto>> getPopularSongs(int pageNumber, int pageSize) async {
    final url = Uri.parse('$baseUrl/popular?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((song) => SongDto.fromJson(song)).toList();
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
  Future<List<SongDto>> getRecentListenSongs(int userId, int pageNumber, int pageSize) async {
    try {
      final url = Uri.parse('$baseUrl/listen_history?userId=$userId&pageNumber=$pageNumber&pageSize=$pageSize');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((song) => SongDto.fromJson(song)).toList();;
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
  Future<List<SongDto>> getSongsInPlaylist(int playlistId, int pageNumber, int pageSize) async {
    try {
      final url = Uri.parse('$baseUrl/in_playlist?playlistId=$playlistId&pageNumber=$pageNumber&pageSize=$pageSize');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('4567');
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((song) => SongDto.fromJson(song)).toList();;
      } else {
        print('123456');
        throw Exception('${Strings.errorOccurred}: ${response.statusCode}');
      }
    } on SocketException {
      print('SocketException');
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      print('TimeoutException');
      // Handle timeout errors
      throw Exception(Strings.timeout);
    }
  }
}