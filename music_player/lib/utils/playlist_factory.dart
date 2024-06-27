import 'package:music_player/layers/domain/entity/paginated_response.dart';
import 'package:music_player/layers/domain/repository/playlist_repository.dart';
import 'package:music_player/layers/domain/repository/song_repository.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/strings.dart';

import '../layers/data/dto/song_dto.dart';
import '../layers/domain/entity/playlist.dart';
import '../layers/domain/entity/song.dart';

// get List<Song> and Playlist base on PlayListType in main screen
enum PlayListType {
  newReleaseSong(Strings.newRelease, Constants.newSongsPlaylistId),
  listenRecentlySong(
      Strings.listenRecently, Constants.recentListenSongsPlaylistId),
  popularSong(Strings.popular, Constants.popularSongsPlaylistId),
  genrePlaylist(Strings.genre, null),
  singerPlaylist(Strings.singer, null);

  final String title;
  final int? id;

  const PlayListType(this.title, this.id);
}

class PlaylistFactory {
  final SongRepository songRepository;
  final PlaylistRepository playlistRepository;

  PlaylistFactory(
      {required this.songRepository, required this.playlistRepository});

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
      {required PlayListType playListType,
      required int pageNumber,
      required int pageSize,
      required int? userId}) {
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

  Future<Playlist?> getPlaylistByPlayListType(
      PlayListType playListType, int? userId) async {
    PaginatedResponse? value;
    Playlist? playlist;

    if (playListType.id != null) {
      value = await getList(
          playListType: playListType,
          pageNumber: 0,
          pageSize: Constants.maxPageSize,
          userId: userId);

      playlist = Playlist(
          id: playListType.id!,
          name: playListType.title,
          image: '',
          totalItems: value.totalItems);

      List<SongDto> songDtoList = value.items as List<SongDto>;
      List<Song> songList = [];
      for (SongDto songDto in songDtoList) {
        songList.add(Song.fromSongDto(songDto, userId));
      }
      playlist.songList.addAll(songList);
    }

    return playlist;
  }
}
