import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/layers/data/dto/listen_history_dto.dart';

import 'listen_history_network.dart';

class ListenHistoryNetworkImpl extends ListenHistoryNetwork {
  final String baseUrl = 'http://192.168.1.13:8080/listen_history';

  @override
  Future<void> saveListenHistory(ListenHistoryDto listenHistory) async {
    final url = Uri.parse('$baseUrl/save');
    try {
      http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(listenHistory.toJson()),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      if (kDebugMode) {
        print('Error save listen history: $e');
      }
    }
  }
}
