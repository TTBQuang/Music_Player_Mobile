import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:music_player/layers/data/dto/paginated_response_dto.dart';
import 'package:music_player/layers/data/dto/singer_dto.dart';
import 'package:music_player/layers/data/source/network/singer_network.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/strings.dart';

class SingerNetworkImpl extends SingerNetwork{
  final String baseUrl = 'http://192.168.1.13:8080/singer';

  @override
  Future<PaginatedResponseDto> getSingerByName(String name, int pageNumber, int pageSize) async {
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
        final List<SingerDto> singerDtoList = items.map((song) => SingerDto.fromJson(song)).toList();

        // Create PaginatedResponseDto with the mapped items and totalItems
        return PaginatedResponseDto(items: singerDtoList, totalItems: totalItems);
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
  Future<List<SingerDto>> getAllSingers() async {
    try {
      final url = Uri.parse('$baseUrl/get_all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((singer) => SingerDto.fromJson(singer)).toList();
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