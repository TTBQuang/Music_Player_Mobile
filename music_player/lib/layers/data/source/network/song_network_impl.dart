import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:music_player/layers/data/dto/song_dto.dart';
import 'package:music_player/layers/data/dto/uploaded_song_dto.dart';
import 'package:music_player/layers/data/source/network/song_network.dart';

import '../../../../utils/strings.dart';
import '../../dto/paginated_response_dto.dart';

class SongNetworkImpl extends SongNetwork {
  final String baseUrl = 'http://192.168.1.13:8080/song';

  @override
  Future<PaginatedResponseDto> getNewSongs(int pageNumber, int pageSize) async {
    final url =
        Uri.parse('$baseUrl/new?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<SongDto> songDtoList =
            items.map((song) => SongDto.fromJson(song)).toList();

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
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<PaginatedResponseDto> getPopularSongs(
      int pageNumber, int pageSize) async {
    final url =
        Uri.parse('$baseUrl/popular?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<SongDto> songDtoList =
            items.map((song) => SongDto.fromJson(song)).toList();

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
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<PaginatedResponseDto> getRecentListenSongs(
      int userId, int pageNumber, int pageSize) async {
    try {
      final url = Uri.parse(
          '$baseUrl/listen_history?userId=$userId&pageNumber=$pageNumber&pageSize=$pageSize');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<SongDto> songDtoList =
            items.map((song) => SongDto.fromJson(song)).toList();

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
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<List<SongDto>> getSongsInPlaylist(
      int playlistId, int pageNumber, int pageSize) async {
    try {
      final url = Uri.parse(
          '$baseUrl/in_playlist?playlistId=$playlistId&pageNumber=$pageNumber&pageSize=$pageSize');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
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
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<PaginatedResponseDto> getSongByName(
      String name, int pageNumber, int pageSize) async {
    try {
      final url = Uri.parse(
          '$baseUrl/find?name=$name&pageNumber=$pageNumber&pageSize=$pageSize');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<SongDto> songDtoList =
            items.map((song) => SongDto.fromJson(song)).toList();

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
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<SongDto> getSongById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/find_by_id?id=$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        // Convert the JSON to a SongDto object
        final song = SongDto.fromJson(json);
        return song;
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
  Future<void> likeSong(int userId, int songId) async {
    try {
      final url = Uri.parse('$baseUrl/like?userId=$userId&songId=$songId');
      await http.post(url);
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
  Future<void> unlikeSong(int userId, int songId) async {
    try {
      final url = Uri.parse('$baseUrl/unlike?userId=$userId&songId=$songId');
      await http.delete(url);
    } on SocketException {
      // Handle network errors
      throw Exception('Cannot connect to the server');
    } on TimeoutException {
      // Handle timeout errors
      throw Exception('Request timed out');
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<void> saveSong(int userId, int songId) async {
    try {
      final url = Uri.parse('$baseUrl/save?userId=$userId&songId=$songId');
      await http.post(url);
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
  Future<void> removeSongFromFavorite(int userId, int songId) async {
    try {
      final url =
          Uri.parse('$baseUrl/remove_from_save?userId=$userId&songId=$songId');
      await http.delete(url);
    } on SocketException {
      // Handle network errors
      throw Exception('Cannot connect to the server');
    } on TimeoutException {
      // Handle timeout errors
      throw Exception('Request timed out');
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<List<SongDto>> getFavoriteSongs(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/saved?userId=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
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
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<bool> uploadSong(UploadedSongDto uploadedSong) async {
    try {
      final url = Uri.parse('$baseUrl/upload');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(uploadedSong.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
