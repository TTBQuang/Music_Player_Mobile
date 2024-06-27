import 'package:music_player/layers/data/dto/search_history_dto.dart';
import 'package:music_player/layers/domain/entity/user.dart';

class SearchHistory {
  int? id;
  User user;
  String query;
  DateTime time;

  SearchHistory({required this.id, required this.user, required this.query, required this.time});

  factory SearchHistory.fromPlaylistDto(SearchHistoryDto searchHistoryDto) {
    return SearchHistory(
      id: searchHistoryDto.id,
      user: User.fromUserDto(searchHistoryDto.user),
      query: searchHistoryDto.query,
      time: searchHistoryDto.time,
    );
  }
}