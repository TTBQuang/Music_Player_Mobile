import 'package:music_player/layers/data/source/network/song_network.dart';
import 'package:music_player/layers/domain/entity/song.dart';
import 'package:music_player/layers/domain/repository/song_repository.dart';

import '../../domain/entity/paginated_response.dart';
import '../dto/paginated_response_dto.dart';
import '../dto/song_dto.dart';

class SongRepositoryImpl extends SongRepository {
  final SongNetwork songNetwork;

  SongRepositoryImpl(this.songNetwork);

  @override
  Future<PaginatedResponse> getNewSongs(int pageNumber, int pageSize) async {
    PaginatedResponseDto responseDto =
        await songNetwork.getNewSongs(pageNumber, pageSize);
    return PaginatedResponse.fromPaginatedResponseDto(responseDto);
  }

  @override
  Future<PaginatedResponse> getPopularSongs(
      int pageNumber, int pageSize) async {
    PaginatedResponseDto responseDto =
        await songNetwork.getPopularSongs(pageNumber, pageSize);
    return PaginatedResponse.fromPaginatedResponseDto(responseDto);
  }

  @override
  Future<PaginatedResponse> getRecentListenSongs(
      int userId, int pageNumber, int pageSize) async {
    PaginatedResponseDto responseDto =
        await songNetwork.getRecentListenSongs(userId, pageNumber, pageSize);
    return PaginatedResponse.fromPaginatedResponseDto(responseDto);
  }

  @override
  Future<List<Song>> getSongsInPlaylist(
      int playlistId, int pageNumber, int pageSize) async {
    List<SongDto> list =
        await songNetwork.getSongsInPlaylist(playlistId, pageNumber, pageSize);
    // convert to List<Song>
    List<Song> result = [];
    for (SongDto songDto in list) {
      result.add(Song.fromSongDto(songDto, null));
    }
    return result;
  }

  @override
  Future<PaginatedResponse> getSongByName(
      String name, int pageNumber, int pageSize) async {
    PaginatedResponseDto responseDto =
        await songNetwork.getSongByName(name, pageNumber, pageSize);
    return PaginatedResponse.fromPaginatedResponseDto(responseDto);
  }

  @override
  Future<Song> getSongById(int songId, int? userId) async {
    SongDto songDto = await songNetwork.getSongById(songId);
    return Song.fromSongDto(songDto, userId);
  }

  @override
  Future<void> likeSong(int songId, int userId) async {
    songNetwork.likeSong(userId, songId);
  }

  @override
  Future<void> unlikeSong(int songId, int userId) async {
    songNetwork.unlikeSong(userId, songId);
  }

  @override
  Future<void> removeSongFromFavorite(int songId, int userId) async {
    songNetwork.removeSongFromFavorite(userId, songId);
  }

  @override
  Future<void> saveSong(int songId, int userId) async {
    songNetwork.saveSong(userId, songId);
  }

  @override
  Future<List<Song>> getFavoriteSong(int userId) async {
    List<SongDto> list =
        await songNetwork.getFavoriteSongs(userId);
    // convert to List<Song>
    List<Song> result = [];
    for (SongDto songDto in list) {
      result.add(Song.fromSongDto(songDto, null));
    }
    return result;
  }
}
