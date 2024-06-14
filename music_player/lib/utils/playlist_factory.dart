import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/domain/repository/playlist_repository.dart';
import 'package:music_player/layers/domain/repository/song_repository.dart';
import 'package:music_player/layers/presentation/main_page/widget/main_home_screen.dart';
import 'package:music_player/utils/strings.dart';

import '../layers/domain/entity/playlist.dart';

enum PlayListType {
  newReleaseSong(Strings.newRelease),
  listenRecentlySong(Strings.listenRecently),
  popularSong(Strings.popular),
  genrePlaylist(Strings.genre),
  singerPlaylist(Strings.singer);

  final String title;

  const PlayListType(this.title);
}

class PlaylistFactory {
  final SongRepository songRepository;
  final PlaylistRepository playlistRepository;

  PlaylistFactory({required this.songRepository, required this.playlistRepository});

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
  {required PlayListType playListType, required int pageNumber, required int pageSize, required int? userId}) {
    switch (playListType) {
      case PlayListType.newReleaseSong:
        return getNewSongs(pageNumber, pageSize);
      case PlayListType.listenRecentlySong:
        return getRecentListenSongs(
            pageNumber: pageNumber, pageSize: pageSize, userId: userId ?? 0);
      case PlayListType.popularSong:
        return getPopularSongs(pageNumber, pageSize);
      case PlayListType.genrePlaylist:
        return getGenrePlaylist(pageNumber, pageSize);
      case PlayListType.singerPlaylist:
        return getSingerPlaylist(pageNumber, pageSize);
    }
  }
}
