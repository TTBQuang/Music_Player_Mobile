import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:music_player/layers/data/dto/playlist_dto.dart';
import 'package:music_player/layers/data/source/network/playlist_network.dart';

import '../../../../utils/strings.dart';
import '../../dto/paginated_response_dto.dart';

class PlaylistNetworkImpl extends PlaylistNetwork{
  final String baseUrl = 'http://192.168.1.13:8080/playlist';

  @override
  Future<PaginatedResponseDto> getGenrePlaylist(int pageNumber, int pageSize) async {
    final url = Uri.parse('$baseUrl/all/genre?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<PlaylistDto> songDtoList = items.map((playlist) => PlaylistDto.fromJson(playlist)).toList();

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
  Future<PaginatedResponseDto> getSingerPlaylist(int pageNumber, int pageSize) async {
    final url = Uri.parse('$baseUrl/all/singer?pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Extract the items and totalItems from the JSON response
        final List<dynamic> items = jsonResponse['items'];
        final int totalItems = jsonResponse['total_items'];

        // Map each item in the response to SongDto
        final List<PlaylistDto> songDtoList = items.map((playlist) => PlaylistDto.fromJson(playlist)).toList();

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
  Future<PlaylistDto> getPlaylistBySingerId(int singerId) async {
    final url = Uri.parse('$baseUrl/singer?singerId=$singerId');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return PlaylistDto.fromJson(jsonResponse);
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