import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/layers/data/source/network/search_history_network.dart';
import 'package:music_player/layers/domain/entity/search_history.dart';

import '../../../../utils/strings.dart';
import '../../dto/search_history_dto.dart';

class SearchHistoryNetworkImpl extends SearchHistoryNetwork {
  final String baseUrl = 'http://192.168.1.14:8080/search_history';

  @override
  Future<List<SearchHistoryDto>> getSearchHistory(
      int userId, int pageNumber, int pageSize) async {
    final url = Uri.parse(
        '$baseUrl/get?userId=$userId&pageNumber=$pageNumber&pageSize=$pageSize');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<SearchHistoryDto> searchHistory =
            jsonData.map((item) => SearchHistoryDto.fromJson(item)).toList();

        return searchHistory;
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
  Future<void> saveSearchHistory(SearchHistoryDto searchHistory) async {
    final url = Uri.parse('$baseUrl/save');
    print('id: ${searchHistory.user.id}');
    try {
      http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(searchHistory.toJson()),
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      if (kDebugMode) {
        print('Error save search history: $e');
      }
    }
  }
}
