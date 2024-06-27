import 'package:music_player/layers/data/dto/search_history_dto.dart';
import 'package:music_player/layers/data/source/network/search_history_network.dart';

import '../../domain/entity/search_history.dart';
import '../../domain/repository/search_history_repository.dart';

class SearchHistoryRepositoryImpl extends SearchHistoryRepository {
  final SearchHistoryNetwork searchHistoryNetwork;

  SearchHistoryRepositoryImpl(this.searchHistoryNetwork);

  @override
  Future<List<SearchHistory>> getSearchHistory(
      int userId, int pageNumber, int pageSize) async {
    List<SearchHistoryDto> list = await searchHistoryNetwork.getSearchHistory(
        userId, pageNumber, pageSize);
    // convert to List<SearchHistory>
    List<SearchHistory> result = [];
    for (SearchHistoryDto searchHistoryDto in list) {
      result.add(SearchHistory.fromPlaylistDto(searchHistoryDto));
    }
    return result;
  }

  @override
  Future<void> saveSearchHistory(SearchHistory searchHistory) async {
    searchHistoryNetwork
        .saveSearchHistory(SearchHistoryDto.fromSearchHistory(searchHistory));
  }
}
