import 'package:music_player/layers/domain/entity/search_history.dart';

import '../../dto/search_history_dto.dart';

abstract class SearchHistoryNetwork{
  Future<List<SearchHistoryDto>> getSearchHistory(int userId, int pageNumber, int pageSize);
  Future<void> saveSearchHistory(SearchHistoryDto searchHistory);
}