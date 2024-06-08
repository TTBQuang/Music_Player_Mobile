import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:music_player/layers/data/dto/song_dto.dart';
import 'package:music_player/layers/data/source/network/song_network.dart';

import '../../../../utils/strings.dart';
import '../../dto/paginated_response_dto.dart';

class SongNetworkImpl extends SongNetwork{
  final String baseUrl = 'http://192.168.1.14:8080/song';

  @override
  Future<PaginatedResponseDto> getNewSongs(int pageNumber, int pageSize) async {
    final url = Uri.parse('$baseUrl/new?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<SongDto> songDtoList = items.map((song) => SongDto.fromJson(song)).toList();

        // Create PaginatedResponseDto with the mapped items and totalItems
        return PaginatedResponseDto(items: songDtoList, totalItems: totalItems);
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
  Future<PaginatedResponseDto> getPopularSongs(int pageNumber, int pageSize) async {
    final url = Uri.parse('$baseUrl/popular?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<SongDto> songDtoList = items.map((song) => SongDto.fromJson(song)).toList();

        // Create PaginatedResponseDto with the mapped items and totalItems
        return PaginatedResponseDto(items: songDtoList, totalItems: totalItems);
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
  Future<PaginatedResponseDto> getRecentListenSongs(int userId, int pageNumber, int pageSize) async {
    try {
      final url = Uri.parse('$baseUrl/listen_history?userId=$userId&pageNumber=$pageNumber&pageSize=$pageSize');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<SongDto> songDtoList = items.map((song) => SongDto.fromJson(song)).toList();

        // Create PaginatedResponseDto with the mapped items and totalItems
        return PaginatedResponseDto(items: songDtoList, totalItems: totalItems);
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
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((song) => SongDto.fromJson(song)).toList();;
      } else {
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

  @override
  Future<PaginatedResponseDto> getSongByName(String name, int pageNumber, int pageSize) async {
    try {
      final url = Uri.parse('$baseUrl/find?name=$name&pageNumber=$pageNumber&pageSize=$pageSize');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<SongDto> songDtoList = items.map((song) => SongDto.fromJson(song)).toList();

        // Create PaginatedResponseDto with the mapped items and totalItems
        return PaginatedResponseDto(items: songDtoList, totalItems: totalItems);
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