import '../entity/paginated_response.dart';
import '../entity/song.dart';

abstract class SongRepository{
  Future<PaginatedResponse> getNewSongs(int pageNumber, int pageSize);
  Future<PaginatedResponse> getPopularSongs(int pageNumber, int pageSize);
  Future<PaginatedResponse> getRecentListenSongs(int userId, int pageNumber, int pageSize);
  Future<List<Song>> getSongsInPlaylist(int playlistId, int pageNumber, int pageSize);
  Future<PaginatedResponse> getSongByName(String name, int pageNumber, int pageSize);
}