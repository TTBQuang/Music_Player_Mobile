import 'package:music_player/layers/domain/entity/search_history.dart';

abstract class SearchHistoryRepository{
  Future<List<SearchHistory>> getSearchHistory(int userId, int pageNumber, int pageSize);
  Future<void> saveSearchHistory(SearchHistory searchHistory);
}