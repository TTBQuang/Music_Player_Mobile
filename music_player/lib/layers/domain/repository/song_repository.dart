import '../entity/song.dart';

abstract class SongRepository{
  Future<List<Song>> getNewSongs(int pageNumber, int pageSize);
  Future<List<Song>> getPopularSongs(int pageNumber, int pageSize);
  Future<List<Song>> getRecentListenSongs(int userId, int pageNumber, int pageSize);
  Future<List<Song>> getSongsInPlaylist(int playlistId, int pageNumber, int pageSize);
}