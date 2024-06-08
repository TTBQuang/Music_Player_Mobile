import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/repository/search_history_repository.dart';
import 'package:music_player/layers/domain/repository/song_repository.dart';
import 'package:music_player/utils/constants.dart';

import '../../domain/entity/paginated_response.dart';
import '../../domain/entity/search_history.dart';
import '../../domain/entity/song.dart';

class SearchSongViewModel extends ChangeNotifier {
  SongRepository songRepository;
  SearchHistoryRepository searchHistoryRepository;
  List<Song> songs = [];
  late int maxPage;

  SearchSongViewModel({required this.songRepository, required this.searchHistoryRepository});

  Future<void> getSongByName(String name, int pageNumber, int pageSize) async {
    PaginatedResponse response =
        await songRepository.getSongByName(name, pageNumber - 1, pageSize);
    songs.clear();
    songs.addAll(response.items as Iterable<Song>);
    maxPage = (response.totalItems / Constants.pageSizeSearchSongScreen).ceil();
    notifyListeners();
  }

  Future<List<SearchHistory>> getSearchHistory(int userId, int pageNumber, int pageSize) {
    return searchHistoryRepository.getSearchHistory(userId, pageNumber, pageSize);
  }

  Future<void> saveSearchHistory(SearchHistory searchHistory) async {
    searchHistoryRepository.saveSearchHistory(searchHistory);
  }
}
