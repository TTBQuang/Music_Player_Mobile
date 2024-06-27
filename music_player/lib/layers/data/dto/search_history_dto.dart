import 'dart:convert';

import 'package:music_player/layers/data/dto/user_dto.dart';

import '../../domain/entity/search_history.dart';
import '../../domain/entity/user.dart';

class SearchHistoryDto {
  int? id;
  UserDto user;
  String query;
  DateTime time;

  SearchHistoryDto({required this.id, required this.user, required this.query, required this.time});

  factory SearchHistoryDto.fromJson(Map<String, dynamic> json) {
    return SearchHistoryDto(
      id: json['id'] as int,
      user: UserDto.fromJson(json['user']),
      query: utf8.decode((json['query'] as String).codeUnits),
      time: DateTime.parse(json['time'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user.toJson(),
    'query': query,
    'time': time.toIso8601String(),
  };

  factory SearchHistoryDto.fromSearchHistory(SearchHistory searchHistory) {
    return SearchHistoryDto(
      id: searchHistory.id,
      user: UserDto.fromUser(searchHistory.user),
      query: searchHistory.query,
      time: searchHistory.time
    );
  }
}