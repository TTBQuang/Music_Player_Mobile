import 'package:music_player/layers/data/dto/paginated_response_dto.dart';
import 'package:music_player/layers/data/dto/song_dto.dart';

abstract class SongNetwork{
  Future<PaginatedResponseDto> getNewSongs(int pageNumber, int pageSize);
  Future<PaginatedResponseDto> getPopularSongs(int pageNumber, int pageSize);
  Future<PaginatedResponseDto> getRecentListenSongs(int userId, int pageNumber, int pageSize);
  Future<List<SongDto>> getSongsInPlaylist(int playlistId, int pageNumber, int pageSize);
  Future<PaginatedResponseDto> getSongByName(String name, int pageNumber, int pageSize);
  Future<SongDto> getSongById(int id);
  Future<void> likeSong(int userId, int songId);
  Future<void> unlikeSong(int userId, int songId);
  Future<void> saveSong(int userId, int songId);
  Future<void> removeSongFromFavorite(int userId, int songId);
  Future<List<SongDto>> getFavoriteSongs(int userId);
}