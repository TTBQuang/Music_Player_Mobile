import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/layers/domain/repository/playlist_repository.dart';
import 'package:music_player/layers/domain/repository/search_history_repository.dart';
import 'package:music_player/layers/domain/repository/singer_repository.dart';
import 'package:music_player/layers/domain/repository/song_repository.dart';
import 'package:music_player/utils/constants.dart';

import '../../../utils/strings.dart';
import '../../domain/entity/paginated_response.dart';
import '../../domain/entity/search_history.dart';

enum SearchType {
  song(Strings.song),
  singer(Strings.singer);

  final String title;

  const SearchType(this.title);
}

class SearchViewModel extends ChangeNotifier {
  SongRepository songRepository;
  SearchHistoryRepository searchHistoryRepository;
  PlaylistRepository playlistRepository;
  SingerRepository singerRepository;

  List<dynamic> items = [];
  int maxPage = 0;

  SearchViewModel(
      {required this.songRepository,
      required this.searchHistoryRepository,
      required this.singerRepository,
      required this.playlistRepository});

  Future<void> getItemByName(
      SearchType searchType, String name, int pageNumber, int pageSize) async {
    late PaginatedResponse response;

    // get items list base on searchType (song or singer)
    switch (searchType) {
      case SearchType.song:
        response =
            await songRepository.getSongByName(name, pageNumber - 1, pageSize);
        break;
      case SearchType.singer:
        response = await singerRepository.getSingerByName(
            name, pageNumber - 1, pageSize);
        break;
      default:
        return;
    }
    items.clear();
    items.addAll(response.items);
    maxPage = (response.totalItems / Constants.pageSizeSearchSongScreen).ceil();
    notifyListeners();
  }

  Future<Playlist> getPlaylistBySingerId(int singerId) {
    return playlistRepository.getPlaylistBySingerId(singerId);
  }

  Future<List<SearchHistory>> getSearchHistory(
      int userId, int pageNumber, int pageSize) {
    return searchHistoryRepository.getSearchHistory(
        userId, pageNumber, pageSize);
  }

  Future<void> saveSearchHistory(SearchHistory searchHistory) async {
    searchHistoryRepository.saveSearchHistory(searchHistory);
  }
}
