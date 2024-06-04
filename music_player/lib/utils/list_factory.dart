import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/domain/repository/playlist_repository.dart';
import 'package:music_player/layers/domain/repository/song_repository.dart';
import 'package:music_player/layers/presentation/main_page/widget/main_home_screen.dart';

import '../layers/domain/entity/playlist.dart';

class ListFactory {
  final SongRepository songRepository;
  final PlaylistRepository playlistRepository;

  ListFactory({required this.songRepository, required this.playlistRepository});

  Future<PaginatedResponse> getNewSongs(int pageNumber, int pageSize) {
    return songRepository.getNewSongs(pageNumber, pageSize);
  }

  Future<PaginatedResponse> getPopularSongs(int pageNumber, int pageSize) {
    return songRepository.getPopularSongs(pageNumber, pageSize);
  }

  Future<PaginatedResponse> getRecentListenSongs(
      {required int userId, required int pageNumber, required int pageSize}) {
    return songRepository.getRecentListenSongs(userId, pageNumber, pageSize);
  }

  Future<PaginatedResponse> getGenrePlaylist(int pageNumber, int pageSize) {
    return playlistRepository.getGenrePlaylist(pageNumber, pageSize);
  }

  Future<PaginatedResponse> getSingerPlaylist(int pageNumber, int pageSize) {
    return playlistRepository.getSingerPlaylist(pageNumber, pageSize);
  }

  Future<PaginatedResponse> getList(
      ListType listType, int pageNumber, int pageSize, int? userId) {
    switch (listType) {
      case ListType.newReleaseSong:
        return getNewSongs(pageNumber, pageSize);
      case ListType.listenRecentlySong:
        return getRecentListenSongs(
            pageNumber: pageNumber, pageSize: pageSize, userId: userId ?? 0);
      case ListType.popularSong:
        return getPopularSongs(pageNumber, pageSize);
      case ListType.genrePlaylist:
        return getGenrePlaylist(pageNumber, pageSize);
      case ListType.singerPlaylist:
        return getSingerPlaylist(pageNumber, pageSize);
    }
  }
}
